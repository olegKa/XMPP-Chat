//
//  TWChatTypingIndicator.m
//  XMPPTest
//
//  Created by OLEG KALININ on 26.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatTypingIndicator.h"

@interface TWChatTypingIndicator()
{
    __weak IBOutlet UIView *_container;
    __weak IBOutlet UILabel *_labelText;
}
@end

@implementation TWChatTypingIndicator

+ (instancetype)default
{
    TWChatTypingIndicator *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil].firstObject;
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _container.layer.cornerRadius = _container.bounds.size.height * .5f;
}

- (void)setText:(NSString *)text
{
    _labelText.text = text;
}

@end
