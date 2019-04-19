//
//  TWFunction.h
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

/*
 "function":{
    "functionName":"getDataFromUser",
         "outputParams":[
         {"paramType":"commonInputField",
         "paramDesc":"commonInputField",
         "security":"true",
         "minLength":"0",
         "keyBoardType":"commonKeyboard",
         "paramName":"Поле ввода",
         "paramId":"170193837",
         "maxLength":"100",
         "paramValue":"Введите сюда текст",
         "mask":""
 }],
 
 "inputParams":[
 {"paramType":"titleField","paramDesc":"titleField","security":"false","keyBoardType":"","paramName":"title","paramId":"756835219","paramValue":"Это тестовый опросник","mask":""}
 ]
 
 },
 */

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

@interface TWChatBotFunction : TWChatBotObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSArray <TWChatBotFunctionParam *> *inputParams;
@property (nonatomic, readonly) NSArray <TWChatBotFunctionParam *> *outputParams;

@property (nonatomic, assign) TWChatBotFunctionResultType resultType;

- (NSString *)outputDescription;

@end



NS_ASSUME_NONNULL_END
