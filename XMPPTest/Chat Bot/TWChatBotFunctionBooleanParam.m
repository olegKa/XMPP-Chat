//
//  TWChatBotFunctionBooleanParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 21.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionBooleanParam.h"

@implementation TWChatBotFunctionBooleanParam

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        self.value = @([json[@"paramValue"] boolValue]);
        self.isOptional = YES;
    }
    return self;
}

- (NSDictionary *)json {
    NSMutableDictionary *json = [super json].mutableCopy;
    json[@"paramValue"] = [self.value boolValue]?  @"""true""":@"""false""";
    return json.copy;
}


@end
