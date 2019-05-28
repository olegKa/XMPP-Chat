//
//  TWDatePickerViewController.h
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWDatePickerViewDelegate;

@interface TWDatePickerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonLeft;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonRight;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonCenter;
@property (nonatomic, weak) IBOutlet UIDatePicker *picker;

@property (nonatomic, readonly) CGSize prefferedSize;
@property (nonatomic, weak) id <TWDatePickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

@protocol TWDatePickerViewDelegate <NSObject>

@optional
- (void)datePickerViewController:(TWDatePickerViewController *)picker didPressBarButtonItem:(UIBarButtonItem *)button;
- (void)didChangeDatePickerViewController:(TWDatePickerViewController *)picker;


@end
