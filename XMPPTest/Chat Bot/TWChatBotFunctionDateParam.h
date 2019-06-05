//
//  TWChatBotFunctionDateParam.h
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunction.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWChatBotFunctionDateParam : TWChatBotFunctionParam

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, readonly) NSDateFormatter *presentationFormatter;
@property (nonatomic, strong) NSString *gmt;


@end

NS_ASSUME_NONNULL_END
