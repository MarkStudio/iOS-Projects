//
//  VKSCodeScanViewController.m
//  VKStaffAssistant
//
//  Created by Mark Yang on 11/01/2017.
//  Copyright © 2017 Vanke. All rights reserved.
//

#import "VKSCodeScanViewController.h"
#import <Masonry.h>

#define SHADOW_COLOR      [UIColor colorWithWhite:0.0 alpha:0.5]

static CGFloat kTopMargin = 28.0;
//static CGFloat kTopInterval = 100;//170.0;
#define kTopInterval ((SCREEN_HEIGHT <= 480) ? 100 : 170)
static CGFloat kLeftPadding = 15.0;
static CGFloat kRightPadding = 15.0;
static CGFloat kTipTopPadding = 15.0;

@interface VKSCodeScanViewController ()

@property (nonatomic, strong) UIButton      *btnCancel;
@property (nonatomic, strong) UIButton      *btnLight;

@property (nonatomic, strong) UIImageView   *scanScopeView;
@property (nonatomic, strong) UIView        *topShadowView;
@property (nonatomic, strong) UIView        *leftShadowView;
@property (nonatomic, strong) UIView        *bottomShadowView;
@property (nonatomic, strong) UIView        *rightShadowView;
@property (nonatomic, strong) UILabel       *lbDecoded;
@property (nonatomic, strong) UIView        *scanLine;
// 无网络提示信息
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UILabel       *offlineTip;

@end

#pragma mark -

@implementation VKSCodeScanViewController

- (void)setHideBackItem:(BOOL)hideBackItem
{
    [_btnCancel setHidden:hideBackItem];
}//

- (void)setNeedMoreTip:(BOOL)needMoreTip
{
    return;
    _needMoreTip = needMoreTip;
    
    CGFloat fTipHeight = 16.0;
    if (_needMoreTip) {
        fTipHeight = 50.0;
    }
    
    CGRect frameCapture = [[UIScreen mainScreen] bounds];
    CGFloat captureWidth = frameCapture.size.width;
    CGFloat topInterval = kTopInterval;
    //扫描框下面的提示
    _lbDecoded.frame = CGRectMake(20,
                                  topInterval+_scanScopeView.bounds.size.height+kTipTopPadding,
                                  captureWidth - 40,
                                  fTipHeight);
    if (_needMoreTip) {
        NSString *tip = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"TipScanQRCode", nil),
                         NSLocalizedString(@"TipScanQRCodeMore", nil)];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tip];
        [attString addAttribute:NSForegroundColorAttributeName
                          value:VKDefaultGreen
                          range:NSMakeRange(NSLocalizedString(@"TipScanQRCode", nil).length,
                                            NSLocalizedString(@"TipScanQRCodeMore", nil).length+1)];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10.0;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attString addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, tip.length)];
        [_lbDecoded setNumberOfLines:0];
        [_lbDecoded setAttributedText:attString];
    }
    else {
        [_lbDecoded setText:NSLocalizedString(@"TipScanQRCode", nil)];
    }
}//

- (void)setIsSupportOffline:(BOOL)isSupportOffline
{
    _isSupportOffline = isSupportOffline;
    if (isSupportOffline) {
        [_effectView setHidden:YES];
        [_offlineTip setHidden:YES];
    }
}//

+ (instancetype)vksQRReader
{
    VKSCodeScanViewController *reader = [[VKSCodeScanViewController alloc] initWithCancelTitle:nil];
    return reader;
}//

+ (instancetype)vksMoreReader
{
    VKSCodeScanViewController *reader = [[VKSCodeScanViewController alloc] initWithMoreCancelTitle:nil];
    return reader;
}//

#pragma mark -

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}//

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
{
    self = [super initWithCancelTitle:cancelTitle];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveHandle:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}//

- (void)setupUIComponentsWithCancelTitle:(NSString *)cancelTitle
{
    [super setupUIComponentsWithCancelTitle:cancelTitle];
    [self loadBackgroundLayer];
    [self loadOperationView];
}//

- (void)loadBackgroundLayer
{
    CGRect frameCapture = SCREEN_BOUNDS;
    CGFloat topInterval = kTopInterval;
    UIImage *imgScanBK = [UIImage imageNamed:@"code_box"];
    _scanScopeView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftPadding,
                                                                   topInterval,
                                                                   frameCapture.size.width-kLeftPadding*2,
                                                                   imgScanBK.size.height)];
    [_scanScopeView setImage:imgScanBK];
    [self.view addSubview:_scanScopeView];

    CGFloat captureWidth = frameCapture.size.width;
    CGFloat captureHeight = frameCapture.size.height;
    // top shadow
    _topShadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              captureWidth,
                                                              topInterval)];
    [_topShadowView setBackgroundColor:SHADOW_COLOR];
    [self.view addSubview:_topShadowView];
    // left shadow
    _leftShadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               topInterval,
                                                               kLeftPadding,
                                                               _scanScopeView.bounds.size.height)];
    [_leftShadowView setBackgroundColor:SHADOW_COLOR];
    [self.view addSubview:_leftShadowView];
    // bottom shadow
    _bottomShadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 topInterval+_scanScopeView.bounds.size.height,
                                                                 captureWidth,
                                                                 captureHeight-_scanScopeView.bounds.size.height-topInterval)];
    [_bottomShadowView setBackgroundColor:SHADOW_COLOR];
    [self.view addSubview:_bottomShadowView];
    // right shadow
    _rightShadowView = [[UIView alloc] initWithFrame:CGRectMake(captureWidth - kLeftPadding,
                                                                topInterval,
                                                                kRightPadding,
                                                                _scanScopeView.bounds.size.height)];
    [_rightShadowView setBackgroundColor:SHADOW_COLOR];
    [self.view addSubview:_rightShadowView];
    
    CGFloat fTipHeight = 16.0;
    //扫描框下面的提示
    _lbDecoded = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                           topInterval+_scanScopeView.bounds.size.height+kTipTopPadding,
                                                           captureWidth - 40,
                                                           fTipHeight)];
    [_lbDecoded setBackgroundColor:[UIColor clearColor]];
    [_lbDecoded setTextAlignment:NSTextAlignmentCenter];
    [_lbDecoded setTextColor:[UIColor whiteColor]];
    [_lbDecoded setFont:[UIFont systemFontOfSize:15]];
    [_lbDecoded setText:NSLocalizedString(@"TipScanQRCode", nil)];

    [self.view addSubview:_lbDecoded];
    //扫描框里面的线
    _scanLine = [[UIView alloc] initWithFrame:CGRectZero];
    UIImage *imgScanLine = [UIImage imageNamed:@"code_line"];
    [_scanLine setFrame:CGRectMake(kLeftPadding,
                                   topInterval,
                                   _scanScopeView.bounds.size.width,
                                   imgScanLine.size.height)];
    UIImageView *imgViewScanLine = [[UIImageView alloc] initWithFrame:_scanLine.bounds];
    [imgViewScanLine setImage:imgScanLine];
    [_scanLine addSubview:imgViewScanLine];
    [_scanLine setBackgroundColor:[UIColor clearColor]];
    [_scanLine setHidden:YES];
    [self.view addSubview:_scanLine];
    
    // here the best place to set interst rect after loaded background layer
    // should has a valid scan scope view
    // comment by mark 17-01-11
    [self.codeReader setInterstRect:_scanScopeView.frame];
    
#warning YOUNG MARK
//    [_scanScopeView setBackgroundColor:[UIColor redColor]];
    
    // 无网状态下的blur view，add by mark 17-02-22
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [effectView setFrame:self.view.bounds];
//    [self.view insertSubview:effectView belowSubview:_scanScopeView];
    _effectView = effectView;
    // 用于无网络tip信息显示
    CGFloat tipHeight = 100.0;
    _offlineTip = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                            _scanScopeView.bounds.size.height-tipHeight,
                                                            _scanScopeView.bounds.size.width,
                                                            tipHeight)];
    [_offlineTip setBackgroundColor:[UIColor clearColor]];
    [_offlineTip setTextAlignment:NSTextAlignmentCenter];
    [_offlineTip setTextColor:[UIColor whiteColor]];
    [_offlineTip setFont:[UIFont boldSystemFontOfSize:20]];
    [_offlineTip setNumberOfLines:0];
    [_offlineTip setHidden:YES];
    [_offlineTip setText:@"当前网络不可用\n请检查网络设置"];
    [_scanScopeView addSubview:_offlineTip];
    
//    _manager = [AFNetworkReachabilityManager sharedManager];
//    [_effectView setHidden:_manager.isReachable];
//    [_offlineTip setHidden:_manager.isReachable];
    
//    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
//    [notiCenter addObserverForName:AFNetworkingReachabilityDidChangeNotification
//                            object:nil
//                             queue:[NSOperationQueue mainQueue]
//                        usingBlock:^(NSNotification * _Nonnull note) {
//                            if (_isSupportOffline) {
//                                return;
//                            }
//                            [self updateWithNetworkReachable:_manager.isReachable];
//                        }];
}//

- (void)updateWithNetworkReachable:(BOOL)isReachable
{
    [_effectView setHidden:isReachable];
    [_offlineTip setHidden:isReachable];
    if (isReachable) {
        [self.codeReader setInterstRect:_scanScopeView.frame];
        [self startScanLine];
    }
    else {
        [self.codeReader setInterstRect:CGRectZero];
        [self stopScanLine];
    }
}//

- (void)loadOperationView
{
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectZero];
    UIImage *imgBackNor = [UIImage imageNamed:@"code_back_normal"];
    [_btnCancel setImage:imgBackNor forState:UIControlStateNormal];
    [_btnCancel setShowsTouchWhenHighlighted:YES];
    [_btnCancel addTarget:self
                   action:@selector(btnCancelEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCancel];
    [self.view bringSubviewToFront:_btnCancel];
    [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kTopMargin);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    
    _btnLight = [[UIButton alloc] initWithFrame:CGRectZero];
    UIImage *imgLightNor = [UIImage imageNamed:@"code_flash_off"];
    [_btnLight setImage:imgLightNor forState:UIControlStateNormal];
    [_btnLight setShowsTouchWhenHighlighted:YES];
    [_btnLight addTarget:self
                  action:@selector(toggleTorch:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnLight];
    [_btnLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(52*3));
        make.top.equalTo(self.lbDecoded.mas_bottom);
    }];
}//


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (NO == self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}//

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 最快显示出摄像画面，在didAppear后再做扫描动画
    [self startScanning];
}//

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}//

- (void)startScanning
{
    [super startScanning];
    [self startScanLine];
}//

- (void)stopScanning
{
    [super stopScanning];
    [self stopScanLine];
}//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applicationDidBecomeActiveHandle:(NSNotification *)noti
{
    [self startScanLine];
    // 在程序墓碑后，手电将自动关闭，从后台激活的过程中将重置手电按钮为“关闭”状态
    [_btnLight setImage:[UIImage imageNamed:@"code_flash_off"] forState:UIControlStateNormal];
}//

- (void)startScanLine
{
    // 不支持离线 && 网络不可达
//    if (!_isSupportOffline && !_manager.isReachable) {
//        return;
//    }
    
    [_scanLine.layer removeAllAnimations];
    CGRect oriFrame = _scanLine.frame;
    oriFrame.origin.y = kTopInterval;
    [_scanLine setFrame:oriFrame];
    [_scanLine setHidden:NO];
    
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:999999];
    oriFrame = _scanLine.frame;
    oriFrame.origin.y = kTopInterval + _scanScopeView.bounds.size.height;
    [_scanLine setFrame:oriFrame];
    [UIView commitAnimations];
}//

- (void)stopScanLine
{
    [_scanLine setHidden:YES];
    CGRect oriFrame = _scanLine.frame;
    oriFrame.origin.y = kTopInterval;
    [_scanLine setFrame:oriFrame];
    [_scanLine.layer removeAllAnimations];
}//

@end
