//
//  TWChatBotActionButton.m
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotActionButton.h"

@implementation TWChatBotActionButton



+ (instancetype)buttonWithAction:(TWChatBotAction *)action
{
    TWChatBotActionButton *button = [TWChatBotActionButton new];
    button.action = action;
    button.backgroundColor = UIColorFromRGB(0x4A90E2);// C6EF98
    button.titleLabel.textColor = UIColorFromRGB(0x417505);
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //button.titleLabel.adjustsFontSizeToFitWidth = YES;
    //button.titleLabel.contentMode = UIViewContentModeCenter;
    button.clipsToBounds = YES;
    

    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = 0.5 * self.bounds.size.height;
}

- (void)setAction:(TWChatBotAction *)action
{
    _action = action;
    [self setTitle:action.title forState:UIControlStateNormal];
    [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.image) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
    }
    
    [self addTarget:self action:@selector(didPressActionButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didPressActionButton:(id)sender {
    if (_action.handler) {
        _action.handler(_action.keyWord, _action.title);
    }
}

@end
