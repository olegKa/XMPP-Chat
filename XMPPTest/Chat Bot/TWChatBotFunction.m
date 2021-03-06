//
//  TWFunction.m
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunction.h"
#import "TWChatBotFunctionComboBoxParam.h"
#import "TWChatBotFunctionStringParam.h"
#import "TWChatBotFunctionBooleanParam.h"
#import "TWChatBotFunctionCheckBoxParam.h"
#import "TWChatBotFunctionDateParam.h"
#import "TWChatBotFunctionPeriodParam.h"



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
            Class paramClass = [self parameterClassForParam:outputParam];
            NSAssert(paramClass, @"Unknown parameter class");
            id param = [[paramClass alloc] initWithJSON:outputParam];
            if (param) {
                [_outputParams addObject:param];
            }
        }
    }
    return self;
}

- (Class)parameterClassForParam:(NSDictionary *)param {
    
    switch ([TWChatBotFunctionParam typeByString:param[@"paramType"]]) {
        case TWFunctionParamTypeString:
            return TWChatBotFunctionStringParam.class;
        case TWFunctionParamTypeComboBox:
            return TWChatBotFunctionComboBoxParam.class;
        case TWFunctionParamTypeCheckBox:
            return TWChatBotFunctionCheckBoxParam.class;
        case TWFunctionParamTypeBool:
            return TWChatBotFunctionBooleanParam.class;
        case TWFunctionParamTypeDate:
            return TWChatBotFunctionDateParam.class;
        case TWFunctionParamTypePeriod:
            return TWChatBotFunctionPeriodParam.class;
        default:
            break;
    }
    
    return nil;
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
    
    NSString *result;
    switch (_resultType) {
        case kChatBotFunctionResultApproved:
            result = @"approved";
            break;
        case kChatBotFunctionResultDenied:
            result = @"denied";
            break;
        default:
            result = @"unknown";
            break;
    }
    
    return @{@"functionName": _name,
             @"params": outputParams,
             @"status": result
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
