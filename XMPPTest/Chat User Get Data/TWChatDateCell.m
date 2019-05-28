//
//  TWChatDateCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 28.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatDateCell.h"
#import "TWDatePickerBottomSheetController.h"
#import "TWChatBotFunctionDateParam.h"

@interface TWChatDateCell () <TWDatePickerSelectorDataSource>
{
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UILabel *_labelValue;
}

@end

@implementation TWChatDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    [super setParam:param];
    
    _labelTitle.text = param.desc;
    _labelValue.text = [param prettyValueDescription];
}

#pragma mark - <TWChatUserDataCellProtocol> -
- (void)didSelectCellWithViewController:(UIViewController *)controller {
    
    TWDatePickerBottomSheetController *datePicker = [TWDatePickerBottomSheetController datePickerController];
    datePicker.dataSource = self;
    datePicker.dateFormat = [(TWChatBotFunctionDateParam *)self.param dateFormatter].dateFormat;
    // Present the bottom sheet
    [controller presentViewController:datePicker animated:true completion:nil];
    
    datePicker.datePickerHandler = ^(BOOL cancel, NSArray <NSDate *> *_Nullable dates) {
        
        if (!cancel) {
            TWChatBotFunctionDateParam *param = (TWChatBotFunctionDateParam *)self.param;
            param.value = dates.firstObject;
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    };

}

#pragma mark - TWDatePickerSelectorDataSource -
- (NSDate *)datePickerController:(TWDatePickerBottomSheetController *)controller dateForStage:(TWDatePickerStage)stage {
    TWChatBotFunctionDateParam *param = (TWChatBotFunctionDateParam *)self.param;
    return param.value;
}

@end
