//
//  TWMessageView.h
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMessagesView.h"
#import "HPGrowingTextView.h"
#import "TWChatBotAction.h"

#import "XMPPRoomMessageCoreDataStorageObject+TWChat.h"


NS_ASSUME_NONNULL_BEGIN

@interface TWMessagesView : RCMessagesView

@property (weak, nonatomic) IBOutlet HPGrowingTextView *gTextInput;
@property (strong, nonatomic) NSArray <TWChatBotAction *> *actions;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;

@end

NS_ASSUME_NONNULL_END
