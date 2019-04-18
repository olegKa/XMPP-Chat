//
//  TWChatBotAction.h
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotObject.h"

NS_ASSUME_NONNULL_BEGIN

@class TWChatBotAction;

typedef void (^TWChatBotActionHandler) (TWChatBotAction *action);

@interface TWChatBotAction : TWChatBotObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *iconUrl;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, copy) TWChatBotActionHandler handler;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image handler:(TWChatBotActionHandler)handler;
- (instancetype)initWithJSON:(NSDictionary *)json handler:(TWChatBotActionHandler)handler;
+ (instancetype)botActionWithTitle:(NSString *)title image:(UIImage *)image handler:(TWChatBotActionHandler)handler;

@end

NS_ASSUME_NONNULL_END
