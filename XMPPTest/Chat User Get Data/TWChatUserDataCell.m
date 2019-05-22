//
//  TWChatUserDataCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatUserDataCell.h"

@implementation TWChatUserDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    _param = param;
}

#pragma mark - <TWChatUserDataCellProtocol> -
- (void)didSelectCellWithViewController:(UIViewController *)controller {
    // abstract
}

- (void)configureCellWithParameter:(TWChatBotFunctionParam *)param atIndexPath:(NSIndexPath *)indexPath {
    [self setParam:param];
}

@end
