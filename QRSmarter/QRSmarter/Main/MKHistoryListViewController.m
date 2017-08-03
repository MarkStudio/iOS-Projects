//
//  MKHistoryListViewController.m
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import "MKHistoryListViewController.h"
#import "HistoryManager.h"
#import "UIViewController+MKExtend.h"

static CGFloat kCellHeight = 60;

@interface MKHistoryListViewController ()

@property (nonatomic, strong) HistoryManager *historyMgr;

@end

#pragma mark -

@implementation MKHistoryListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _historyMgr = [HistoryManager sharedInstance];
    }
    
    return self;
}//

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView hideExtraCellLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyMgr.arrHistories.count;
}//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifer];
    }
    NSDictionary *dicInfo = _historyMgr.arrHistories[indexPath.row];
    [cell.textLabel setText:dicInfo[@"result"]];
    
    return cell;
}//

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dicInfo = _historyMgr.arrHistories[indexPath.row];
    [self handleQRType:dicInfo[@"type"]
            withResult:dicInfo[@"result"]
        withCompletion:nil];
}//

@end
