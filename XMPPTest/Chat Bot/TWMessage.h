//
//  TWMessage.h
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "RCMessage.h"
#import "TWChatBotAction.h"
#import "TWChatBotFunction.h"

NS_ASSUME_NONNULL_BEGIN

@class TWMessage;

typedef void (^TWMessageLoadingHandle) (TWMessage *message);

typedef NS_ENUM(NSInteger, TWSenderType) {
    kSenderTypeUnknown = -1,
    kSenderTypeClient = 0,
    kSenderTypeBot = 1,
    kSenderTypeOperator = 2
};

@interface TWMessage : RCMessage

@property (nonatomic, strong) NSString *elementID;
@property (nonatomic, strong) NSArray <TWChatBotAction *> *actions;
@property (nonatomic, strong) TWChatBotFunction *function;
@property (nonatomic, copy) TWMessageLoadingHandle loadingHandle;
@property (nonatomic, readonly) TWSenderType senderType;

- (instancetype)initWithBody:(NSString *)body incoming:(BOOL)incoming;
- (instancetype)initWithPictureUrl:(NSURL *)url incoming:(BOOL)incoming complation:(void(^)(void))completion;
- (instancetype)initWithAnimatedGIFUrl:(NSURL *)url incoming:(BOOL)incoming;
- (instancetype)initWithAction:(TWChatBotAction *)action;

+ (NSString *)messageTextWithText:(NSString *)text;
+ (NSString *)messageTextWithAction:(TWChatBotAction *)action;
+ (NSString *)messageWithFunction:(TWChatBotFunction *)function;

@end

NS_ASSUME_NONNULL_END

/*
 {"message":
    {
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
                        {"paramType":"titleField",
                        "paramDesc":"titleField",
                        "security":"false",
                        "keyBoardType":"",
                        "paramName":"title",
                        "paramId":"756835219",
                        "paramValue":"Это тестовый опросник",
                        "mask":""}
                    ]
                    },
        "vidget":{
            "vidgetRowsList":[
                {"icon":"icons/toATMs.png","text":"Банкоматы","type":"common","keyWord":"$toATMs$"},
                {"icon":"icons/toSupport.png","text":"Техподдержка","type":"common","keyWord":"$toSupport$"},
                {"icon":"icons/toBranches.png","text":"Филиалы","type":"common","keyWord":"$toBranches$"},
                {"icon":"icons/news.png","text":"Новые возможности","type":"common","keyWord":"$news$"},
                {"icon":"icons/joke.png","text":"Анекдот","type":"common","keyWord":"$joke$"},
                {"icon":"icons/howTo.png","text":"Руководства","type":"common","keyWord":"$toHowTo$"}]},
        "senderType":1
    }
 }
 
 </body><stanza-id xmlns="urn:xmpp:sid:0" id="287f6aa7-bbdc-4bb8-9525-0bdcd22e3021" by="user123@clientsessions.juragv.fvds.ru"/><delay xmlns="urn:xmpp:delay" stamp="2019-04-17T11:30:18.109Z" from="user123@clientsessions.juragv.fvds.ru/Bot_КарманБанк"/></message>
 
 */
