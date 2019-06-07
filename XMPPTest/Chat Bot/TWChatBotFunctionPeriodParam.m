//
//  TWChatBotFunctionPeriodParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionPeriodParam.h"

@interface TWChatBotFunctionPeriodParam ()



@end

@implementation TWChatBotFunctionPeriodParam

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        
        self.gmt = json[@"gmt"];
        self.dateFormatter = NSDateFormatter.new;
        self.dateFormatter.dateFormat = json[@"dateFormat"];
        
        NSArray *value = json[@"paramValue"];
        if ([value isKindOfClass:NSArray.class]) {
            
            NSMutableArray *period = @[].mutableCopy;
            
            if ([value.firstObject isKindOfClass:NSString.class]) {
                self.dateFrom = [self.dateFormatter dateFromString:value.firstObject];
                [period addObject:self.dateFrom];
            }
            
            if ([value.lastObject isKindOfClass:NSString.class]) {
                self.dateTo = [self.dateFormatter dateFromString:value.lastObject];
                [period addObject:self.dateTo];
            }
            
            self.value = period.copy;
        }
    }
    return self;
}

- (NSDictionary *)json {
    NSMutableDictionary *json = [super json].mutableCopy;
    
    NSMutableArray *value = @[].mutableCopy;
    if ([(NSArray *)self.value firstObject]) {
        [value addObject:[self.dateFormatter stringFromDate:[(NSArray *)self.value firstObject]]];
        [value addObject:[self.dateFormatter stringFromDate:[(NSArray *)self.value lastObject]]? :NSNull.null];
    }
    
    json[@"paramValue"] = value.copy;
    json[@"dateFormat"] = self.dateFormatter.dateFormat;
    json[@"gmt"] = self.gmt;
    return json.copy;
}

- (BOOL)validate {
    return [self.value isKindOfClass:NSArray.class] && [(NSArray *)self.value count] > 1;
}

@end
