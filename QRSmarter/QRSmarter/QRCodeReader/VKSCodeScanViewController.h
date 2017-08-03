//
//  VKSCodeScanViewController.h
//  VKStaffAssistant
//
//  Created by Mark Yang on 11/01/2017.
//  Copyright © 2017 Vanke. All rights reserved.
//

#import "QRCodeReaderViewController.h"

@interface VKSCodeScanViewController : QRCodeReaderViewController

// 是否支持离线扫描二维码(FM需要支持offline模式，帮在此区分), add by mark 17-02-22
@property (nonatomic, assign) BOOL isSupportOffline;
// 是否需要更多提示，show "优惠码 & 访客验证", add by mark 17-06-05
@property (nonatomic, assign) BOOL needMoreTip;
// 隐藏back item, add by mark 17-08-02

#pragma mark - 

- (void)setHideBackItem:(BOOL)hideBackItem;

#pragma mark -

/**
 *	@brief  定制UI的QR Reader
 *
 *	@return	QRCodeReaderViewController Object
 *
 *	Created by Mark on 2017-01-11 09:50
 */
+ (instancetype)vksQRReader;

// 扫描：条码 & 二维码
+ (instancetype)vksMoreReader;

@end
