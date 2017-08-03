//
//  QRCodeReader.h
//  VKStaffAssistant
//
//  Created by wolfire on 9/6/15.
//  Copyright (c) 2015 Vanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRCodeReader : NSObject

@property (copy, nonatomic, readonly) NSArray *metadataObjectTypes;
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *previewLayer;
@property (readonly) AVCaptureDeviceInput *readerDeviceInput;
@property (readonly) AVCaptureMetadataOutput *metadataOutput;

// 扫描完成回调，除扫描结果字串处，需附加更多参数信息(如：码类型)时使用
// add by mark 17-06-13
@property (copy, nonatomic) void (^completionBlockWithParams) (NSDictionary *dicParams);

#pragma mark - Creating and Inializing QRCode Readers

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes;
+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes;

#pragma mark - Checking the Reader Availabilities

+ (BOOL)isAvailable;
+ (BOOL)supportsMetadataObjectTypes:(NSArray *)metadataObjectTypes;

#pragma mark - Controlling the Reader

- (void)startScanning;
- (void)stopScanning;
- (BOOL)running;

#pragma mark - Managing the Orientation

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock;
- (void)setAccessDeniedBlock:(void (^) ())accessDeniedBlock;

/**
 *	@brief	设置扫描区域(基于Screen Size)
 *
 *	@param 	interestRect 	扫描区域的屏幕坐标
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-20 14:22
 */
- (void)setInterstRect:(CGRect)interestRect;
- (void)toggleTorch:(id)sender;

@end
