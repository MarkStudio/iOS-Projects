//
//  HistoryManager.m
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import "HistoryManager.h"
#import "NSFileManager+MKSExtend.h"

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

#pragma mark -

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initHistories];
    }
    
    return self;
}//

- (void)initHistories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileManager historyDirectory];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    _arrHistories = arr;
}//

@end
