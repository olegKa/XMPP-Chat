//
//  TWCustomPickerViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 28.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWCustomPickerViewController.h"
#import "TWCustomPickerDataSource.h"

@interface TWCustomPickerViewController ()

@end

@implementation TWCustomPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _picker.dataSource = _pickerDataSource;
    _picker.delegate = _pickerDataSource;
    [_pickerDataSource configureInitialsForPicker:_picker];
}

- (CGSize)prefferedSize {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 260);
}

- (void)setPickerDataSource:(TWCustomPickerDataSource<UIPickerViewDelegate,UIPickerViewDataSource> *)pickerDataSource {
    _pickerDataSource = pickerDataSource;
}

#pragma mark - User Actions
- (IBAction)barButtonItemPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(customPickerViewController:didPressBarButtonItem:)]) {
        [self.delegate customPickerViewController:self didPressBarButtonItem:sender];
    }
}

@end
