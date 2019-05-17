//
//  TWChatComboBoxCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 17/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatComboBoxCell.h"

@interface TWChatComboBoxCell () {
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UILabel *_labelValue;
}
@end


@implementation TWChatComboBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    [super setParam:param];
    _labelTitle.text = param.name;
    _labelValue.text = param.value.length? param.value : @"Выберите";
}

- (NSArray <UIAlertAction *> *)actions {
    
    //for (NSString *value in self.param.)
    return @[];
}

#pragma mark - <TWChatUserDataCellProtocol> -
- (void)didSelectCellWithViewController:(UIViewController *)controller {
    UIAlertController *alert = [UIAlertController alertWithActionsAndTitle:@"" andMessage:@"Выберите" arrayAlertActions:@[]];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
