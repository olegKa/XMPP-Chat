//
//  TWChatDataProvider.m
//  XMPPTest
//
//  Created by OLEG KALININ on 21.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatDataProvider.h"
#import "AFNetworking.h"


@interface TWChatDataProvider ()

@end

@implementation TWChatDataProvider

+ (instancetype)shared {
    static TWChatDataProvider *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[TWChatDataProvider alloc] init];
    });
    
    return shared;
}

- (instancetype)init {
    if (self == [super init]) {
        _scheme = @"http://";
        _url = @"185.246.65.33:8080";
        _path = @"/xmppManager/rest/manager/";
    }
    return self;
}

- (NSString *)requestUrlWithMethod:(NSString *)method
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@%@%@", _scheme, _url, _path, method];
    return strUrl;
}

- (void)postMethod:(NSString *)method params:(NSDictionary *)params completion:(TWChatResponse)completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSError *error;
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                          URLString:[self requestUrlWithMethod:method]
                                                                         parameters:params
                                                                              error:&error];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        // upload progress
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        // dounload progress
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            BLOCK_SAFE_RUN(completion, nil, error);
        } else {
            BLOCK_SAFE_RUN(completion, nil, [self errorWithResponse:(NSHTTPURLResponse *)response]);
        }
    }];
    
    [dataTask resume];
}

- (NSError *)errorWithResponse:(NSHTTPURLResponse * _Nonnull)response
{
    NSError *error = nil;
    NSString *userInfo;
    switch (response.statusCode) {
        case kChatResponseCodeBadData:
            userInfo = @"Неверные параметры";
            break;
        case kChatResponseCodeNotFound:
            userInfo = @"Объект не найден";
            break;
        default:
            break;
    }
    
    if (userInfo.length) {
        error = [NSError errorWithDomain:response.URL.host code:response.statusCode userInfo:@{NSLocalizedDescriptionKey: userInfo}];
    }
    
    return error;
}

#pragma mark - User Requests
- (void)joinBotToRoom:(NSString *)room completion:(TWChatResponse)completion
{
    [self postMethod:@"getBot"
              params:@{@"room" : room,
                       @"command" : @"join"
                       }
          completion:completion];
}

- (void)createClientName:(NSString *)name password:(NSString *)password completion:(TWChatResponse)completion
{
    [self postMethod:@"createClient"
              params:@{@"user" : name,
                       @"pass" : password
                       }
          completion:completion];
}

- (void)createRoom:(NSString *)room completion:(TWChatResponse)completion
{
    [self postMethod:@"createMUCRoom"
              params:@{@"roomName" : room}
          completion:completion];
}


#pragma mark - Properties
- (NSString *)resourcePath
{
    return [NSString stringWithFormat:@"%@%@%@", _scheme, _url, @"/xmppManager"];
}
@end
