//
//  AnyRTCRoomController.m
//  AnyRTCBoard
//
//  Created by jh on 2018/10/8.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AnyRTCRoomController.h"
#import <AVFoundation/AVFoundation.h>

@interface AnyRTCRoomController ()<AnyRTCBoardViewDelegate>

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

@implementation AnyRTCRoomController{
    
    UIActivityIndicatorView *_activityIndicator;
    //画板
    AnyRTCBoardView *_boardView;
    //画笔
    AnyRTCBoardBrushModel _brushMode;
    
    NSArray *_toolArr;
    
    NSArray *_colorArr;
    
    NSArray *_sideArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _brushMode = AnyRTCBoardBrushModelTransform;
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
    _boardView = [[AnyRTCBoardView alloc] initWithRoomID:self.roomId withFileId:@"888888" withUserId:[self randomString:6] withUrlArray:imageArr];
    _boardView.backgroundColor = [UIColor lightGrayColor];
    CGRect drawFrame = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(16, 9), self.view.frame);
    _boardView.frame = drawFrame;
    _boardView.delegate = self;
    [_boardView setBrushModel:_brushMode];
    [self.view insertSubview:_boardView atIndex:0];
}

// MARK: - AnyRTCBoardViewDelegate

- (void)initBoardScuess{
    //画板初始化成功
    [_activityIndicator stopAnimating];
}

- (void)onBoardError:(AnyRTCBoardCode)nCode{
    //画板错误
    [_activityIndicator stopAnimating];
    WEAKSELF;
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:[self getErrorCode:nCode] cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        [weakSelf exitBoardRoom];
    }];
}

- (void)onBoardServerDisconnect{
    //画板断开
}

- (void)onBoardPageChange:(NSString*)imageUrl withCurrentPage:(int)currentPage withTotalPage:(int)totalPage{
    //画板翻页
    [self.pageButton setTitle:[NSString stringWithFormat:@"%02d/%02d",currentPage,totalPage] forState:UIControlStateNormal];
    (currentPage == 1) ? (self.leftButton.selected = YES) : (self.leftButton.selected = NO);
    (currentPage == totalPage) ? (self.rightButton.selected = YES) : (self.rightButton.selected = NO);
}

- (void)onBoardDrawsChangeTimestamp:(uint32_t)timestamp{
    //白板数据改变的时间（秒级）
    _bottomView.hidden = YES;
}

- (void)onBoardDestory{
    //销毁画板
    [_boardView removeFromSuperview];
}

// MARK: - Event

- (IBAction)handleBoard:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            //上一页
            [_boardView prePageWithSync:YES];
            break;
        case 101:
            //下一页
            [_boardView nextPageWithSync:YES];
            break;
        case 102:
            //侧边栏
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                self.marginX.constant = 0;
                (_brushMode == AnyRTCBoardBrushModelTransform) ? (_brushMode = AnyRTCBoardBrushModelGraffiti) : 0;
                [_boardView setBrushModel:_brushMode];
            } else {
                self.marginX.constant = self.menuStackView.frame.size.width;
                [_boardView setBrushModel:AnyRTCBoardBrushModelTransform];
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
        case 107:
            //撤销
            [_boardView undo];
            break;
        case 108:
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
        _brushMode = (AnyRTCBoardBrushModel) (sender.tag - 49);
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

//随机字符串
- (NSString*)randomString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
}

//错误信息
- (NSString *)getErrorCode:(AnyRTCBoardCode)code{
    switch (code) {
        case AnyRTCBoardCodeParameterError:
            return @"初始化错误";
            
        case AnyRTCBoardCodeNoNet:
            return @"网络已断开，请检查网络";
            
        case AnyRTCBoardCodeUserIdIsNull:
            return @"用户ID为空";
            
        case AnyRTCBoardCodeSessionPastDue:
            return @"session过期";
            
        case AnyRTCBoardCodeDeveloperInfoError:
            return @"开发者信息错误";
            
        case AnyRTCBoardCodeDeveloperArrearage:
            return @"欠费";
            
        case AnyRTCBoardCodeDeveloperNotOpen:
            return @"用户未开通该功能";
            
        case AnyRTCBoardCodeDatabaseError:
            return @"数据库异常";
            
        default:
            break;
    }
    return nil;
}

@end
