//
//  HistoryManager.m
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import "HistoryManager.h"

@implementation HistoryManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
