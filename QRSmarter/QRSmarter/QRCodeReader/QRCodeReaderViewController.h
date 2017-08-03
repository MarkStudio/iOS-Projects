//
//  QRCodeReaderViewController.h
//  VKServiceAssistant
//
//  Created by wolfire on 9/7/15.
//  Copyright (c) 2015 vanke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QRCodeReader.h"

@class QRCodeReaderViewController;

@protocol QRCodeReaderDelegate <NSObject>

@required

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result;
- (void)readerDidCancel:(QRCodeReaderViewController *)reader;

@optional
- (void)reader:(QRCodeReaderViewController *)reader didScanParams:(NSDictionary *)dicParams;

@optional

- (void)addtionButtonDidClick;

@end

@interface QRCodeReaderViewController : UIViewController

@property (nonatomic, weak) id<QRCodeReaderDelegate> delegate;
@property (nonatomic, readonly) QRCodeReader *codeReader;
@property (assign, nonatomic) NSInteger tag;

#pragma mark - Creating and Inializing QRCodeReader Controllers

- (id)initWithCancelTitle:(NSString *)cancelTitle;
- (id)initWithMoreCancelTitle:(NSString *)cancelTitle;
+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle;
- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes;
+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes;
- (id)initWithCancelTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes;
+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes;
- (id)initWithCancelTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader;
+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader;
- (id)initWithCancelTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad;
+ (instancetype)readerWithCancelTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad;

#pragma mark - 

- (void)setupUIComponentsWithCancelTitle:(NSString *)cancelTitle;

#pragma mark - Controlling the Reader

- (void)startScanning;
- (void)stopScanning;

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock;

#pragma mark - Addtional button

- (void)showAddtionButton:(BOOL)show withTitle:(NSString *)title;

- (void)btnCancelEvent:(id)sender;
- (void)toggleTorch:(id)sender;

#pragma mark -

@end
