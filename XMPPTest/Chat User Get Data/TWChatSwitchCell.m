//
//  TWChatSwitchCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 21.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatSwitchCell.h"

@interface TWChatSwitchCell ()
{
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UISwitch *_switch;
}

@end

@implementation TWChatSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    [super setParam:param];
    
    _labelTitle.text = param.desc;
    _switch.on = [param.value boolValue];
    
}

- (IBAction)doSwitch:(UISwitch *)sender {
    self.param.value = @(sender.on);
}

@end
