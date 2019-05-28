//
//  TWDatePickerViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 27.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWDatePickerViewController.h"

@interface TWDatePickerViewController ()

@end

@implementation TWDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (CGSize)prefferedSize {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 260);
}

#pragma mark - User Actions
- (IBAction)datePickerChange:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didChangeDatePickerViewController:)]) {
        [self.delegate didChangeDatePickerViewController:self];
    }
}

- (IBAction)barButtonItemPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerViewController:didPressBarButtonItem:)]) {
        [self.delegate datePickerViewController:self didPressBarButtonItem:sender];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
