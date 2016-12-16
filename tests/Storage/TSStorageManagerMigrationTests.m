//
//  TSStorageManagerMigrationTests.m
//
//  Created by Thomas Guillet on 07/12/2016.
//  Copyright (c) 2014 Open Whisper Systems. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Cryptography.h"
#import "TSThread.h"
#import "TSContactThread.h"
#import "TSGroupThread.h"

#import "TSStorageManager.h"

#import "TSIncomingMessage.h"
#import "TSMessage.h"
#import "TSOutgoingMessage.h"
#import "TSStorageManager+databaseLocation.h"


@interface TSStorageManagerMigrationTests : XCTestCase

@property TSContactThread *thread;

@end

@implementation TSStorageManagerMigrationTests

- (void)testStuff
{
    NSString *collection = @"collection";
    NSString *key = @"key";
    NSString *value = @"value";
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *standalonePath = [TSStorageManager standaloneDbPath:fileManager];
    YapDatabase *database = [[YapDatabase alloc] initWithPath:standalonePath];
    YapDatabaseConnection *connection = database.newConnection;

    [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:value forKey:key inCollection:collection];
    }];

    [TSStorageManager migrateStandaloneDb];
    NSString *sharedPath = [TSStorageManager sharedDbPath:fileManager];
    NSString *dbPath = [[TSStorageManager sharedManager].database databasePath];
    XCTAssert([dbPath isEqualToString:sharedPath]);
    [[TSStorageManager sharedManager].newDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSString *returnedValue = [transaction objectForKey:key inCollection:collection];
        XCTAssert([returnedValue isEqualToString:value]);
    }];
}

@end
