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

@interface TWMessage : RCMessage

@property (nonatomic, strong) NSArray <TWChatBotAction *> *actions;

- (instancetype)initWithBody:(NSString *)body incoming:(BOOL)incoming;
- (instancetype)initWithAction:(TWChatBotAction *)action;

+ (NSString *)messageTextWithText:(NSString *)text;
+ (NSString *)messageTextWithAction:(TWChatBotAction *)action;

@end

NS_ASSUME_NONNULL_END
