//
//  TWChatBotFunctionParam.h
//  XMPPTest
//
//  Created by OLEG KALININ on 17/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotObject.h"

typedef NS_ENUM(NSInteger, TWFunctionParamType) {
    TWFunctionParamTypeUnknown,
    TWFunctionParamTypeString,
    TWFunctionParamTypeNumber,
    TWFunctionParamTypeBool,
    TWFunctionParamTypeComboBox,
    TWFunctionParamTypeCheckBox,
};

NS_ASSUME_NONNULL_BEGIN

@interface TWChatBotFunctionParam : TWChatBotObject

/**
 value может быть любого типа и реально зависит от типа параметра
 */
@property (nonatomic, strong, setter=setValue:) id value;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *mask;
@property (nonatomic, assign) NSInteger minLength;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) BOOL isSecurity;
@property (nonatomic, assign) BOOL isOptional;

@property (nonatomic, readonly) TWFunctionParamType type;

- (BOOL)validate;

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
