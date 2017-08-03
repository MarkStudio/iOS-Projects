//
//  UIViewController+MKExtend.m
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import "UIViewController+MKExtend.h"

@implementation UIViewController (MKExtend)

#pragma mark -

- (void)handleQRType:(NSString *)type
          withResult:(NSString *)result
      withCompletion:(void(^)(void))completion
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:type
                                                                     message:result
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alertVC addAction:actionCancel];
    
    UIAlertAction *actionSafari = [UIAlertAction actionWithTitle:@"Safari打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:result];
        UIApplication *app = [UIApplication sharedApplication];
        if (url && [app canOpenURL:url]) {
            [app openURL:url];
        }
        if (completion) {
            completion();
        }
    }];
    [alertVC addAction:actionSafari];
    
    UIAlertAction *actionCopy = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:result];
        if (completion) {
            completion();
        }
    }];
    [alertVC addAction:actionCopy];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
}//

@end
