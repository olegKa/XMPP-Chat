//
//  TWDatePickerBottomSheetController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWDatePickerBottomSheetController.h"

#define TAG_LEFT    1
#define TAG_CENTER  2
#define TAG_RIGHT   3

@interface TWDatePickerBottomSheetController () <TWDatePickerViewDelegate>
{
    NSDate *_dateFrom;
    NSDate *_dateTo;
    TWDatePickerViewController *_picker;
}
@property (nonatomic, assign) TWDatePickerStage stage;

@end


@implementation TWDatePickerBottomSheetController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    TWDatePickerViewController *picker = [[TWDatePickerViewController alloc] initWithNibName:@"TWDatePickerViewController" bundle:nil];
    
    self = [super initWithContentViewController:picker];
    if (self) {
        _picker = picker;
        _picker.delegate = self;
        self.preferredContentSize = _picker.prefferedSize;
    }
    return self;
}

+ (TWDatePickerBottomSheetController *)datePickerController {
    TWDatePickerBottomSheetController *controller = [[TWDatePickerBottomSheetController alloc] initWithNibName:nil bundle:nil];
    return controller;
}

- (void)setMode:(TWDatePickerMode)mode {
    _mode = mode;
    
    switch (_mode) {
            case kDatePickerModeDate:{
                self.stage = kDatePickerStageUnknown;
            }
            break;
            case kDatePickerModePeriod: {
                self.stage = kDatePickerStageDateFrom;
            }
            break;
        default:
            break;
    }
}

- (void)setStage:(TWDatePickerStage)stage {
    _stage = stage;
    if ([self.dataSource respondsToSelector:@selector(datePickerController:dateForStage:)]) {
        _picker.picker.date = [self.dataSource datePickerController:self dateForStage:_stage]? :NSDate.date;
    }
    
    switch (_stage) {
            case kDatePickerStageUnknown: {
                _picker.buttonLeft.title = @"Cancel";
                _picker.buttonCenter.title = @"Today";
                _picker.buttonRight.title = @"Done";
                _dateFrom = _dateFrom? : _picker.picker.date;
            }
            break;
            
            case kDatePickerStageDateFrom: {
                _picker.buttonLeft.title = @"Cancel";
                _picker.buttonCenter.title = @"Start date";
                _picker.buttonRight.title = @"Next";
                _picker.picker.minimumDate = nil;
                _dateFrom = _dateFrom? : _picker.picker.date;
            }
            break;
            
            case kDatePickerStageDateTo: {
                _picker.buttonLeft.title = @"Back";
                _picker.buttonCenter.title = @"End date";
                _picker.buttonRight.title = @"Done";
                _picker.picker.minimumDate = _dateFrom;
                _dateTo = _dateTo? :_picker.picker.date;
            }
            break;
        default:
            break;
    }
}

- (void)setDateFormat:(NSString *)dateFormat {
    
    _dateFormat = dateFormat;
    
    UIDatePickerMode datePickerMode = UIDatePickerModeDate;
    
    if (([dateFormat containsString:@"H"] || [dateFormat containsString:@"h"]) && [dateFormat containsString:@"d"]) {
        datePickerMode = UIDatePickerModeDateAndTime;
    } else if ([dateFormat containsString:@"d"]) {
        datePickerMode = UIDatePickerModeDate;
    } else if ([dateFormat containsString:@"H"] || [dateFormat containsString:@"h"]) {
        datePickerMode = UIDatePickerModeTime;
    }
    
    _picker.picker.datePickerMode = datePickerMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _picker.buttonLeft.tag = TAG_LEFT;
    _picker.buttonCenter.tag = TAG_CENTER;
    _picker.buttonRight.tag = TAG_RIGHT;
                               
    [self setMode:_mode];
    [self setDateFormat:_dateFormat];
}

- (void)gotoStage:(TWDatePickerStage)stage {
    self.stage = stage;
}

#pragma mark - TWDatePickerViewDelegate -
- (void)didChangeDatePickerViewController:(TWDatePickerViewController *)picker {
    switch (_mode) {
            case kDatePickerModeDate:
            _dateFrom = picker.picker.date;
            break;
            case kDatePickerModePeriod: {
                switch (_stage) {
                        case kDatePickerStageDateFrom: {
                            _dateFrom = picker.picker.date;
                        }
                            break;
                        case kDatePickerStageDateTo: {
                            _dateTo = picker.picker.date;
                        }
                            break;
                    default:
                        break;
                }
            }
            break;
        default:
            break;
    }
}

- (void)datePickerViewController:(TWDatePickerViewController *)picker didPressBarButtonItem:(UIBarButtonItem *)button {
    
    switch (button.tag) {
            case TAG_LEFT: {
                if (_stage == kDatePickerStageDateTo) {
                    self.stage = kDatePickerStageDateFrom;
                    if (_dateFrom) {
                        [_picker.picker setDate:_dateFrom animated:YES];
                    }
                } else {
                    [self processCancel];
                }
            }
            break;
            
            case TAG_RIGHT: {
                if (_stage == kDatePickerStageDateFrom) {
                    self.stage = kDatePickerStageDateTo;
                } else {
                    [self processDone];
                }
            }
            break;
            
            case TAG_CENTER: {
                if (_stage == kDatePickerStageUnknown) {
                    _dateFrom = picker.picker.date = NSDate.date;
                }
            }
            break;
        default:
            break;
    }
}

- (void)processDone {
    if (_datePickerHandler) {
        if (_mode == kDatePickerModeDate) {
            _datePickerHandler(NO, @[_dateFrom]);
        } else {
            _datePickerHandler(NO, [NSArray arrayWithObjects:_dateFrom, _dateTo, nil]);
        }
    }
}

- (void)processCancel {
    if (_datePickerHandler) {
        _datePickerHandler(YES, nil);
    }
}

@end
