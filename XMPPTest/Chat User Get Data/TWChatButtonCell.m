//
//  TWChatButtonCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatButtonCell.h"

@interface TWChatButtonCell ()
{
    __weak IBOutlet UIButton *_button;
}
@end

@implementation TWChatButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEnabled:(BOOL)enabled {
    _button.enabled = enabled;
}

- (BOOL)enabled {
    return _button.enabled;
}

- (IBAction)buttonTap:(id)sender
{
    if (_buttonHandler) {
        _buttonHandler(sender);
    }
}

@end
