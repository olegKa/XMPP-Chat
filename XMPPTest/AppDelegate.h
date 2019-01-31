//
//  AppDelegate.h
//  XMPPTest
//
//  Created by OLEG KALININ on 22.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <TWSIPFramework/TWSipProvider.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) TWSipProvider *sip;

@end

