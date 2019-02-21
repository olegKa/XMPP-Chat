//
//  TWChatBotActionButton.h
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWChatBotAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWChatBotActionButton : UIButton

@property (nonatomic, strong) TWChatBotAction *action;

+ (instancetype)buttonWithAction:(TWChatBotAction *)action;

@end

NS_ASSUME_NONNULL_END
