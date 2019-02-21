//
//  TWChatSettingsViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 24.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatSettingsViewController.h"
#import "TWChatAuthorizationViewController.h"

@interface TWChatSettingsViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet UIImageView *_imageAvatar;
    __weak IBOutlet UIButton *_buttonAvatar;
}
@end

@implementation TWChatSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (chat.vCard.photo) {
        _imageAvatar.image = [UIImage imageWithData:chat.vCard.photo];
    } else {
        _imageAvatar.image = [UIImage imageNamed:@"rcmessage_attach"];
    }
    
    
}

- (IBAction)buttonSave:(id)sender
{
    XMPPvCardTemp *vCard = chat.vCard? :[XMPPvCardTemp vCardTemp];
    vCard.title = @"programmer";
    [chat.xmppvCardTempModule updateMyvCardTemp:vCard];
}

- (IBAction)buttonAvatar:(id)sender
{
    UIAlertController* imageActionController = [UIAlertController alertControllerWithTitle:@"Add Photo"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionTakePhoto = [UIAlertAction actionWithTitle:@"Use camera"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                
                                                                UIImagePickerController* pickerController = [UIImagePickerController new];
                                                                pickerController.delegate = self;
                                                                pickerController.allowsEditing = YES;
                                                                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                
                                                                [self presentViewController:pickerController animated:YES completion:nil];
                                                            }];
    
    UIAlertAction* actionChoosePhoto = [UIAlertAction actionWithTitle:@"Select from library"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                                  UIImagePickerController* pickerController = [UIImagePickerController new];
                                                                  pickerController.delegate = self;
                                                                  pickerController.allowsEditing = YES;
                                                                  pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                  [self presentViewController:pickerController animated:YES completion:nil];
                                                              }];
    
    UIAlertAction* actionClearPhoto = [UIAlertAction actionWithTitle:@"CLEAR"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                 
                                                             }];
    [imageActionController addAction:actionTakePhoto];
    [imageActionController addAction:actionChoosePhoto];
    
    // Clear button is available only if image already picked
    if (chat.vCard.photo) {
        [imageActionController addAction:actionClearPhoto];
    }
    
    [imageActionController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:imageActionController animated:YES completion:nil];
}


#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *ava = info[UIImagePickerControllerEditedImage];
    ava = [self imageWithImage:ava scaledToSize:CGSizeMake(256, 256)];
    
    XMPPvCardTemp *vCard = chat.vCard? :[XMPPvCardTemp vCardTemp];
    //vCard.photo = [UIImagePNGRepresentation(ava) base64EncodedDataWithOptions:0];
    vCard.photo = UIImageJPEGRepresentation(ava, 0.5);
    [chat.xmppvCardTempModule updateMyvCardTemp:vCard];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueChatAuth"]) {
        TWChatAuthorizationViewController *vc = segue.destinationViewController;
        vc.didSaveBlock = ^(BOOL success) {
            if (success) {
                APP_DELEGATE.window.rootViewController = APP_DELEGATE.chatViewController;
                [APP_DELEGATE.window makeKeyAndVisible];
            }
        };
    }
}


@end
