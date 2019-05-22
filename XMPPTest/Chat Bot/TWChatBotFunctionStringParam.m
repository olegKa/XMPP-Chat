//
//  TWChatBotFunctionStringParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 21.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionStringParam.h"

@implementation TWChatBotFunctionStringParam

- (BOOL)validate {
    
    NSString *val = self.value;
    BOOL retVal = val.length > 0;
    
    retVal = retVal && (self.maxLength >= val.length || self.maxLength == 0);
    retVal = retVal && (self.minLength <= val.length || self.minLength == 0);
    
    return retVal;
}

@end
