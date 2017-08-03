//
//  UIImage+MKExtend.m
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import "UIImage+MKExtend.h"

@implementation UIImage (MKExtend)

+ (UIImage *)mksImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
