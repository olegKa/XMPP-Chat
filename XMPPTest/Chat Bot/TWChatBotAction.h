//
//  TWChatBotAction.h
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TWChatBotActionHandler) (NSString *keyWord, NSString *text);

@interface TWChatBotAction : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, copy) TWChatBotActionHandler handler;
@property (nonatomic, readonly) NSDictionary *json;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image handler:(TWChatBotActionHandler)handler;
- (instancetype)initWithJSON:(NSDictionary *)json handler:(TWChatBotActionHandler)handler;
+ (instancetype)botActionWithTitle:(NSString *)title image:(UIImage *)image handler:(TWChatBotActionHandler)handler;

@end

NS_ASSUME_NONNULL_END