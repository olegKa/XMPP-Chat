//
//  NSDate+TWChat.m
//  XMPPTest
//
//  Created by OLEG KALININ on 26.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "NSDate+TWChat.h"
#import "NSDate+Escort.h"

@implementation NSDate (TWChat)

- (NSString *)stringGroup
{
    NSString *str;
    if (self.isToday) {
        str = @"Сегодня";
    } else if (self.isYesterday) {
        str = @"Вчера";
    } else {
        NSDateFormatter *df = [NSDateFormatter new];
        if (self.year == NSDate.date.year) {
            df.dateFormat = @"dd MMMM, EE";
        } else {
            df.dateFormat = @"dd MMMM yyyy";
        }
        str = [df stringFromDate:self];
    }
    
    return str;
}

- (NSString *)stringMessage
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"HH:mm";
    return [df stringFromDate:self];
}

@end
