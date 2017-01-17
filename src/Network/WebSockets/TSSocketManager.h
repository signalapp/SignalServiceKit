//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

typedef enum : NSUInteger {
    kSocketStatusOpen,
    kSocketStatusClosed,
    kSocketStatusConnecting,
} SocketStatus;

static void *kSocketStatusObservationContext = &kSocketStatusObservationContext;

extern NSString *const SocketOpenedNotification;
extern NSString *const SocketClosedNotification;
extern NSString *const SocketConnectingNotification;

@interface TSSocketManager : NSObject <SRWebSocketDelegate>

+ (void)becomeActiveFromForeground;
+ (void)becomeActiveFromBackground;

+ (void)resignActivity;
+ (void)sendNotification;

@end
