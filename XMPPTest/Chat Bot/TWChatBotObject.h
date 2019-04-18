//
//  TWChatBotObject.h
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWChatBotObject : NSObject

@property (nonatomic, readonly) NSDictionary *json;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
