//
//  ArRoomViewController.m
//  AnyRTCBoard
//
//  Created by 余生丶 on 2019/5/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArRoomViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ArRoomViewController ()<ARBoardViewDelegate>

@property (weak, nonatomic) IBOutlet UIStackView *menuStackView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginX;
@property (weak, nonatomic) IBOutlet UIButton *pageButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//工具
@property (weak, nonatomic) IBOutlet UIButton *toolButton;
//颜色
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
//粗细
@property (weak, nonatomic) IBOutlet UIButton *sideButton;

@property (strong, nonatomic) UIStackView *stackView;

@end

@implementation ArRoomViewController{
    UIActivityIndicatorView *_activityIndicator;
    //画板
    ARBoardView *_boardView;
    //画笔
    ARBoardBrushModel _brushMode;
    NSArray *_toolArr;
    NSArray *_colorArr;
    NSArray *_sideArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.isTeacher ? (_brushMode = ARBoardBrushModelTransformSync) : (_brushMode = ARBoardBrushModelTransform);
    
    //工具、颜色、粗细
    _toolArr = @[@"brush_unSelected",@"arrow_unSelected",@"line_unSelected",@"box_unSelected"];
    _colorArr = @[@"brush_black",@"brush_blue",@"brush_green",@"brush_red"];
    _sideArr = @[@"brush_thickness0",@"brush_thickness1",@"brush_thickness2",@"brush_thickness3"];
    self.view.backgroundColor = [UIColor blackColor];
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    _activityIndicator.frame = CGRectMake((CGRectGetHeight(self.view.frame) - 100)/2, (CGRectGetWidth(self.view.frame) - 100)/2, 100, 100);
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityIndicator.backgroundColor = RGBA(0, 0, 0, 0.4);
    _activityIndicator.layer.cornerRadius = 10;
    _activityIndicator.layer.masksToBounds = YES;
    [_activityIndicator startAnimating];
    [self.view addSubview:_activityIndicator];
}

- (void)initializeBoard{
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:27];
    for (NSInteger i = 1; i <= 27; i++) {
        [imageArr addObject:[NSString stringWithFormat:@"http://oss.teameeting.cn/docs/140248771/20180929173501062526/document_20180929173501536430_%ld.jpg",(long)i]];
    }
    
    //初始化画板
    _boardView = [[ARBoardView alloc] initWithRoomID:self.roomId withFileId:@"88888888" withUserId:[[ArCommon getUUID]substringToIndex:6] withUrlArray:imageArr];
    _boardView.backgroundColor = [UIColor lightGrayColor];
    CGRect drawFrame = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(16, 9), self.view.frame);
    _boardView.frame = drawFrame;
    _boardView.delegate = self;
    [_boardView setBrushModel:_brushMode];
    [self.view insertSubview:_boardView atIndex:0];
}

// MARK: - ARBoardViewDelegate

- (void)initBoardScuess {
    //画板初始化成功
    [_activityIndicator stopAnimating];
}

- (void)onBoardError:(ARBoardCode)nCode {
    //画板错误
    [_activityIndicator stopAnimating];
    WEAKSELF;
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:[ArCommon getErrorCode:nCode] cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        [weakSelf exitBoardRoom];
    }];
}

- (void)onBoardServerDisconnect {
    //画板断开
}

- (void)onBoardPageChange:(NSString *)imageUrl withCurrentPage:(int)currentPage withTotalPage:(int)totalPage {
    //画板翻页
    [self.pageButton setTitle:[NSString stringWithFormat:@"%02d/%02d",currentPage,totalPage] forState:UIControlStateNormal];
    (currentPage == 1) ? (self.leftButton.selected = YES) : (self.leftButton.selected = NO);
    (currentPage == totalPage) ? (self.rightButton.selected = YES) : (self.rightButton.selected = NO);
}

- (void)onBoardMessage:(NSString *)message {
    //消息回调
}

- (void)onBoardDrawsChangeTimestamp:(uint32_t)timestamp {
    //白板数据改变的时间（秒级）
    _bottomView.hidden = YES;
}

- (void)onBoardDestory {
    //销毁画板
    if (!self.isTeacher) {
        [self exitBoardRoom];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showInfoWithStatus:@"课堂已结束"];
        });
    }
}

// MARK: - Event

- (IBAction)handleBoard:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            //上一页
            [_boardView prePageWithSync:self.isTeacher];
            break;
        case 101:
            //下一页
            [_boardView nextPageWithSync:self.isTeacher];
            break;
        case 102:
            //侧边栏
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                self.marginX.constant = 0;
                (_brushMode == ARBoardBrushModelTransform || _brushMode == ARBoardBrushModelTransformSync) ? (_brushMode = ARBoardBrushModelGraffiti) : 0;
                [_boardView setBrushModel:_brushMode];
            } else {
                self.marginX.constant = self.menuStackView.frame.size.width;
                self.isTeacher ? ([_boardView setBrushModel:ARBoardBrushModelTransformSync]) : ([_boardView setBrushModel:ARBoardBrushModelTransform]);
                _bottomView.hidden = YES;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
            break;
        case 103:
            //退出
            [self exitBoardRoom];
            break;
        case 104:
            //撤销
            [_boardView undo];
            break;
        case 105:
            //清空当前
            [_boardView clearCurrentDraw];
            //清空所有
            //[_boardView clearAllDraws];
            break;
        default:
            break;
    }
}

- (IBAction)bouncedBottom:(UIButton *)sender {
    //选择工具、画笔、粗细
    self.bottomView.hidden = NO;
    [self.stackView removeFromSuperview];
    self.stackView = nil;
    [self.bottomView addSubview:self.stackView];
    
    NSMutableArray *arr;
    
    if (sender.tag == 50) {
        arr = [NSMutableArray arrayWithArray:_toolArr];
    } else {
        (sender.tag == 60) ? (arr = [NSMutableArray arrayWithArray:_colorArr]) : (arr = [NSMutableArray arrayWithArray:_sideArr]);
    }
    
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 50);
        button.tag = sender.tag + i;
        [button setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doSomethingEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.stackView addArrangedSubview:button];
    }
}

- (void)doSomethingEvent:(UIButton *)sender{
    
    self.bottomView.hidden = YES;
    if (sender.tag < 60) {
        //设置画笔类型
        _brushMode = (ARBoardBrushModel) (sender.tag - 49);
        [_boardView setBrushModel:_brushMode];
        [self.toolButton setImage:[UIImage imageNamed:_toolArr[sender.tag - 50]] forState:UIControlStateNormal];
    } else if (sender.tag < 70) {
        //设置画笔颜色
        NSArray *arr = @[AnyRTCBoard_Color_Black,AnyRTCBoard_Color_Blue,AnyRTCBoard_Color_green,AnyRTCBoard_Color_Red];
        [_boardView setBrushColor:arr[sender.tag - 60]];
        [self.colorButton setImage:[UIImage imageNamed:_colorArr[sender.tag - 60]] forState:UIControlStateNormal];
    } else {
        //设置画笔粗细
        [_boardView setBrushWidth:(int)((sender.tag - 69) * 2)];
        [self.sideButton setImage:[UIImage imageNamed:_sideArr[sender.tag - 70]] forState:UIControlStateNormal];
    }
}

- (void)exitBoardRoom {
    if (self.isTeacher) {
        [_boardView destoryBoard];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        appDelegate.allowRotation = NO;
        [self toOrientation:UIInterfaceOrientationPortrait];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

// MARK: - other

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self initializeBoard];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.marginX.constant = self.menuStackView.frame.size.width;
    self.bottomView.hidden = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    appDelegate.allowRotation = YES;
    [self toOrientation:UIInterfaceOrientationLandscapeRight];
    
    [self.menuStackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
        }
    }];
}

- (UIStackView *)stackView{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(30, 0, 240, 44)];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _stackView;
}

@end
