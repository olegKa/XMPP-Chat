//
//  TWChatBotFunctionParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 17/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionParam.h"

@implementation TWChatBotFunctionParam

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        self.ID = json[@"paramId"];
        self.type = json[@"paramType"];
        self.name = json[@"paramName"];
        self.desc = json[@"paramDesc"];
        self.value = json[@"paramValue"];
        self.mask = json[@"mask"];
        self.minLength = [json[@"minLength"] integerValue];
        self.maxLength = [json[@"maxLength"] integerValue];
    }
    return self;
}

- (NSDictionary *)json {
    
    NSDictionary *json = @{
                           @"paramId": _ID,
                           @"paramName": _name,
                           @"paramValue": _value,
                           @"paramType":_type
                           };
    return json;
}

@end

@implementation TWChatBotFunctionResult

- (instancetype)initWithResultType:(TWChatBotFunctionResultType)type {
    if (self = [super init]) {
        self.name = @"paramResult";
        self.ID = @"none";
        switch (type) {
            case kChatBotFunctionResultDenied:
                self.name = @"denied";
                break;
            case kChatBotFunctionResultApproved:
                self.name = @"approved";
                break;
            default:
                break;
        }
        self.value = @"";
    }
    return self;
}

@end

