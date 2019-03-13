//
//  TWChatBotActionButton.m
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatBotActionButton.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation TWChatBotActionButton



+ (instancetype)buttonWithAction:(TWChatBotAction *)action
{
    TWChatBotActionButton *button = [TWChatBotActionButton new];
    button.action = action;
    button.backgroundColor = UIColorFromRGB(0x4A90E2);// C6EF98
    button.titleLabel.textColor = UIColorFromRGB(0x417505);
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:action.iconUrl
                                                          options:SDWebImageDownloaderUseNSURLCache
                                                         progress:nil
                                                        completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
            
            UIImage *scaledImage = [UIImage imageWithCGImage:image.CGImage scale:3 orientation:image.imageOrientation];
            
            [self setImage:scaledImage forState:UIControlStateNormal];
        }
    }];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
    
    [self addTarget:self action:@selector(didPressActionButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didPressActionButton:(id)sender {
    if (_action.handler) {
        _action.handler(_action);
    }
}

@end
