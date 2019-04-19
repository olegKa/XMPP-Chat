//
//  TWChatDataProvider.h
//  XMPPTest
//
//  Created by OLEG KALININ on 21.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TWChatResponse) (NSDictionary *_Nullable json, NSError *_Nullable error);

typedef NS_ENUM(NSInteger, TWChatResponseCode) {
    kChatResponseCodeSuccess    = 200,
    kChatResponseCodeCreated    = 201,
    kChatResponseCodeNotFound   = 500,
    kChatResponseCodeBadData    = 415,
};

NS_ASSUME_NONNULL_BEGIN

@interface TWChatDataProvider : NSObject

@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, readonly) NSString *resourcePath;

+ (instancetype)shared;

- (void)postMethod:(NSString *)method params:(NSDictionary *)params completion:(TWChatResponse)completion;

- (void)joinBotToRoom:(NSString *)room completion:(TWChatResponse)completion;
- (void)createClientName:(NSString *)name password:(NSString *)password completion:(TWChatResponse)completion;
- (void)createRoom:(NSString *)room completion:(TWChatResponse)completion;


@end

NS_ASSUME_NONNULL_END
