//
//  HistoryManager.h
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrHistories;

#pragma mark -

+ (instancetype)sharedInstance;

@end
