//
//  TWChatMessageCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 22.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatMessageCell.h"

@interface TWChatMessageCell ()
{
    __weak IBOutlet UILabel *_labelBody;
    __weak IBOutlet UILabel *_labelFrom;
    __weak IBOutlet UIImageView *_imageFrom;
}

@end

@implementation TWChatMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(XMPPMessage *)message
{
    _labelBody.text = message.body.copy;
    _labelFrom.text = message.from.user;
}

@end
