//
//  TWChatComboBoxCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 17/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatComboBoxCell.h"
#import "TWChatBotFunctionComboBoxParam.h"

@interface TWChatComboBoxCell () {
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UILabel *_labelValue;
}
@end


@implementation TWChatComboBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    [super setParam:param];
    _labelTitle.text = self.param.desc;
    _labelValue.text = self.param.validate? param.value : @"Выберите";
}

- (NSArray <UIAlertAction *> *)actions {
    
    NSMutableArray *actions = @[].mutableCopy;
    
    if ([self.param isKindOfClass:TWChatBotFunctionComboBoxParam.class]) {
        TWChatBotFunctionComboBoxParam *param = (TWChatBotFunctionComboBoxParam *)self.param;
        [param.values enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:obj
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                
                                                               self.param.value = action.title;
            }];
        
            [actions addObject:action];
        }];
        
        if (actions.count) {
            UIAlertAction *actCancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
            [actions addObject:actCancel];
        }
    }
    return actions.copy;
}

#pragma mark - <TWChatUserDataCellProtocol> -
- (void)didSelectCellWithViewController:(UIViewController *)controller {
    
    NSArray *actions = [self actions];
    if (actions.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:self.param.desc preferredStyle:UIAlertControllerStyleActionSheet];
        [actions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [alert addAction:obj];
        }];
        
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

@end
