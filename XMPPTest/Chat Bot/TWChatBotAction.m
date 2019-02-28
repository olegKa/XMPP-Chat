//
//  TWChatBotAction.m
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotAction.h"

@implementation TWChatBotAction

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image handler:(TWChatBotActionHandler)handler
{
    if (self = [super init]) {
        _title = title;
        _image = image;
        _handler = handler;
    }
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json handler:(TWChatBotActionHandler)handler
{
    if (self = [super init]) {
        _title = json[@"text"];
        _image = nil; //[json[@"icon"] isEqualToString:@"N/A"]? [UIImage imageNamed:@"Banned"]: nil;
        
        NSString *iconPath = [json[@"icon"] isEqualToString:@"N/A"]? nil: json[@"icon"];
        if (iconPath) {
            _iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/resources/%@", TWChatDataProvider.shared.resourcePath, iconPath]];
        }
        
        _keyWord = json[@"keyWord"];
        _handler = handler;
    }
    
    return self;
}

+ (instancetype)botActionWithTitle:(NSString *)title image:(UIImage *)image handler:(TWChatBotActionHandler)handler
{
    TWChatBotAction *action = [[TWChatBotAction alloc] initWithTitle:title image:image handler:handler];
    return action;
}

- (NSDictionary *)json
{
    NSMutableDictionary *json = @{}.mutableCopy;
    if (_title) {
        json[@"text"] = _title;
    }
    
    if (_keyWord) {
        json[@"keyWord"] = _keyWord;
    }
    
    return json.copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"key:[%@], title:[%@]", self.keyWord, self.title];
}

@end
