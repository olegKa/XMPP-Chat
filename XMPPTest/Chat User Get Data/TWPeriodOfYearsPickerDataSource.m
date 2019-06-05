//
//  TWPeriodOfYearsPickerDataSource.m
//  XMPPTest
//
//  Created by OLEG KALININ on 05.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWPeriodOfYearsPickerDataSource.h"
#import "NSDate+Escort.h"

#define YEAR_FROM 0
#define YEAR_TO 2
#define DIV 1
#define INIT_YEAR 1900

@implementation TWPeriodOfYearsPickerDataSource

- (instancetype)init {
    if (self = [super init]) {
        _minYear = INIT_YEAR;
        _maxYear = NSDate.date.year;
    }
    return self;
}

- (void)configureInitialsForPicker:(UIPickerView *)picker {
    if (_yearStart) {
        [picker selectRow:_yearStart - _minYear inComponent:YEAR_FROM animated:NO];
    }
    
    if (_yearEnd) {
        [picker selectRow:_yearEnd - _minYear inComponent:YEAR_TO animated:NO];
    }
}

#pragma mark - UIPickerViewDataSource -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case YEAR_FROM:
            return _maxYear - _minYear + 1;
        case YEAR_TO:
            return _maxYear - _minYear + (_unclosedPeriod? 2:1);
        case DIV:
            return 1;
        default:
            break;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate -
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case YEAR_FROM:
            return [NSString stringWithFormat:@"%@", @(_minYear + row)];
        case YEAR_TO: {
            if (_unclosedPeriod && row == _maxYear - _minYear + 1) {
                return @" … ";
            } else {
                return [NSString stringWithFormat:@"%@", @(_minYear + row)];
            }
        }
        default:
            break;
    }
    
    return @"—\t";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         [self pickerView:pickerView widthForComponent:component],
                                                         [pickerView rowSizeForComponent:component].height)];
    v.backgroundColor = UIColor.clearColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(component == YEAR_TO? -20:0,
                                                               0,
                                                               v.frame.size.width,
                                                               v.frame.size.height)];
    
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.font = [UIFont systemFontOfSize:19 weight:UIFontWeightThin];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [v addSubview:label];
    return v;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case YEAR_FROM:
            return (pickerView.bounds.size.width - 30) / 2;
        case YEAR_TO:
            return (pickerView.bounds.size.width - 30) / 2;
        case DIV:
            return 50;
        default:
            break;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == YEAR_FROM) {
        _yearStart = _minYear + row;
        if (row > [pickerView selectedRowInComponent:2]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [pickerView selectRow:row inComponent:2 animated:YES];
            });
        }
    } else if (component == YEAR_TO) {
        
        if (_unclosedPeriod && row == _maxYear - _minYear + 1) {
            _yearEnd = 0;
        } else {
            _yearEnd = _minYear + row;
        }
        
        if (row < [pickerView selectedRowInComponent:0]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [pickerView selectRow:row inComponent:0 animated:YES];
            });
        }
    }
}

@end
