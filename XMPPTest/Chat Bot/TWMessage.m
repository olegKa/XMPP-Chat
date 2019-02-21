//
//  TWMessage.m
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWMessage.h"

@interface TWMessage ()


@property (nonatomic, strong) NSString *plainText;


@end

@implementation TWMessage

- (instancetype)initWithBody:(NSString *)body incoming:(BOOL)incoming
{
    
        NSError *error = nil;
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            // просто текст
            self = [super initWithText:body incoming:incoming];
        } else {
            // json
            if ([json isKindOfClass:NSDictionary.class]) {
                NSDictionary *message = json[@"message"];
                self.plainText = message[@"plainText"];
                self = [super initWithText:_plainText incoming:incoming];
                
                NSDictionary *vidget = message[@"vidget"];
                NSArray <NSDictionary *> *vidgetList = vidget[@"vidgetRowsList"];
                if ([vidgetList isKindOfClass:NSArray.class]) {
                    NSMutableArray *actions = @[].mutableCopy;
                    [vidgetList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        TWChatBotAction *action = [[TWChatBotAction alloc] initWithJSON:obj handler:^(NSString * _Nonnull keyWord, NSString * _Nonnull text) {
                            NSLog(@"keyWord is [%@]", keyWord);
                        }];
                        [actions addObject:action];
                    }];
                    self.actions = actions.copy;
                }
                
            }
            
        }
    
    return self;
}

+ (NSString *)messageTextWithAction:(TWChatBotAction *)action
{
    NSString *jsonString;
    NSDictionary *json = @{@"message":
                               @{@"vidget":
                                    @{@"vidgetRowsList": @[action.json]}},
                           @"plainText": action.title
                           };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:0
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

@end
