//
//  TWImageViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 13.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWImageViewController.h"

@interface TWImageViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation TWImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = _image;
}

- (void)setImage:(UIImage *)image
{
    _image = image.copy;
    self.imageView.image = _image;
}

- (IBAction)buttonClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
