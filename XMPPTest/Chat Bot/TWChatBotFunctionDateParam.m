//
//  TWChatBotFunctionDateParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionDateParam.h"

@interface TWChatBotFunctionDateParam ()

@property (nonatomic, readonly) NSDate *date;

@end


@implementation TWChatBotFunctionDateParam

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        
        self.gmt = json[@"gmt"];
        self.dateFormatter = NSDateFormatter.new;
        self.dateFormatter.dateFormat = json[@"dateFormat"];
        
        NSString *value = json[@"paramValue"];
        if ([value isKindOfClass:NSString.class]) {
            self.value = [self.dateFormatter dateFromString:value];
        }
    }
    return self;
}

- (NSDictionary *)json {
    NSMutableDictionary *json = [super json].mutableCopy;
    json[@"paramValue"] = [self.value isKindOfClass:NSDate.class]? [self.dateFormatter stringFromDate:self.value]:@"";
    json[@"dateFormat"] = self.dateFormatter.dateFormat;
    json[@"gmt"] = self.gmt;
    return json.copy;
}

- (NSString *)prettyValueDescription {
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"dd.MM.yyyy";
    return [df stringFromDate:self.value]? :@"Выберите";
}

- (NSDate *)date {
    return [self.dateFormatter dateFromString:self.value];
}

- (BOOL)validate {
    return [self.value isKindOfClass:NSDate.class];
}

@end
