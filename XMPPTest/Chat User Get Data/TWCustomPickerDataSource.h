//
//  TWCustomPickerDelegate.h
//  XMPPTest
//
//  Created by OLEG KALININ on 05.06.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWCustomPickerDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

- (void)configureInitialsForPicker:(UIPickerView *)picker;

@end



NS_ASSUME_NONNULL_END
