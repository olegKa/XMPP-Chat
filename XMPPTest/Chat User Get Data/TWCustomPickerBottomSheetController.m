//
//  TWCustomPickerBottomSheetController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 05.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWCustomPickerBottomSheetController.h"
#import "TWCustomPickerViewController.h"

#define TAG_LEFT    1
#define TAG_CENTER  2
#define TAG_RIGHT   3

@interface TWCustomPickerBottomSheetController () <TWCustomPickerViewDelegate>
{
    TWCustomPickerViewController *_picker;
}
@end

@implementation TWCustomPickerBottomSheetController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    TWCustomPickerViewController *picker = [[TWCustomPickerViewController alloc] initWithNibName:@"TWCustomPickerViewController" bundle:nil];
    
    self = [super initWithContentViewController:picker];
    if (self) {
        _picker = picker;
        _picker.delegate = self;
        
        self.preferredContentSize = _picker.prefferedSize;
    }
    return self;
}

+ (instancetype)customPickerControllerWithDataSource:(TWCustomPickerDataSource *)dataSource {
    
    TWCustomPickerBottomSheetController *controller = [[TWCustomPickerBottomSheetController alloc] initWithNibName:nil bundle:nil];
    controller->_picker.pickerDataSource = dataSource;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _picker.buttonLeft.tag = TAG_LEFT;
    _picker.buttonCenter.tag = TAG_CENTER;
    _picker.buttonRight.tag = TAG_RIGHT;
    _picker.buttonCenter.title = self.title;
}

#pragma mark - TWCustomPickerViewDelegate -
- (void)customPickerViewController:(TWCustomPickerViewController *)picker didPressBarButtonItem:(UIBarButtonItem *)button {
    switch (button.tag) {
        case TAG_LEFT: {
            if (_customPickerHandler) {
                _customPickerHandler(YES, nil);
            }
            break;
            
        case TAG_RIGHT: {
            if (_customPickerHandler) {
                _customPickerHandler(NO, picker.pickerDataSource);
            }
        }
            break;
            
        case TAG_CENTER: {
            
        }
            break;
        default:
            break;
        }
    }
}


@end
