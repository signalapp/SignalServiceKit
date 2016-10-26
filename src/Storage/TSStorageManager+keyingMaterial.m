//
//  TSStorageManager+keyingMaterial.m
//  TextSecureKit
//
//  Created by Frederic Jacobs on 06/11/14.
//  Copyright (c) 2014 Open Whisper Systems. All rights reserved.
//

#import "TSStorageManager+keyingMaterial.h"

@implementation TSStorageManager (keyingMaterial)

+ (NSString *)localNumber
{
    return [[self sharedManager] localNumber];
}

- (NSString *)localNumber
{
    return [self stringForKey:TSStorageRegisteredNumberKey inCollection:TSStorageUserAccountCollection];
}

- (void)runAsyncIfHasLocalNumber:(void (^)())block
{
    [self.newDatabaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction *_Nonnull transaction) {
        if ([transaction objectForKey:TSStorageRegisteredNumberKey inCollection:TSStorageUserAccountCollection]) {
            block();
        } else {
            DDLogDebug(@"%@ Skipping existing user block since no local number is registered", self.logTag);
        }
    }];
}

- (void)runAsyncIfNoLocalNumber:(void (^)())block
{
    [self.newDatabaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction *_Nonnull transaction) {
        if ([transaction objectForKey:TSStorageRegisteredNumberKey inCollection:TSStorageUserAccountCollection]) {
            DDLogDebug(@"%@ Skipping new-user block since local number is already registered", self.logTag);
        } else {
            block();
        }
    }];
}

+ (NSString *)signalingKey {
    return [[self sharedManager] stringForKey:TSStorageServerSignalingKey inCollection:TSStorageUserAccountCollection];
}

+ (NSString *)serverAuthToken {
    return [[self sharedManager] stringForKey:TSStorageServerAuthToken inCollection:TSStorageUserAccountCollection];
}

- (void)storePhoneNumber:(NSString *)phoneNumber
{
    [self.dbConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:phoneNumber
                        forKey:TSStorageRegisteredNumberKey
                  inCollection:TSStorageUserAccountCollection];
    }];
}

+ (void)storeServerToken:(NSString *)authToken signalingKey:(NSString *)signalingKey {
    YapDatabaseConnection *dbConn = [[self sharedManager] dbConnection];

    [dbConn readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
      [transaction setObject:authToken forKey:TSStorageServerAuthToken inCollection:TSStorageUserAccountCollection];
      [transaction setObject:signalingKey
                      forKey:TSStorageServerSignalingKey
                inCollection:TSStorageUserAccountCollection];

    }];
}

#pragma mark - Logging

+ (NSString *)logTag
{
    return [NSString stringWithFormat:@"[%@]", self.class];
}

- (NSString *)logTag
{
    return self.class.logTag;
}

@end
