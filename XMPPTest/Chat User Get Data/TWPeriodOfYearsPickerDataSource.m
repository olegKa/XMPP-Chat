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

@interface TWPeriodOfYearsPickerDataSource ()
{
    NSDateFormatter *_serviceDateFormatter;
    NSInteger _intDateFrom;
    NSInteger _intDateTo;
}

@end

@implementation TWPeriodOfYearsPickerDataSource

- (instancetype)init {
    if (self = [super init]) {
        _minYear = INIT_YEAR;
        self.maximumDate = NSDate.date;
        self.dateFrom = NSDate.date;
        self.dateTo = NSDate.date;
        
        _serviceDateFormatter = [NSDateFormatter new];
        _serviceDateFormatter.dateFormat = @"yyyy-mm-dd";
        
    }
    return self;
}

- (void)setDateFrom:(NSDate *)dateFrom {
    if (dateFrom) {
        _intDateFrom = dateFrom.year;
    }
}

- (NSDate *)dateFrom {
    return [_serviceDateFormatter dateFromString:[NSString stringWithFormat:@"%li-01-01", (long)_intDateFrom]];
}

- (NSDate *)dateTo {
    return [_serviceDateFormatter dateFromString:[NSString stringWithFormat:@"%li-01-01", (long)_intDateTo]];
}

- (void)setDateTo:(NSDate *)dateTo {
    if (dateTo) {
        _intDateTo = dateTo.year;
    }
}

- (void)configureInitialsForPicker:(UIPickerView *)picker {
    if (self.dateFrom && self.dateTo) {
        [self pickerView:picker selectPeriodFrom:self.dateFrom to:self.dateTo animated:NO];
    }
}

#pragma mark - UIPickerViewDataSource -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case YEAR_FROM:
            return 300;
        case YEAR_TO:
            return _unclosedPeriod? self.maximumDate.year - _minYear + 2 : 300;
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
            if (_unclosedPeriod && row == self.maximumDate.year - _minYear + 1) {
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

/*
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
*/

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case YEAR_FROM:
            return (pickerView.bounds.size.width - 50) / 2;
        case YEAR_TO:
            return (pickerView.bounds.size.width - 50) / 2;
        case DIV:
            return 50;
        default:
            break;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger curDateFrom = [self yearForRow:[pickerView selectedRowInComponent:YEAR_FROM] isTo:NO];
    NSInteger curDateTo = [self yearForRow:[pickerView selectedRowInComponent:YEAR_TO] isTo:YES];
    
    if (curDateTo == 0) {
        // незакрытый период
        if (curDateFrom > _maximumDate.year) {
            [self pickerView:pickerView selectPeriodFrom:_maximumDate to:nil animated:YES];
            _intDateFrom = _maximumDate.year;
            return;
        }
        
    } else {
        // закрытый период
        if (curDateTo > _maximumDate.year) {
            [self pickerView:pickerView selectPeriodFrom:self.dateFrom to:_maximumDate animated:YES];
            _intDateTo = _maximumDate.year;
            return;
        }
        
        if (curDateFrom > curDateTo) {
            if (component == YEAR_FROM) {
                [self pickerView:pickerView selectPeriodFrom:self.dateFrom to:self.dateTo animated:YES];
                _intDateFrom = self.dateTo.year;
            } else {
                [self pickerView:pickerView selectPeriodFrom:self.dateFrom to:self.dateFrom animated:YES];
                _intDateTo = self.dateFrom.year;
            }
            return;
        }
    }
    
    _intDateFrom = curDateFrom;
    _intDateTo = curDateTo;
}

#pragma mark - Helpers -
- (void)pickerView:(UIPickerView *)pickerView selectPeriodFrom:(NSDate *)dateFrom to:(NSDate *)dateTo animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [pickerView selectRow:[self rowOfYear:dateFrom.year] inComponent:YEAR_FROM animated:animated];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [pickerView selectRow:[self rowOfYear:dateTo.year] inComponent:YEAR_TO animated:animated];
    });
    
}

- (NSInteger)rowOfYear:(NSInteger)year {
    return year? year - _minYear : self.maximumDate.year - _minYear + 1;
}

- (NSInteger)yearForRow:(NSInteger)row isTo:(BOOL)isTo {
    return (isTo && _unclosedPeriod && row == self.maximumDate.year - _minYear + 1)? 0 : _minYear + row;
}

@end
