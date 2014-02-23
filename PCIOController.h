//
//  PCIOController.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/30/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCIOController : NSObject


-(NSArray *) obtainAlbums;
-(void) saveImageToDocuments: (UIImage *)image albumName:(NSString *)albumName imageName:(NSString *)imageName;
-(void) createDirectoryIfNotExist: (NSString *)directoryName;
-(BOOL) directoryExistsAtAbsolutePath:(NSString*)directoryName;
-(BOOL) fileExistsAtAbsolutePath:(NSString*)filename;
-(NSString *) documentDirectory;
-(NSArray *)obtainFilesInDirectory: (NSString *)directory;
-(UIImage *)obtainThumbnail: (NSString *)albumName imageName:(NSString *)imageName;
-(void) deleteDirectory: (NSString *)directoryName;
-(void) displayAllFilesAndDirectories;

@end
