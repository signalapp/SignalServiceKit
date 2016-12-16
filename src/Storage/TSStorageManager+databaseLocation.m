//
//  TSStorageManager+databaseLocation.m
//
//  Created by Thomass Guillet on 07/12/16.
//  Copyright (c) 2016 Open Whisper Systems. All rights reserved.
//

#import "TSStorageManager+databaseLocation.h"
//#import "TSPrefix.h"

static const NSString *const databaseName = @"Signal.sqlite";
#ifdef DEBUG
static NSString *const preferredEntitlementName = @"Debug";
#elif RELEASE
static NSString *const preferredEntitlementName = @"Release";
#endif

static NSString *const appGroupSuffix = @"signal_service";

@implementation TSStorageManager (databaseLocation)

+ (NSString *)standaloneDbPath:(NSFileManager *)fileManager {
    NSURL *fileURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *path = [fileURL path];

    return [path stringByAppendingFormat:@"/%@", databaseName];
}


+ (NSString *)getEntitlementFile {
    NSBundle *mainBundle = [NSBundle mainBundle];

    NSString *entitlementFile = [mainBundle pathForResource:preferredEntitlementName ofType:@"entitlements"];
    if (!entitlementFile) {
        NSURL *bundleURL = [mainBundle bundleURL];
        NSString *name = [[bundleURL lastPathComponent] stringByDeletingPathExtension];
        entitlementFile = [mainBundle pathForResource:name ofType:@"entitlements"];
    }
    return entitlementFile;
}

+ (NSString *)determineAppGroupName {
    NSString *pathToEntitlements = [TSStorageManager getEntitlementFile];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathToEntitlements];
    NSArray *groups = [dict objectForKey:@"com.apple.security.application-groups"];

    NSIndexSet *indexes = [groups indexesOfObjectsPassingTest:
                           ^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj hasSuffix:appGroupSuffix];
    }];
    if ([indexes count]) {
        return [groups objectAtIndex:[indexes firstIndex]];
    }
    return nil;
}

+ (NSString *)sharedDbPath:(NSFileManager *)fileManager {
    NSString *appGroupName = [TSStorageManager determineAppGroupName];
    NSURL *fileURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:appGroupName];
    if (fileURL) {
        NSString *path = [fileURL path];

        return [path stringByAppendingFormat:@"/%@", databaseName];
    }
    return nil;
}

+ (NSString *)determineiOSDbPath:(NSFileManager *)fileManager {
    NSString *path = [self sharedDbPath:fileManager];
    if (!path) {
        path = [self standaloneDbPath:fileManager];
    }
    return path;
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

+ (void) migrateStandaloneDb {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSString *standalonePath = [TSStorageManager standaloneDbPath:fileManager];
        if ([fileManager fileExistsAtPath:standalonePath]) {
            NSString *sharedPath = [TSStorageManager sharedDbPath:fileManager];

            if (!sharedPath) {
                NSError *error;
                [fileManager moveItemAtPath:standalonePath toPath:sharedPath error:&error];
                if(error) {
                    DDLogError(@"Could not move signal database: %@", error.localizedDescription);
                }
            } else {
                DDLogWarn(@"Signal database should not be migrated: No shared location");
            }
        }
    });
}
@end
