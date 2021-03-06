//
//  AppDelegate.m
//  XMPPTest
//
//  Created by OLEG KALININ on 22.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "AppDelegate.h"
#import "TWXMPPProvider.h"
#import "TWChatAuthorizationViewController.h"
#import "TWChatViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Configure logging framework
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:XMPP_LOG_FLAG_SEND_RECV];
    
    // Setup and open the XMPP stream
    
    UINavigationController *rootViewController;
    
    if (![chat connect]) {
        rootViewController = [[UIStoryboard storyboardWithName:@"TWChatAuthorization" bundle:nil] instantiateInitialViewController];
        
        TWChatAuthorizationViewController *authViewController = rootViewController.viewControllers.firstObject;
        __weak typeof(self) __weakSelf = self;
        [authViewController setDidSaveBlock:^(BOOL success) {
            __weakSelf.window.rootViewController = [self chatViewController]; //[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
            [self.window makeKeyAndVisible];
        }];
    } else {
        rootViewController = [self chatViewController]; //[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    }
    
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UINavigationController *)chatViewController
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[TWChatViewController new]];
    //nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    return nav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)dealloc
{
    [chat teardownStream];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store
    // enough application state information to restore your application to its current state in case
    // it is terminated later.
    //
    // If your application supports background execution,
    // called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    [chat teardownStream];
}

#pragma mark - Properties



@end
