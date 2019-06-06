//
//  TWMonthAndYearPickerDataSource.m
//  XMPPTest
//
//  Created by OLEG KALININ on 06.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWMonthAndYearPickerDataSource.h"
#import "NSDate+Escort.h"

#define YEAR 2
#define MONTH 0
#define DIV 1
#define INIT_YEAR 1900



@implementation TWMonthAndYearPickerDataSource

- (instancetype)init {
    if (self = [super init]) {
        _minYear = INIT_YEAR;
        //_maxYear = NSDate.date.year;
    }
    return self;
}

- (void)configureInitialsForPicker:(UIPickerView *)picker {
    
        if (_date) {
           [self pickerView:picker selectDate:_date animated:YES];
        }
}

#pragma mark - UIPickerViewDataSource -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case YEAR:
            return 300; //(_maxYear - _minYear + 1) * 3;
        case MONTH:
            return 12 * 30;
        default:
            break;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate -
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         pickerView.bounds.size.width / 2,
                                                         [pickerView rowSizeForComponent:component].height)];
    v.backgroundColor = UIColor.clearColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(component == YEAR? 0:0,
                                                               0,
                                                               v.frame.size.width,
                                                               v.frame.size.height)];
    
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.font = [UIFont systemFontOfSize:19 weight:UIFontWeightThin];
    label.textAlignment = component == YEAR? NSTextAlignmentLeft : NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    [v addSubview:label];
    return v;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case YEAR:
            return [NSString stringWithFormat:@"%@", @(_minYear + row)];;
        case MONTH: {
            NSDateFormatter *df = NSDateFormatter.new;
            return [[df monthSymbols] objectAtIndex:(row%12)];
        }
            
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger curDate = [self yearForRow:[pickerView selectedRowInComponent:YEAR]] * 100 + [self monthForRow:[pickerView selectedRowInComponent:MONTH]];
    if (curDate > _maximumDate.year * 100 + _maximumDate.month) {
        [self pickerView:pickerView selectDate:_maximumDate animated:YES];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView selectDate:(NSDate *)date animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [pickerView selectRow:[self rowOfYear:date.year] inComponent:YEAR animated:animated];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [pickerView selectRow:[self rowOfMonth:date.month] inComponent:MONTH animated:animated];
    });
}

- (NSInteger)rowOfYear:(NSInteger)year {
    return year - _minYear;
}

- (NSInteger)yearForRow:(NSInteger)row {
    return _minYear + row;
}

- (NSInteger)rowOfMonth:(NSInteger)month {
    return month + 12*15 - 1;
}

- (NSInteger)monthForRow:(NSInteger)row {
    NSInteger month = (row + 1) % 12 ? :12;
    return month;
}

@end
