//
//  UIAlertController+AlertShow.m
//  TWIB
//
//  Created by Grin Vladimir on 27/05/2018.
//  Copyright © 2018 Unreal Mojo. All rights reserved.
//

#import "UIAlertController+AlertShow.h"
#import <objc/runtime.h>

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIAlertController (Private)

@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end

@implementation UIAlertController (AlertShow)

#pragma mark Alert View Controller Helpers -

+(UIAlertController *)alertWithTitle:(NSString * _Nullable)title andMessage:(NSString * _Nullable)message actionTitle:(NSString * _Nullable)actionTitle completion:(void(^ _Nullable)(UIAlertAction * _Nonnull action))completion {
    UIAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:completion];
    [alert addAction:actAction];
    //    alert.view.tintColor = [[TWStock shared] tintColor];

    return alert;
}

+(UIAlertController *)alertWithTitle:(NSString * _Nullable)title andMessage:(NSString * _Nullable)message completion:(void(^ _Nullable)(UIAlertAction * _Nonnull action))completion {
    UIAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actClose = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:completion];
    [alert addAction:actClose];

    return alert;
}

+(UIAlertController *)alertWithTitle:(NSString *)title andMessage:(NSString *)message {
    return [self alertWithTitle:title andMessage:message completion:nil];
}

+(UIAlertController *)alertWithError:(NSError *)error {
    return [self alertWithTitle:@"ERROR" andMessage:error.userInfo[NSLocalizedDescriptionKey]];
}

+(UIAlertController *)alertWithCancelAndTitle:(NSString * _Nullable)title
                                      message:(NSString * _Nullable)message
                                  actionTitle:(NSString * _Nullable)actionTitle
                                actionHandler:(void(^ _Nullable)(UIAlertAction * _Nonnull action))handler {
    
    UIAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler];
    
    UIAlertAction *actCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:actCancel];
    [alert addAction:actAction];
    
    return alert;
}

+(UIAlertController *)actionSheetWithCancelAndTitle:(NSString * _Nullable)title
                                            message:(NSString * _Nullable)message
                                        actionTitle:(NSString * _Nullable)actionTitle
                                      actionHandler:(void(^ _Nullable)(UIAlertAction * _Nonnull action))action
                                      cancelHandler:(void(^ _Nullable)(UIAlertAction * _Nonnull action))cancel {
    
    UIAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:action];
    
    UIAlertAction *actCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:cancel];
    
    [alert addAction:actCancel];
    [alert addAction:actAction];
    
    return alert;
}

+(UIAlertController *)alertWithActionsAndTitle:(NSString * _Nullable)title
                           andMessage:(NSString * _Nullable)message
                          alertActions:(UIAlertAction * _Nullable)actions, ... {

    UIAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    va_list arglist;
    va_start(arglist, actions);
    
    UIAlertAction* action = actions;
    while (action != nil) {
        [alert addAction:action];    // Add UIAlertAction
        action = va_arg(arglist, id);
    }
    va_end(arglist);

    return alert;
}

+(UIAlertController *)alertWithActionsAndTitle:(NSString * _Nullable)title
                                    andMessage:(NSString * _Nullable)message
                                  arrayAlertActions:(NSArray<UIAlertAction *> * _Nonnull)actions {
    
    UIAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction *action in actions) {
        [alert addAction:action];    // Add UIAlertAction
    }
    return alert;
}

+(UIAlertController *)alertWithInputInitial:(NSString *)initialInput
                                      title:(NSString *)title
                                    message:(NSString *)message
                                placeholder:(NSString * _Nullable)placeholder
                                 completion:(void (^)(BOOL cancel, NSString * _Nullable))completion
{
    
    UIAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) completion(NO, alert.textFields.firstObject.text);
    }];
    
    UIAlertAction *actCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        if(completion) completion(YES, alert.textFields.firstObject.text);
    }];
    
    [alert addAction:actCancel];
    [alert addAction:actAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = initialInput;
        textField.placeholder = placeholder;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        //textField.textColor = [[TWStock shared] textColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    return alert;
}

+(UIAlertController *)showNotification:(NSString *)title {
    
    return [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
}

#pragma mark show metods -

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    [self show:animated completion:nil];
}

-(void)show:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    
    id oldAlertController = [[[UIApplication sharedApplication].windows.lastObject rootViewController] presentedViewController];
    if ([oldAlertController isKindOfClass:[UIAlertController class]]) {
        [(UIAlertController *)oldAlertController dismissViewControllerAnimated:YES completion:^{
            [self _show:animated completion:completion];
        }];
    } else {
        [self _show:animated completion:completion];
    }
}

- (void)_show:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.alertWindow.rootViewController = [UIViewController new];
    self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:completion];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // precaution to insure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

-(void)showDelay:(NSTimeInterval)delay {
    [self show:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
};

@end
