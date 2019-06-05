//
//  TWCustomPickerViewController.h
//  XMPPTest
//
//  Created by OLEG KALININ on 28.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWCustomPickerDataSource;
@protocol TWCustomPickerViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface TWCustomPickerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonLeft;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonRight;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonCenter;
@property (nonatomic, weak) IBOutlet UIPickerView *picker;

@property (nonatomic, readonly) CGSize prefferedSize;
@property (nonatomic, strong) TWCustomPickerDataSource <UIPickerViewDelegate, UIPickerViewDataSource> *pickerDataSource;
@property (nonatomic, weak) id <TWCustomPickerViewDelegate> delegate;

@end

@protocol TWCustomPickerViewDelegate <NSObject>

@optional
- (void)customPickerViewController:(TWCustomPickerViewController *)picker didPressBarButtonItem:(UIBarButtonItem *)button;
- (void)didChangeCustomPickerViewController:(TWCustomPickerViewController *)picker;


@end

NS_ASSUME_NONNULL_END
