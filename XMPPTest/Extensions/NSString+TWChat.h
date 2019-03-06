//
//  NSString+TWChat.h
//  XMPPTest
//
//  Created by OLEG KALININ on 05.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TWChat)

@property (nonatomic, readonly) NSDictionary *body;
@property (nonatomic, readonly) NSDictionary *message;
@property (nonatomic, readonly) NSString *plainText;

@end

NS_ASSUME_NONNULL_END
