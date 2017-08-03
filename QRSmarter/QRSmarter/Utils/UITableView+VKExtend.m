//
//  UITableView+VKExtend.m
//  VKStaffAssistant
//
//  Created by Mark Yang on 18/05/2017.
//  Copyright © 2017 Vanke. All rights reserved.
//

#import "UITableView+VKExtend.h"

@implementation UITableView (VKExtend)

- (void)hideExtraCellLine
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [self setTableFooterView:view];
    
    return;
}//

@end
