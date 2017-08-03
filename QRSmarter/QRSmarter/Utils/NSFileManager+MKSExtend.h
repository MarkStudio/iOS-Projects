//
//  NSFileManager+MKSExtend.h
//  MaskCall
//
//  Created by Mark on 4/27/14.
//  Copyright (c) 2014 Mark Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (MKSExtend)

/**
 *	@brief	App Document Diectory
 *
 *	@return Application document directory string
 */
- (NSString *)mksApplicationDocumentsDirectory;

/**
 *	@brief	Application library directory
 *
 *	@return	Application library directory string
 */
- (NSString *)mksApplicationLibraryDirectory;

/**
 *	@brief  Application music directory
 *
 *	@return	Application music directory string
 */
- (NSString *)mksApplicationMusicDirectory;

/**
 *	@brief	Application movies directory
 *
 *	@return	Application movies directory string
 */
- (NSString *)mksApplicationMoviesDirectory;

/**
 *	@brief	Application picture directory
 *
 *	@return	Application pictures directory string
 */
- (NSString *)mksApplicationPicturesDirectory;

/**
 *	@brief	Application temporary directory
 *
 *	@return	Application temporary directory string
 */
- (NSString *)mksApplicationTemporaryDirectory;

/**
 *	@brief	Application cache directory
 *
 *	@return	Application cache directory string
 */
- (NSString *)mksApplicationCachesDirectory;

#pragma mark -
#pragma mark Code and Binary Path

/**
 *	@brief	代码资源路径
 *
 *	@return 代码资源路径
 *
 *	Created by Mark on 2015-11-27 14:26
 */
+ (NSString *)mksCodeResourcePath;

/**
 *	@brief	二制进文件路径
 *
 *	@return	二制进文件路径
 *
 *	Created by Mark on 2015-11-27 14:26
 */
+ (NSString *)mksBinaryPath;

#pragma mark -

- (NSString *)historyDirectory;

@end
