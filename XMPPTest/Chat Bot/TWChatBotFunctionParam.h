//
//  TWChatBotFunctionParam.h
//  XMPPTest
//
//  Created by OLEG KALININ on 17/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWChatBotFunctionParam : TWChatBotObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *mask;
@property (nonatomic, assign) NSInteger minLength;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) BOOL isSecurity;

@end

typedef NS_ENUM(NSInteger, TWChatBotFunctionResultType) {
    kChatBotFunctionResultUnknown,
    kChatBotFunctionResultApproved,
    kChatBotFunctionResultDenied
};

@interface TWChatBotFunctionResult : TWChatBotFunctionParam

- (instancetype)initWithResultType:(TWChatBotFunctionResultType)type;

@end

NS_ASSUME_NONNULL_END
