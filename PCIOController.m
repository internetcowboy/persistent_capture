//
//  PCIOController.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/30/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCIOController.h"

@implementation PCIOController




#pragma mark Visibility stuff

-(NSArray *)obtainAlbums {
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentDirectory] error:nil];
    return paths;
}

-(NSArray *)obtainFilesInDirectory: (NSString *)directory {
    
    NSError *error = nil;
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtPath:directory error:&error];
    
    return array;
    
}

#pragma mark Saving Items

-(void) saveImageToDocuments: (UIImage *)image albumName:(NSString *)albumName imageName:(NSString *)imageName{
    
    //make sure album directory exists
    [self createDirectoryIfNotExist:albumName];
    
    //obtain some paths
    NSString *documentsDirectory = [self documentDirectory];
    NSString *imageSubdirectory = [documentsDirectory stringByAppendingPathComponent:albumName];
    NSString *filePath = [imageSubdirectory stringByAppendingPathComponent:imageName];
    
    // Convert UIImage object into NSData and save to our directory
    NSData *imageData = UIImageJPEGRepresentation(image, 0.85f); // quality level 85%
    [imageData writeToFile:filePath atomically:YES];
    
}

-(UIImage *)obtainThumbnail: (NSString *)albumName imageName:(NSString *)imageName {
    
    //obtain some paths
    NSString *documentsDirectory = [self documentDirectory];
    NSString *imageSubdirectory = [documentsDirectory stringByAppendingPathComponent:albumName];
    NSString *filePath = [imageSubdirectory stringByAppendingPathComponent:imageName];
    
    //get after the image and return it
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    UIImage *image;
    if (isFileExist) {
        image = [[UIImage alloc] initWithContentsOfFile:filePath];
    } else {
        NSLog(@"Image cannot be found by the name of :: %@", imageName);
    }
    
    return image;
}

#pragma mark Delete Stuff

-(void) deleteDirectory: (NSString *)directoryName {
    
    NSString * documentsDir = [self documentDirectory];
    directoryName = [NSString stringWithFormat:@"%@/%@", documentsDir, directoryName];
    
    BOOL directoryExists = [self directoryExistsAtAbsolutePath:(NSString*)directoryName];
    if (directoryExists) {
        NSError *error;
        if (! [[NSFileManager defaultManager] removeItemAtPath:directoryName error:&error] ) {
            NSLog(@"Create directory error: %@", error);
        }
        NSLog(@"DELETED");
    }
}

#pragma mark Helpers

- (NSString *) documentDirectory {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return documentsDirectory;
}

-(void) createDirectoryIfNotExist: (NSString *)directoryName {

    NSString * documentsDir = [self documentDirectory];
    directoryName = [NSString stringWithFormat:@"%@/%@", documentsDir, directoryName];
    
    BOOL directoryExists = [self directoryExistsAtAbsolutePath:(NSString*)directoryName];
    if (!directoryExists) {
        //we better create it then chief
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:directoryName withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

-(void) displayAllFilesAndDirectories {
    
    NSArray *paths =   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    =   [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSLog(@"%@",filePathsArray);

}

-(BOOL) directoryExistsAtAbsolutePath:(NSString*)directoryName {
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:directoryName isDirectory:&isDirectory];
    
    return fileExistsAtPath && isDirectory;
}

-(BOOL) fileExistsAtAbsolutePath:(NSString*)filename {
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory];
    
    return fileExistsAtPath && !isDirectory;
}

@end
