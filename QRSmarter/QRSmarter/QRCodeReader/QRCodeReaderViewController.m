//
//  QRCodeReaderViewController.m
//  VKServiceAssistant
//
//  Created by wolfire on 9/7/15.
//  Copyright (c) 2015 vanke. All rights reserved.
//

#import "QRCodeReaderViewController.h"
#import "QRCodeReaderView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Masonry.h>
#import "NSFileManager+MKSExtend.h"

@interface QRCodeReaderViewController ()

@property (nonatomic) QRCodeReaderView *cameraView;
@property (nonatomic) QRCodeReader *codeReader;
@property (assign, nonatomic) BOOL startScanningAtLoad;
@property (copy, nonatomic) void (^completionBlock) (NSString *scanResult);

// 附属码类型信息，add by mark 17-06-13
@property (copy, nonatomic) void (^completionBlockWithParams) (NSDictionary *dicParams);

@end

@implementation QRCodeReaderViewController

- (id)init {
    return [self initWithCancelTitle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopScanning];
//    [self.torch lockForConfiguration:nil];
//    [self.torch setTorchMode:AVCaptureTorchModeOff];
//    [self.torch unlockForConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self stopScanning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    _codeReader.previewLayer.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Creating and Inializing QRCodeReader Controllers

- (id)initWithCancelTitle:(NSString *)cancelTitle
{
    return [self initWithCancelTitle:cancelTitle metadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
}

- (id)initWithMoreCancelTitle:(NSString *)cancelTitle
{
    return [self initWithCancelTitle:cancelTitle metadataObjectTypes:@[AVMetadataObjectTypeQRCode,
                                                                       AVMetadataObjectTypeEAN13Code,             // 条形码
                                                                       AVMetadataObjectTypeEAN8Code,
                                                                       AVMetadataObjectTypeCode39Code,
                                                                       AVMetadataObjectTypeCode128Code]];
}//

+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle {
    return [[self alloc] initWithCancelTitle:cancelTitle];
}

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes {
    return [self initWithCancelTitle:nil metadataObjectTypes:metadataObjectTypes];
}

+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes {
    return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}

- (id)initWithCancelTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes {
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:metadataObjectTypes];
    return [self initWithCancelTitle:cancelTitle codeReader:reader];
}

+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes {
    return [[self alloc] initWithCancelTitle:cancelTitle metadataObjectTypes:metadataObjectTypes];
}

- (id)initWithCancelTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader {
    return [self initWithCancelTitle:cancelTitle codeReader:codeReader startScanningAtLoad:YES];
}

+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader {
    return [[self alloc] initWithCancelTitle:cancelTitle codeReader:codeReader];
}

- (id)initWithCancelTitle:(NSString *)cancelTitle
               codeReader:(QRCodeReader *)codeReader
      startScanningAtLoad:(BOOL)startScanningAtLoad
{
    self = [super init];
    if (self) {
        self.codeReader = codeReader;   // must be first line, otherwise it is invalid.
        self.view.backgroundColor = [UIColor blackColor];
        self.startScanningAtLoad = startScanningAtLoad;
        
        if (cancelTitle == nil) {
            cancelTitle = NSLocalizedString(@"Cancel", @"Cancel");
        }
        [self setupUIComponentsWithCancelTitle:cancelTitle];
        [self setupAutoLayoutConstraints];
        [self setCodeReaderBlock:codeReader];
        
        [_cameraView.layer insertSublayer:_codeReader.previewLayer atIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }

    return self;
}

- (void)setCodeReaderBlock:(QRCodeReader *)codeReader
{
    [codeReader setAccessDeniedBlock:^{
        [self didCancelQRCodeReader:nil];
    }];
    
    [codeReader setCompletionWithBlock:^(NSString *resultAsString) {
        [self stopScanning];
        
        if (_completionBlock) {
            _completionBlock(resultAsString);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)]) {
            [self playSuccessSound];
            [_delegate reader:self didScanResult:resultAsString];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
            [_delegate readerDidCancel:self];
        }
        
    }];

    // add by mark 17-06-13
    [codeReader setCompletionBlockWithParams:^(NSDictionary *dicParams) {
        [self stopScanning];
        
        if (_completionBlockWithParams) {
            _completionBlockWithParams(dicParams);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanParams:)]) {
            [self playSuccessSound];
            
            [_delegate reader:self didScanParams:dicParams];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
            [_delegate readerDidCancel:self];
        }
        
    }];
}

- (void)playSuccessSound {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle
                           codeReader:(QRCodeReader *)codeReader
                  startScanningAtLoad:(BOOL)startScanningAtLoad {
    return [[self alloc] initWithCancelTitle:cancelTitle
                                  codeReader:codeReader
                         startScanningAtLoad:startScanningAtLoad];
}

#pragma mark - Controlling the Reader

- (void)startScanning {
    [_codeReader startScanning];
}

- (void)stopScanning {
    [_codeReader stopScanning];
}

#pragma mark - Managing the Orientation

- (void)orientationChanged:(NSNotification *)notification
{
    [_cameraView setNeedsDisplay];
    
    if (_codeReader.previewLayer.connection.isVideoOrientationSupported) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:orientation];
    }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock {
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelTitle:(NSString *)cancelTitle
{
    self.cameraView = [[QRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds = YES;
    [self.view addSubview:_cameraView];
    
    [_codeReader.previewLayer setFrame:CGRectMake(0,
                                                  0,
                                                  CGRectGetWidth(self.view.bounds),
                                                  CGRectGetHeight(self.view.bounds))];
    
    if ([_codeReader.previewLayer.connection isVideoOrientationSupported]) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:orientation];
    }
}

- (void)setupAutoLayoutConstraints
{
    [_cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view); //.offset(-48); // 不作偏移，滿屏显示摄像画面
    }];
}

#pragma mark - Catching Button Events

- (void)didCancelQRCodeReader:(UIButton *)button {
    [_codeReader stopScanning];

    if (_completionBlock) {
        _completionBlock(nil);
    }

    if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
        [_delegate readerDidCancel:self];
    }
}

#pragma mark - Addtional button

- (void)showAddtionButton:(BOOL)show withTitle:(NSString *)title
{
    return;
}

- (void)btnCancelEvent:(id)sender
{
    [_codeReader stopScanning];
    
    if (self.navigationController && self.navigationController.viewControllers.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}//

- (void)toggleTorch:(id)sender
{
    [_codeReader toggleTorch:sender];
}//

- (void)didClickAddtionalButton:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(addtionButtonDidClick)]) {
        [_delegate addtionButtonDidClick];
    }
}

@end
