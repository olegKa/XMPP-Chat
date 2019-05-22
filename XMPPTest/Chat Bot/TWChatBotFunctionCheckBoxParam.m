//
//  TWChatBotFunctionCheckBoxParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 21.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionCheckBoxParam.h"

@implementation TWChatBotFunctionCheckBoxParam

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        self.values = json[@"checkListValues"];
        self.value = [NSSet new];
    }
    return self;
}

- (NSDictionary *)json {
    
    NSMutableDictionary *json = [super json].mutableCopy;
    json[@"paramValue"] = [(NSSet *)self.value allObjects];
    return json.copy;
}

- (BOOL)validate {
    return [(NSSet *)self.value count] > 0;
}

@end
