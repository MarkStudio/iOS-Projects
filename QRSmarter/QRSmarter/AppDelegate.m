//
//  AppDelegate.m
//  QRSmarter
//
//  Created by VS-Mark on 2/8/2017.
//  Copyright © 2017 MarkStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "MKRootViewController.h"
#import "VKSCodeScanViewController.h"
#import "MKHistoryListViewController.h"
#import "NSFileManager+MKSExtend.h"
#import "UIViewController+MKExtend.h"

@interface AppDelegate () <QRCodeReaderDelegate>

@property (nonatomic, strong) MKRootViewController *rootVC;
@property (nonatomic, strong) QRCodeReaderViewController *qrReaderVC;

@end

#pragma mark -

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customAppearance];
    [self loadRootVC];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -/Users/mark/Desktop/QRSmarter/QRSmarter/AppDelegate.m

- (void)customAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage mksImageWithColor:VKDefaultNavBK size:CGSizeMake(SCREEN_WIDTH, 64)]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage mksImageWithColor:VKDefaultNavBK size:CGSizeMake(SCREEN_WIDTH, 49)]];
//    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:VKColorFromRGB(95, 95, 95)}
                                             forState:UIControlStateNormal];
}//

- (void)loadRootVC
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIWindow *win = [[UIWindow alloc] initWithFrame:bounds];
    [self setWindow:win];
    [self.window makeKeyAndVisible];
    
    VKSCodeScanViewController *codeReaderVC = [VKSCodeScanViewController vksQRReader];
    [codeReaderVC setHideBackItem:YES];
    [codeReaderVC setTitle:@"QR扫描"];
    [codeReaderVC setNeedMoreTip:YES];
    [codeReaderVC setDelegate:self];
    UIImage *iconReaderSel = [[UIImage imageNamed:@"tab_qrcode_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [codeReaderVC.tabBarItem setSelectedImage:iconReaderSel];
    UIImage *iconReader = [[UIImage imageNamed:@"tab_qrcode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [codeReaderVC.tabBarItem setImage:iconReader];
    UINavigationController *codeReaderNav = [[UINavigationController alloc] initWithRootViewController:codeReaderVC];
    
    MKHistoryListViewController *historyListVC = [[MKHistoryListViewController alloc] initWithStyle:UITableViewStylePlain];
    [historyListVC setTitle:@"扫描历史"];
    UIImage *iconHistorySel = [[UIImage imageNamed:@"tab_history_icon_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [historyListVC.tabBarItem setSelectedImage:iconHistorySel];
    UIImage *iconHistory = [[UIImage imageNamed:@"tab_history_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [historyListVC.tabBarItem setImage:iconHistory];
    UINavigationController *historyNav = [[UINavigationController alloc] initWithRootViewController:historyListVC];
    
    MKRootViewController *rootVC = [[MKRootViewController alloc] init];
    [rootVC setViewControllers:@[codeReaderNav, historyNav]];
    [self.window setRootViewController:rootVC];
    _rootVC = rootVC;
}//

#pragma mark - QRCodeReaderDelegate

- (void)reader:(QRCodeReaderViewController *)reader didScanParams:(NSDictionary *)dicParams
{
    NSString *type = dicParams[@"type"];
    NSString *result = dicParams[@"result"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileManager historyDirectory];
    NSMutableArray *arrHistories = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (nil == arrHistories) {
        arrHistories = [NSMutableArray array];
    }
    [arrHistories addObject:dicParams];
    [arrHistories writeToFile:filePath atomically:YES];
    
    [reader handleQRType:type withResult:result];
    
    [reader startScanning];
}//

@end
