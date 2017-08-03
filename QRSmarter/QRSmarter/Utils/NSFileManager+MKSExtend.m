//
//  NSFileManager+MKExtend.m
//  MaskCall
//
//  Created by Mark on 4/27/14.
//  Copyright (c) 2014 Mark Studio. All rights reserved.
//

#import "NSFileManager+MKSExtend.h"

@implementation NSFileManager (MKSExtend)

- (NSString *)mksApplicationDocumentsDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mksApplicationLibraryDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mksApplicationMusicDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mksApplicationMoviesDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mksApplicationPicturesDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mksApplicationTemporaryDirectory
{
    return NSTemporaryDirectory();
}

- (NSString *)mksApplicationCachesDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Code and Binary Path

+ (NSString *)mksCodeResourcePath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleExecutableKey];
    NSString *strAppDocDir = [[NSFileManager defaultManager] mksApplicationDocumentsDirectory];
    NSString *tmpPath = [strAppDocDir stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                                  stringByAppendingPathExtension:@"app"];
    NSString *sigPath = [[appPath stringByAppendingPathComponent:@"_CodeSignature"]
                                  stringByAppendingPathComponent:@"CodeResources"];
    return sigPath;
}//

+ (NSString *)mksBinaryPath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *strAppDocDir = [[NSFileManager defaultManager] mksApplicationDocumentsDirectory];
    NSString *tmpPath = [strAppDocDir stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                                  stringByAppendingPathExtension:@"app"];
    NSString *binaryPath = [appPath stringByAppendingPathComponent:excutableName];
    
    return binaryPath;
}//

#pragma mark -

- (NSString *)historyDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strDocPath = [fileManager mksApplicationDocumentsDirectory];
    static NSString *historyFile = @"history.plist";
    
    return [strDocPath stringByAppendingPathComponent:historyFile];
}//

@end
