//
//  TWMessage.m
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWMessage.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "UIImage+animatedGIF.h"


@interface TWMessage ()
{
    NSInteger _senderType;
}

@property (nonatomic, strong) NSString *plainText;


@end

@implementation TWMessage

- (instancetype)initWithPictureUrl:(NSURL *)url incoming:(BOOL)incoming complation:(void(^)(void))completion
{
    self = [super init];
    self.type = RC_TYPE_PICTURE;
    self.status = RC_STATUS_LOADING;
    self.incoming = incoming;
    self.outgoing = !incoming;
    self.picture_width = RCMessages.pictureBubbleWidth;
    
    if (url) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url
                                                              options:0
                                                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        }
                                                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.status = RC_STATUS_SUCCEED;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.picture_image = image;
                self.picture_height = self.picture_width * image.size.height / image.size.width;
                if (completion) {
                    completion();
                }
            });
            
        }];
    }
    
    return self;
}

- (instancetype)initWithAnimatedGIFUrl:(NSURL *)url incoming:(BOOL)incoming
{
    self = [super init];
    self.type = RC_TYPE_PICTURE;
    //self.status = RC_STATUS_LOADING;
    self.incoming = incoming;
    self.outgoing = !incoming;
    self.picture_width = RCMessages.pictureBubbleWidth;
    
    if (url) {
        self.picture_image = [UIImage animatedImageWithAnimatedGIFURL:url];
        self.picture_height = self.picture_width * self.picture_image.size.height / self.picture_image.size.width;
        self.status = RC_STATUS_SUCCEED;
    }
    
    
    
    return self;
}

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
                
                // check if picture
                NSString *imgPath = [message[@"imgUrl"] isEqualToString:@"N/A"]? nil: message[@"imgUrl"];
                NSString *rtfText = [message[@"rtfText"] isEqualToString:@"N/A"]? nil: message[@"rtfText"];
                
                if (imgPath) {
                    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/resources/%@", TWChatDataProvider.shared.resourcePath, imgPath]];
                    if ([imgPath.pathExtension isEqualToString:@"gif"]) {
                        // анимированная гифка
                        //NSURL *imgUrl = [NSURL URLWithString:@"https://media.giphy.com/media/XIqCQx02E1U9W/giphy.gif"];
                        self = [self initWithAnimatedGIFUrl:imgUrl incoming:incoming];
                    } else {
                        // обычная картинка
                        self = [self initWithPictureUrl:imgUrl incoming:incoming complation:^{
                            if (self.loadingHandle) {
                                self.loadingHandle(self);
                            }
                        }];
                    }
                    
                // check if Attributed String
                    
                } else if (rtfText) {
                    
                    NSData *rtfData = [rtfText dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *const options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                    };
                    
                    NSAttributedString *text = [[NSAttributedString alloc] initWithData: rtfData
                                                                                options: options
                                                                     documentAttributes: nil
                                                                                  error: nil];
                    self = [super initWithAttributedText:text incoming:incoming];
                } else {
                    // Plain Text
                    NSString *plainText = message[@"plainText"];
                    if ([plainText isEqualToString:@"Тест "]) {
                        self = [super initWithLatitude:55.157210 longitude:61.367877 incoming:incoming completion:^{
                            if (self.loadingHandle) {
                                self.loadingHandle(self);
                            }
                        }];
                    } else if (plainText){
                        NSDictionary *attributes = @{NSFontAttributeName: RCMessages.textFont,
                                                     NSForegroundColorAttributeName: incoming? RCMessages.textTextColorIncoming: RCMessages.textTextColorOutgoing
                                                     };
                        self = [super initWithAttributedText:[[NSAttributedString alloc] initWithString:plainText
                                                                                             attributes:attributes]
                                                    incoming:incoming];
                        self.plainText = plainText;
                    }
                }
                
                if (message[@"function"]) {
                    _function = [[TWChatBotFunction alloc] initWithJSON:message[@"function"]];
                    if (!self.plainText && _function) {
                        
                        NSDictionary *attributes = @{NSFontAttributeName: RCMessages.textFont,
                                                     NSForegroundColorAttributeName: incoming? RCMessages.textTextColorIncoming: RCMessages.textTextColorOutgoing
                                                     };
                        self = [super initWithAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Выполнить \"%@\"?", _function.name]
                                                                                                    attributes:attributes]
                                                           incoming:incoming];
                    }
                    
                    /*
                    // Add vidgets OK|CANCEL
                    TWChatBotAction *actionApprove = [[TWChatBotAction alloc] initWithTitle:@"OK" image:nil handler:^(TWChatBotAction * _Nonnull action) {
                        NSLog(@"## DO FuNCTION");
                    }];
                    TWChatBotAction *actionDenied = [[TWChatBotAction alloc] initWithTitle:@"Отмена" image:nil handler:^(TWChatBotAction * _Nonnull action) {
                        NSLog(@"## CANCEL FuNCTION");
                    }];
                    self.actions = @[actionApprove, actionDenied];
                    */
                } else {
                    // initialize vidgets
                    NSDictionary *vidget = message[@"vidget"];
                    NSArray <NSDictionary *> *vidgetList = vidget[@"vidgetRowsList"];
                    if ([vidgetList isKindOfClass:NSArray.class]) {
                        NSMutableArray *actions = @[].mutableCopy;
                        [vidgetList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            TWChatBotAction *action = [[TWChatBotAction alloc] initWithJSON:obj handler:nil];
                            [actions addObject:action];
                        }];
                        self.actions = actions.copy;
                    }
                }
                
                // initalize sender type
                if (message[@"senderType"]) {
                    _senderType = [message[@"senderType"] integerValue];
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
                                    @{@"vidgetRowsList": @[action.json]},
                                 @"plainText": action.title,
                                 @"senderType": @(kSenderTypeClient)
                                 },
                           
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

+ (NSString *)messageTextWithText:(NSString *)text
{
    NSString *jsonString;
    NSDictionary *json = @{@"message":
                               @{@"vidget":
                                     @{@"vidgetRowsList": @[]},
                                 @"plainText": text,
                                 @"senderType": @(kSenderTypeClient)
                                 },
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

+ (NSString *)messageWithFunction:(TWChatBotFunction *)function {
    
    NSString *jsonString;
    NSDictionary *json = @{@"message":
                               @{@"function": function.json,
                                 @"plainText": function.resultType == kChatBotFunctionResultApproved? [NSString stringWithFormat:@"Получи фашист гранату\n%@", function.outputDescription]:@"Фигвам - национальная индейская изба",
                                 @"senderType": @(kSenderTypeClient)
                                 },
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

#pragma  mark - Properties
- (TWSenderType)senderType
{
    switch (_senderType) {
        case kSenderTypeBot:
            return  kSenderTypeBot;
        case kSenderTypeClient:
            return kSenderTypeClient;
        case kSenderTypeOperator:
            return kSenderTypeOperator;
        default:
            return kSenderTypeUnknown;
            break;
    }
}

@end
