//
//  TWChatPeriodCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 28.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatPeriodCell.h"
#import "TWDatePickerBottomSheetController.h"
#import "TWChatBotFunctionPeriodParam.h"

@interface TWChatPeriodCell () <TWDatePickerSelectorDataSource>
{
    __weak IBOutlet UILabel *_labelFrom;
    __weak IBOutlet UILabel *_labelTo;
    
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, readonly) TWChatBotFunctionPeriodParam *parametr;

@end

@implementation TWChatPeriodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd.MM.yyyy";
    
    UITapGestureRecognizer *tapFrom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFrom:)];
    tapFrom.numberOfTapsRequired = 1;
    [_labelFrom addGestureRecognizer:tapFrom];
    
    UITapGestureRecognizer *tapTo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTo:)];
    tapFrom.numberOfTapsRequired = 1;
    [_labelTo addGestureRecognizer:tapTo];
    
    _labelFrom.userInteractionEnabled = YES;
    _labelTo.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    [super setParam:param];
    
    TWChatBotFunctionPeriodParam *period = (TWChatBotFunctionPeriodParam *)param;
    _labelFrom.text = [dateFormatter stringFromDate:period.dateFrom]? : @"Выберите";
    _labelTo.text = [dateFormatter stringFromDate:period.dateTo]? : @"Выберите";
    
}

- (TWChatBotFunctionPeriodParam *)parametr {
    return (TWChatBotFunctionPeriodParam *)self.param;
}

- (TWDatePickerBottomSheetController *)datePicker {
    
    TWDatePickerBottomSheetController *datePicker = [TWDatePickerBottomSheetController datePickerController];
    datePicker.mode = kDatePickerModePeriod;
    datePicker.dateFormat = self.parametr.dateFormatter.dateFormat;
    datePicker.dataSource = self;
    
    __weak TWDatePickerBottomSheetController *_weakDatePicker = datePicker;
    datePicker.datePickerHandler = ^(BOOL cancel, NSArray <NSDate *> *_Nullable dates) {
        
        if (!cancel) {
            self.parametr.dateFrom = dates.firstObject;
            self.parametr.dateTo = dates.lastObject;
            self.parametr.value = dates;
        }
        [_weakDatePicker dismissViewControllerAnimated:YES completion:nil];
    };
    
    return datePicker;
}

#pragma mark - User Actions -
- (void)tapFrom:(UITapGestureRecognizer *)gest {
    TWDatePickerBottomSheetController *datePicker = [self datePicker];
    [datePicker gotoStage:kDatePickerStageDateFrom];
}

- (void)tapTo:(UITapGestureRecognizer *)gest {
    
}

#pragma mark - <TWChatUserDataCellProtocol> -
- (void)didSelectCellWithViewController:(UIViewController *)controller {
    TWDatePickerBottomSheetController *datePicker = [self datePicker];
    [controller presentViewController:datePicker animated:true completion:nil];
}

#pragma mark - TWDatePickerSelectorDataSource -
- (NSDate *)datePickerController:(TWDatePickerBottomSheetController *)controller dateForStage:(TWDatePickerStage)stage {
    
    switch (stage) {
        case kDatePickerStageDateFrom:
            return self.parametr.dateFrom;
        break;
        case kDatePickerStageDateTo:
            return self.parametr.dateTo;
        break;
        default:
            break;
    }
    return nil;
}

@end
