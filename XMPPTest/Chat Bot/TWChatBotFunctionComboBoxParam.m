//
//  TWChatBotFunctionComboBoxParam.m
//  XMPPTest
//
//  Created by OLEG KALININ on 17/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionComboBoxParam.h"

@implementation TWChatBotFunctionComboBoxParam

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        self.values = json[@"comboBoxValues"];
    }
    return self;
}

- (BOOL)validate {
    return [(NSString *)self.value length] > 0;
}

@end
