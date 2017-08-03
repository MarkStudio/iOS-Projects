//
//  QRCodeReader.m
//  VKStaffAssistant
//
//  Created by wolfire on 9/6/15.
//  Copyright (c) 2015 Vanke. All rights reserved.
//

#import "QRCodeReader.h"

@interface QRCodeReader () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) AVCaptureDevice *readerDevice;
@property (nonatomic) AVCaptureDeviceInput *readerDeviceInput;
@property (nonatomic) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (copy, nonatomic) void (^completionBlock) (NSString *result);
@property (copy, nonatomic) void (^accessDeniedBlock) ();

@end

#pragma mark -

@implementation QRCodeReader

#pragma mark - Creating and Inializing QRCode Readers

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    if ((self = [super init])) {
        _accessDeniedBlock = ^() {};
        _metadataObjectTypes = metadataObjectTypes;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized) {
                [self setupAVComponents];
                [self configureDefaultComponents];
//            }
            // 此认证可能引起问题，取消该方式认证
            // comment by mark 17-06-06
            /*
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"AccessDenied", nil) //@"访问受限"
                                                                               message:[NSString stringWithFormat:@"请允许%@访问你的相机", [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *anAction = nil;
                anAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GotIt", nil)
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                    if (self.accessDeniedBlock) {
                        self.accessDeniedBlock();
                    }
                                                      [AppUtility openApplicationSetting];
                }];
                [alert addAction:anAction];
                [[self topViewControllerOfWindow] presentViewController:alert animated:YES completion:nil];
            }
             */
            // end comment
        } else {
#if TARGET_IPHONE_SIMULATOR
#else
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"FunctionLimited", nil) //@"功能受限"
                                                                           message:@"当前设备不支持此功能"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *anAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GotIt", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.accessDeniedBlock) {
                    self.accessDeniedBlock();
                }
            }];
            [alert addAction:anAction];
#endif
        }
    }
    return self;
}

+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes {
    return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}

#pragma mark - Initializing the AV Components

- (void)setupAVComponents {
    self.readerDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if (_readerDevice) {
        self.readerDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_readerDevice error:nil];
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        self.session = [[AVCaptureSession alloc] init];
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
}

- (void)configureDefaultComponents {
    if ([_session canAddInput:_readerDeviceInput]) {
        [_session addInput:_readerDeviceInput];
    }
    if ([_session canAddOutput:_metadataOutput]) {
        [_session addOutput:_metadataOutput];
    }

    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_metadataOutput setMetadataObjectTypes:_metadataObjectTypes];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

#pragma mark - Checking the Reader Availabilities

+ (BOOL)isAvailable {
    @autoreleasepool {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        return YES;
    }
}

+ (BOOL)supportsMetadataObjectTypes:(NSArray *)metadataObjectTypes {
    if (![self isAvailable]) {
        return NO;
    }
    
    @autoreleasepool {
        // Setup components
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        
        [session addInput:deviceInput];
        [session addOutput:output];
        
        if (metadataObjectTypes == nil || metadataObjectTypes.count == 0) {
            // Check the QRCode metadata object type by default
            metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                    AVMetadataObjectTypeEAN13Code,             // 条形码
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode39Code,
                                    AVMetadataObjectTypeCode128Code];
        }
        
        for (NSString *metadataObjectType in metadataObjectTypes) {
            if (![output.availableMetadataObjectTypes containsObject:metadataObjectType]) {
                return NO;
            }
        }
        
        return YES;
    }
}

#pragma mark - Controlling the Reader

- (void)startScanning {
    if (![_session isRunning]) {
        [_session startRunning];
    }
}

- (void)stopScanning {
    if ([_session isRunning]) {
        [_session stopRunning];
    }
}

- (BOOL)running {
    return _session.isRunning;
}

#pragma mark - Managing the Orientation

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark - 

- (void)setInterstRect:(CGRect)interestRect
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    // 扫描区设置，按比例，右上角为原点，X,Y,W,H对调
    CGRect rect = CGRectMake (CGRectGetMinY(interestRect)/(screenHeight-49-20),
                                      ((screenWidth-CGRectGetWidth(interestRect))/2)/screenWidth ,
                                      CGRectGetHeight(interestRect)/(screenHeight-49-20),
                                      CGRectGetWidth(interestRect)/screenWidth);
    [_metadataOutput setRectOfInterest:rect];
}//

- (void)toggleTorch:(id)sender
{
    if ([self.readerDevice hasTorch]) {
        NSError *error = nil;
        [_readerDevice lockForConfiguration:&error];
        if (nil == error) {
            AVCaptureTorchMode mode = _readerDevice.torchMode;
            _readerDevice.torchMode = (mode == AVCaptureTorchModeOn ? AVCaptureTorchModeOff : AVCaptureTorchModeOn);
            if ([sender isKindOfClass:[UIButton class]]) {
                UIImage *image = [UIImage imageNamed:_readerDevice.torchMode == AVCaptureTorchModeOn ? @"code_flash_on" : @"code_flash_off"];
                [(UIButton *)sender setImage:image forState:UIControlStateNormal];
            }
        }
        [_readerDevice unlockForConfiguration];
    }
    else {
//        [AppUtility showAlertWithTitle:@"设备不支持"
//                               message:@"该设备没有闪光灯，无法支持此功能"
//                           buttonTitle:NSLocalizedString(@"OK", nil)];
    }
}//

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock {
    _completionBlock = completionBlock;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
                                                                 fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]] &&
            [_metadataObjectTypes containsObject:current.type]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            
            // 有些非标准的二维码可以识别，但无法获取值；
            // 在无值的情况下应该直接在此返回，不作下一步传入
            // add by mark 17-06-26
            if (scannedResult.length < 1) {
//                [AppUtility showAlertWithTitle:@""
//                                       message:@"无法识别此二维码"
//                                   buttonTitle:@"确定"];
                return;
            }
            // end add
            
            if (_completionBlock) {
                _completionBlock(scannedResult);
            }
            
            // 连带码类型信息一起返回
            // add by mark 17-06-13
            if (_completionBlockWithParams) {
                _completionBlockWithParams(@{@"result":scannedResult,
                                             @"type":current.type});
            }
            
            break;
        }
    }
}

@end
