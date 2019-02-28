//
//  TWChatAuthorizationViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 24.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatAuthorizationViewController.h"

@interface TWChatAuthorizationViewController () <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *_textLogin;
    __weak IBOutlet UITextField *_textPassword;
    __weak IBOutlet UIButton *_buttonSave;
}
@end

@implementation TWChatAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textLogin.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLoginKey]? :@"user123@185.246.65.33";
    [self validateInput];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_textLogin.text.length) {
        [_textLogin becomeFirstResponder];
    }
}

- (void)validateInput
{
    _buttonSave.enabled = _textPassword.text.length && _textLogin.text.length;
}

- (IBAction)buttonSave:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:_textLogin.text forKey:kUserLoginKey];
    [[NSUserDefaults standardUserDefaults] setObject:_textPassword.text forKey:kUserPasswordKey];
    [chat disconnect];
    
    if ([chat connect]) {
        BLOCK_SAFE_RUN(_didSaveBlock, YES);
    } else {
        BLOCK_SAFE_RUN(_didSaveBlock, NO);
    }
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self validateInput];
    return YES;
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
