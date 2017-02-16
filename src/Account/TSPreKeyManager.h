//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSAccountManager.h"

// Time before deletion of signed PreKeys (measured in seconds)
#define SignedPreKeysDeletionTime 14 * 24 * 60 * 60

@interface TSPreKeyManager : NSObject

+ (void)registerPreKeysWithSuccess:(void (^)())successHandler failure:(void (^)(NSError *error))failureHandler;

+ (void)refreshPreKeys;

@end
