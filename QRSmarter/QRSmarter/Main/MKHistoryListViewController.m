//
//  MKHistoryListViewController.m
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import "MKHistoryListViewController.h"
#import "NSFileManager+MKSExtend.h"
#import "UIViewController+MKExtend.h"

static CGFloat kCellHeight = 60;

@interface MKHistoryListViewController ()

@property (nonatomic, strong) NSMutableArray *arrHistories;

@end

#pragma mark -

@implementation MKHistoryListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    
    return self;
}//

- (void)initHistories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileManager historyDirectory];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    _arrHistories = arr;
    [self.tableView reloadData];
}//

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView hideExtraCellLine];
    
    [self initHistories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrHistories.count;
}//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifer];
    }
    NSDictionary *dicInfo = _arrHistories[indexPath.row];
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
    NSDictionary *dicInfo = _arrHistories[indexPath.row];
    [self handleQRType:dicInfo[@"type"] withResult:dicInfo[@"result"]];
}//

@end
