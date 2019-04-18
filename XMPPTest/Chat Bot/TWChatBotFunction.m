//
//  TWFunction.m
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunction.h"

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
                           @"paramValue": _value
                           };
    return json;
}

@end

#pragma mark - TWFunction -
@interface TWChatBotFunction ()
{
    NSMutableArray <TWChatBotFunctionParam *> *_inputParams;
    NSMutableArray <TWChatBotFunctionParam *> *_outputParams;
}
@end;

@implementation TWChatBotFunction

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        
        _inputParams = @[].mutableCopy;
        _outputParams = @[].mutableCopy;
        
        self.name = json[@"functionName"];
        
        for (NSDictionary *inputParam in json[@"inputParams"]) {
            TWChatBotFunctionParam *param = [[TWChatBotFunctionParam alloc] initWithJSON:inputParam];
            if (param) {
                [_inputParams addObject:param];
            }
        }
        
        for (NSDictionary *outputParam in json[@"outputParams"]) {
            TWChatBotFunctionParam *param = [[TWChatBotFunctionParam alloc] initWithJSON:outputParam];
            if (param) {
                [_outputParams addObject:param];
            }
        }
    }
    return self;
}


#pragma mark - Properties
- (NSArray <TWChatBotFunctionParam *> *)inputParams {
    return _inputParams;
}

- (NSArray <TWChatBotFunctionParam *> *)outputParams {
    return _outputParams;
}

- (NSDictionary *)json {
    
    NSMutableArray *outputParams = @[].mutableCopy;
    [_outputParams enumerateObjectsUsingBlock:^(TWChatBotFunctionParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [outputParams addObject:obj.json];
    }];
    
    return @{@"functionName": _name,
             @"outputParams": outputParams
             };
}

- (NSString *)outputDescription {
    NSMutableString *desc = @"".mutableCopy;
    [_outputParams enumerateObjectsUsingBlock:^(TWChatBotFunctionParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [desc appendString:[NSString stringWithFormat:@"[%@]=%@", obj.name, obj.value]];
    }];
    return desc.copy;
}

@end
