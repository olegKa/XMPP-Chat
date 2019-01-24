//
//  UIAlertController+AlertShow.h
//  TWIB
//
//  Created by Grin Vladimir on 27/05/2018.
//  Copyright © 2018 Unreal Mojo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertController (AlertShow)

// Alert View Controller Helpers
+(UIAlertController *)alertWithError:(NSError  * _Nonnull)error;

+(UIAlertController *)alertWithTitle:(NSString * _Nullable)title andMessage:(NSString * _Nullable)message;

+(UIAlertController *)alertWithTitle:(NSString * _Nullable)title
                          andMessage:(NSString * _Nullable)message
                          completion:(void(^ _Nullable)(UIAlertAction * _Nonnull action))completion;

+(UIAlertController *)alertWithTitle:(NSString * _Nullable)title
                          andMessage:(NSString * _Nullable)message
                         actionTitle:(NSString * _Nullable)actionTitle
                          completion:(void(^ _Nullable)(UIAlertAction * _Nonnull action))completion;

+(UIAlertController *)alertWithActionsAndTitle:(NSString * _Nullable)title
                          andMessage:(NSString * _Nullable)message
                         alertActions:(UIAlertAction * _Nullable)actions, ... NS_REQUIRES_NIL_TERMINATION;

+(UIAlertController *)alertWithActionsAndTitle:(NSString * _Nullable)title
                                    andMessage:(NSString * _Nullable)message
                             arrayAlertActions:(NSArray<UIAlertAction *> * _Nonnull)actions;

+(UIAlertController *)alertWithCancelAndTitle:(NSString * _Nullable)title
                                      message:(NSString * _Nullable)message
                                  actionTitle:(NSString * _Nullable)actionTitle
                                actionHandler:(void(^ _Nullable)(UIAlertAction * _Nonnull action))handler;

+(UIAlertController *)actionSheetWithCancelAndTitle:(NSString * _Nullable)title
                                            message:(NSString * _Nullable)message
                                        actionTitle:(NSString * _Nullable)actionTitle
                                      actionHandler:(void(^ _Nullable)(UIAlertAction * _Nonnull action))action
                                      cancelHandler:(void(^ _Nullable)(UIAlertAction * _Nonnull action))cancel;

+(UIAlertController *)showNotification:(NSString *)title;

/**
 <#Description#>
 
 @param initialInput <#initialInput description#>
 @param title <#title description#>
 @param message <#message description#>
 @param completion <#completion description#>
 */
+(UIAlertController *)alertWithInputInitial:(NSString * _Nullable)initialInput
                                      title:(NSString * _Nullable)title
                                    message:(NSString * _Nullable)message
                                placeholder:(NSString * _Nullable)placeholder
                                 completion:(void (^ _Nullable)(BOOL cancel, NSString * _Nullable inputString))completion;

-(void)show;
-(void)show:(BOOL)animated;
-(void)show:(BOOL)animated completion:(void (^ __nullable)(void))completion;

-(void)showDelay:(NSTimeInterval)delay;

@end
