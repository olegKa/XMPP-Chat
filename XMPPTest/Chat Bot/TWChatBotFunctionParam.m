//
//  TWChatBotFunctionParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 17/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionParam.h"

@interface TWChatBotFunctionParam ()

@property (nonatomic, strong) NSString *internalType;
//@property (nonatomic, strong) NSString *internalValue;

@end

@implementation TWChatBotFunctionParam

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        self.ID = json[@"paramId"];
        self.value = json[@"paramValue"];
        self.internalType = json[@"paramType"];
        self.name = json[@"paramName"];
        self.desc = json[@"paramDesc"];
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
                           @"paramType":_internalType
                           };
    return json;
}

- (TWFunctionParamType)type {
    return [TWChatBotFunctionParam typeByString:_internalType];
}

+ (TWFunctionParamType)typeByString:(NSString *)str {
    TWFunctionParamType result = TWFunctionParamTypeUnknown;
    if ([str isEqualToString:@"string"]) {
        result = TWFunctionParamTypeString;
    } else if ([str isEqualToString:@"checklist"]) {
        result = TWFunctionParamTypeCheckBox;
    } else if ([str isEqualToString:@"comboBox"]) {
        result = TWFunctionParamTypeComboBox;
    } else if ([str isEqualToString:@"boolean"]) {
        result = TWFunctionParamTypeBool;
    } else if ([str isEqualToString:@"date"]) {
        result = TWFunctionParamTypeDate;
    } else if ([str isEqualToString:@"dateperiod"]) {
        result = TWFunctionParamTypePeriod;
    }
    
    return result;
}

- (BOOL)validate {
    // Abstract
    return YES;
}

- (NSString *)prettyValueDescription {
    return @"";
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

