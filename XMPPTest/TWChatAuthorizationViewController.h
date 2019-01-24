//
//  TWChatAuthorizationViewController.h
//  XMPPTest
//
//  Created by OLEG KALININ on 24.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TWChatSettingsDidSaveBlock) (BOOL success);

@interface TWChatAuthorizationViewController : UITableViewController

@property (nonatomic, copy) TWChatSettingsDidSaveBlock didSaveBlock;

@end

NS_ASSUME_NONNULL_END
