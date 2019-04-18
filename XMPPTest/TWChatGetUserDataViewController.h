//
//  TWGetUserDataViewController.h
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWChatBotFunction.h"

typedef void(^TWGetUserDataBlock)(BOOL success, TWChatBotFunction *function);

NS_ASSUME_NONNULL_BEGIN

@interface TWChatGetUserDataViewController : UITableViewController

@property (nonatomic, strong) TWChatBotFunction *function;
@property (nonatomic, copy) TWGetUserDataBlock getUserDataHandler;

+ (instancetype)chatGetUserDataViewControllerWithFunction:(TWChatBotFunction *)function;

@end

NS_ASSUME_NONNULL_END
