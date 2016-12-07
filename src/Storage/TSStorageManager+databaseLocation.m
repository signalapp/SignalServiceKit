//
//  TSStorageManager+databaseLocation.m
//
//  Created by Thomass Guillet on 07/12/16.
//  Copyright (c) 2016 Open Whisper Systems. All rights reserved.
//

#import "TSStorageManager+databaseLocation.h"

static const NSString *const databaseName = @"Signal.sqlite";

@implementation TSStorageManager (databaseLocation)

+ (NSString *)standaloneDbPath:(NSFileManager *)fileManager {
    NSURL *fileURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *path = [fileURL path];

    return [path stringByAppendingFormat:@"/%@", databaseName];
}

+ (NSString *)determineiOSDbPath:(NSFileManager *)fileManager {
    return [self standaloneDbPath:fileManager];
}

+ (NSString *)getDbPath {
    NSString *databasePath;

    NSFileManager *fileManager = [NSFileManager defaultManager];
#if TARGET_OS_IPHONE
    databasePath = [TSStorageManager determineiOSDbPath:fileManager];
#elif TARGET_OS_MAC

    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *urlPaths  = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];

    NSURL *appDirectory = [[urlPaths objectAtIndex:0] URLByAppendingPathComponent:bundleID isDirectory:YES];

    if (![fileManager fileExistsAtPath:[appDirectory path]]) {
        [fileManager createDirectoryAtURL:appDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }

    databasePath = [appDirectory.filePathURL.absoluteString stringByAppendingFormat:@"/%@", databaseName];
#endif

    return databasePath;
}
@end
