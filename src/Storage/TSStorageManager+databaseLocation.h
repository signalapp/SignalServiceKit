//
//  TSStorageManager+databaseLocation.h
//
//  Created by Thomass Guillet on 07/12/16.
//  Copyright (c) 2016 Open Whisper Systems. All rights reserved.
//

#import "TSStorageManager.h"

@interface TSStorageManager (databaseLocation)

/**
 *  Full path of the signal database when used alone
 *
 *  @return database path
 */

+ (NSString *)standaloneDbPath:(NSFileManager *)fileManager;

/**
 *  Rely on the project configuration to return the appropriate database path
 *
 *  @return database path
 */

+ (NSString *)determineiOSDbPath:(NSFileManager *)fileManager;

+ (NSString *)getDbPath;

@end
