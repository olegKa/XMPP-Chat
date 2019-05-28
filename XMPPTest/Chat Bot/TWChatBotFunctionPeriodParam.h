//
//  TWChatBotFunctionPeriodParam.h
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotFunctionDateParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWChatBotFunctionPeriodParam : TWChatBotFunctionDateParam

@property (nonatomic, strong) NSDate *dateFrom;
@property (nonatomic, strong) NSDate *dateTo;

@end

NS_ASSUME_NONNULL_END
