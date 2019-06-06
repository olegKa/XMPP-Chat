//
//  TWPeriodYMPickerDataSource.m
//  XMPPTest
//
//  Created by OLEG KALININ on 06.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWPeriodYMPickerDataSource.h"
#import "NSDate+Escort.h"

#define MONTH_FROM 0
#define YEAR_FROM 1

#define DIV 2

#define MONTH_TO 3
#define YEAR_TO 4

#define INIT_YEAR 1900

@interface TWPeriodYMPickerDataSource ()
{
    NSDateFormatter *_sericeDateFormatter;
    NSInteger _intDateFrom;
    NSInteger _intDateTo;
}

@end

@implementation TWPeriodYMPickerDataSource

- (instancetype)init {
    if (self = [super init]) {
        _minYear = INIT_YEAR;
        _sericeDateFormatter = [NSDateFormatter new];
        _sericeDateFormatter.dateFormat = @"yyyyMM-dd";
        self.dateFrom = NSDate.date;
        self.dateTo = NSDate.date;
        self.maximumDate = NSDate.date;
        
    }
    return self;
}

- (void)configureInitialsForPicker:(UIPickerView *)picker {
    
    if (self.dateFrom && self.dateTo) {
        [self pickerView:picker selectPeriodFrom:self.dateFrom to:self.dateTo animated:NO];
    } else if (self.dateFrom) {
        [self pickerView:picker selectPeriodFrom:self.dateTo to:NSDate.date animated:NO];
    } else if (self.dateTo) {
        [self pickerView:picker selectPeriodFrom:self.dateTo to:self.dateTo animated:NO];
    } else {
        [self pickerView:picker selectPeriodFrom:NSDate.date to:NSDate.date animated:NO];
    }
}

- (void)setDateFrom:(NSDate *)dateFrom {
    if (dateFrom) {
        _intDateFrom = dateFrom.year * 100 + dateFrom.month;
    }
}

- (void)setDateTo:(NSDate *)dateTo {
    if (dateTo) {
        _intDateTo = dateTo.year * 100 + dateTo.month;
    }
}

- (NSDate *)dateFrom {
    NSDate *ret = [_sericeDateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@", @(_intDateFrom), @"01"]];
    return ret;
}

- (NSDate *)dateTo {
    NSDate *ret = [_sericeDateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@", @(_intDateTo), @"01"]];
    return ret;
}

#pragma mark - UIPickerViewDataSource -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case YEAR_FROM:
        case YEAR_TO:
            return 300;
        case MONTH_FROM:
        case MONTH_TO:
            return 12 * 30;
        case DIV:
            return 1;
        default:
            break;
    }
    return 0;
}


#pragma mark - UIPickerViewDelegate -
/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         pickerView.bounds.size.width / 5,
                                                         [pickerView rowSizeForComponent:component].height)];
    v.backgroundColor = UIColor.clearColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               v.frame.size.width,
                                                               v.frame.size.height)];
    
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:21 weight:UIFontWeightRegular];
    //[UIView animateWithDuration:0.3 animations:^{
    //    BOOL isCurrentRow = [pickerView selectedRowInComponent:component] == row;
    //    label.font = [UIFont systemFontOfSize:(isCurrentRow? 23:20) weight:(isCurrentRow? UIFontWeightRegular:UIFontWeightThin)];
    //}];
 
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isCurrentRow = [pickerView selectedRowInComponent:component] == row;
        label.font = [UIFont systemFontOfSize:(isCurrentRow? 23:20) weight:(isCurrentRow? UIFontWeightRegular:UIFontWeightThin)];
        [pickerView reloadComponent:component];
    });
 
    
    [v addSubview:label];
    return v;
}
*/

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case YEAR_FROM:
        case YEAR_TO:
            return [NSString stringWithFormat:@"%@", @(_minYear + row)];;
        case MONTH_FROM:
        case MONTH_TO: {
            NSDateFormatter *df = NSDateFormatter.new;
            //df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
            return [[[df shortMonthSymbols] objectAtIndex:(row % 12)] substringToIndex:3];
        }
            
        default:
            break;
    }
    return @"—";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger curDateFrom = [self yearForRow:[pickerView selectedRowInComponent:YEAR_FROM]] * 100 + [self monthForRow:[pickerView selectedRowInComponent:MONTH_FROM]];
    NSInteger curDateTo = [self yearForRow:[pickerView selectedRowInComponent:YEAR_TO]] * 100 + [self monthForRow:[pickerView selectedRowInComponent:MONTH_TO]];
   
    if (curDateTo > _maximumDate.year * 100 + _maximumDate.month) {
        // Если переехал максимальную дату
        [self pickerView:pickerView selectPeriodFrom:self.dateFrom to:_maximumDate animated:YES];
        _intDateTo = _maximumDate.year * 100 + _maximumDate.month;
        return;
    }
    
    if (curDateFrom > curDateTo) {
        if (component == YEAR_FROM || component == MONTH_FROM) {
            // Если дата начала переехала дату конца
            [self pickerView:pickerView selectPeriodFrom:self.dateFrom to:self.dateTo animated:YES];
            _intDateFrom = self.dateTo.year * 100 + self.dateTo.month;
        } else {
            // Если дата конча перехала дату начала
            [self pickerView:pickerView selectPeriodFrom:self.dateFrom to:self.dateFrom animated:YES];
            _intDateTo = self.dateFrom.year * 100 + self.dateFrom.month;
        }
        return;
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
        [pickerView selectRow:[self rowOfMonth:dateFrom.month] inComponent:MONTH_FROM animated:animated];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [pickerView selectRow:[self rowOfYear:dateTo.year] inComponent:YEAR_TO animated:animated];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [pickerView selectRow:[self rowOfMonth:dateTo.month] inComponent:MONTH_TO animated:animated];
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
