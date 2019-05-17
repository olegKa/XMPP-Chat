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
#import "TWChatBotFunctionParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWChatBotFunction : TWChatBotObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSArray <TWChatBotFunctionParam *> *inputParams;
@property (nonatomic, readonly) NSArray <TWChatBotFunctionParam *> *outputParams;

@property (nonatomic, assign) TWChatBotFunctionResultType resultType;

- (NSString *)outputDescription;

@end



NS_ASSUME_NONNULL_END
