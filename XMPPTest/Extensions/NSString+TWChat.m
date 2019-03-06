//
//  NSString+TWChat.m
//  XMPPTest
//
//  Created by OLEG KALININ on 05.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "NSString+TWChat.h"

@implementation NSString (TWChat)

- (NSDictionary *)message {
    
    return self.body? self.body[@"message"] : nil;
}

- (NSString *)plainText {
    
    return self.message? self.message[@"plainText"] : nil;
}

- (NSDictionary *)body {
    
    NSError *error = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id body = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return body;
}

@end
