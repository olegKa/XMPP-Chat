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
#import "TWCustomPickerBottomSheetController.h"
#import "TWPeriodOfYearsPickerDataSource.h"
#import "TWPeriodYMPickerDataSource.h"
#import "NSDate+Escort.h"

@interface TWChatPeriodCell () <TWDatePickerSelectorDataSource>
{
    __weak IBOutlet UILabel *_labelTitle;

}

@property (nonatomic, readonly) TWChatBotFunctionPeriodParam *parametr;

@end

@implementation TWChatPeriodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    [super setParam:param];
    
    TWChatBotFunctionPeriodParam *period = (TWChatBotFunctionPeriodParam *)param;
    
    if (!period.dateFrom) {
        _labelTitle.text = @"Выберите";
    } else {
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"Период с: "
                                                                                  attributes:@{NSForegroundColorAttributeName: UIColor.darkGrayColor,
                                                                                               NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                                               }];
        [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self.parametr.presentationFormatter stringFromDate:period.dateFrom]
                                                                      attributes:@{NSForegroundColorAttributeName: UIColor.darkGrayColor,
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:18]}]];
        
        [title appendAttributedString:[[NSAttributedString alloc] initWithString:@" по: "
                                                                      attributes:@{NSForegroundColorAttributeName: UIColor.darkGrayColor,
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:14]}]];
        
        [title appendAttributedString:[[NSAttributedString alloc] initWithString:period.dateTo.year > 1? [self.parametr.presentationFormatter
                                                                                                          stringFromDate:period.dateTo]:@"настоящее время"
                                                                      attributes:@{NSForegroundColorAttributeName: UIColor.darkGrayColor,
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:18]}]];
        _labelTitle.attributedText = title;
    }
    
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

#pragma mark - <TWChatUserDataCellProtocol> -
- (void)didSelectCellWithViewController:(UIViewController *)controller {
    
    if ([self.parametr.dateFormatter.dateFormat isEqualToString:@"yyyy"]) {
        [self presentPeriodOfYearsSelectorFromController:controller];
    } else if ([self.parametr.dateFormatter.dateFormat isEqualToString:@"yyyy-MM"]) {
        [self presentPeriodOfYearsAndMonthSelectorFromController:controller];
        //[self presentPeriodOfYearsSelectorFromController:controller];
    } else {
        TWDatePickerBottomSheetController *datePicker = [self datePicker];
        [controller presentViewController:datePicker animated:true completion:nil];
    }
}

- (void)presentPeriodOfYearsAndMonthSelectorFromController:(UIViewController *)controller {
    TWPeriodYMPickerDataSource *pickerDataSource = [TWPeriodYMPickerDataSource new];
    pickerDataSource.dateFrom = self.parametr.dateFrom;
    pickerDataSource.dateTo = self.parametr.dateTo;
    pickerDataSource.maximumDate = NSDate.date;
    TWCustomPickerBottomSheetController *sheet = [TWCustomPickerBottomSheetController customPickerControllerWithDataSource:pickerDataSource];
    sheet.title = self.parametr.desc;
    __weak typeof(sheet) __weakSheet = sheet;
    sheet.customPickerHandler = ^(BOOL cancel, TWPeriodYMPickerDataSource * _Nullable data) {
        
        if (cancel) {
            //NSLog(@"cancel");
        } else {
            self.parametr.dateFrom = data.dateFrom;
            self.parametr.dateTo = data.dateTo;
            self.parametr.value = @[self.parametr.dateFrom, self.parametr.dateTo? :[NSNull null]];
        }
        
        [__weakSheet dismissViewControllerAnimated:YES completion:nil];
    };
    
    [controller presentViewController:sheet animated:YES completion:nil];
}

- (void)presentPeriodOfYearsSelectorFromController:(UIViewController *)controller {
    TWPeriodOfYearsPickerDataSource *pickerDataSource = [TWPeriodOfYearsPickerDataSource new];
    pickerDataSource.minYear = 1970;
    pickerDataSource.dateFrom = self.parametr.dateFrom;
    pickerDataSource.dateTo = self.parametr.dateTo;
    pickerDataSource.unclosedPeriod = YES;
    TWCustomPickerBottomSheetController *sheet = [TWCustomPickerBottomSheetController customPickerControllerWithDataSource:pickerDataSource];
    sheet.title = self.parametr.desc;
    
    __weak typeof(sheet) __weakSheet = sheet;
    sheet.customPickerHandler = ^(BOOL cancel, TWPeriodOfYearsPickerDataSource * _Nullable data) {
        
        if (cancel) {
            //NSLog(@"cancel");
        } else {
            self.parametr.dateFrom = data.dateFrom;
            self.parametr.dateTo = data.dateTo;
            self.parametr.value = @[self.parametr.dateFrom, self.parametr.dateTo? :[NSNull null]];
        }
        
        [__weakSheet dismissViewControllerAnimated:YES completion:nil];
    };
    [controller presentViewController:sheet animated:YES completion:nil];
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
