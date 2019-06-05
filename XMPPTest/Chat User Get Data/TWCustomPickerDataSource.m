//
//  TWCustomPickerDelegate.m
//  XMPPTest
//
//  Created by OLEG KALININ on 05.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWCustomPickerDataSource.h"


@implementation TWCustomPickerDataSource

- (void)configureInitialsForPicker:(UIPickerView *)picker {
    
}

#pragma mark - UIPickerViewDataSource -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

@end
