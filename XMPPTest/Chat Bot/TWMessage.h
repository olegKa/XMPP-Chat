//
//  TWMessage.h
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "RCMessage.h"
#import "TWChatBotAction.h"

NS_ASSUME_NONNULL_BEGIN

@class TWMessage;

typedef void (^TWMessageLoadingHandle) (TWMessage *message);

@interface TWMessage : RCMessage

@property (nonatomic, strong) NSString *elementID;
@property (nonatomic, strong) NSArray <TWChatBotAction *> *actions;
@property (nonatomic, copy) TWMessageLoadingHandle loadingHandle;

- (instancetype)initWithBody:(NSString *)body incoming:(BOOL)incoming;
- (instancetype)initWithPictureUrl:(NSURL *)url incoming:(BOOL)incoming complation:(void(^)(void))completion;
- (instancetype)initWithAction:(TWChatBotAction *)action;

+ (NSString *)messageTextWithText:(NSString *)text;
+ (NSString *)messageTextWithAction:(TWChatBotAction *)action;

@end

NS_ASSUME_NONNULL_END
