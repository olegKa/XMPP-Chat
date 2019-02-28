//
//  TWChatTypingIndicator.h
//  XMPPTest
//
//  Created by OLEG KALININ on 26.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWChatTypingIndicator : UIView

@property (nonatomic, weak) NSString *text;

+ (instancetype)default;

@end

NS_ASSUME_NONNULL_END
