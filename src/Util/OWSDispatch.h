//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface OWSDispatch : NSObject

/**
 * Attachment downloading
 */
+ (dispatch_queue_t)attachmentsQueue;

+ (dispatch_queue_t)sendingQueue;

@end

NS_ASSUME_NONNULL_END
