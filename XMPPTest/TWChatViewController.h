//
//  TWChatViewController.h
//  XMPPTest
//
//  Created by OLEG KALININ on 23.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <RCMessageKit/RCMessagesView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWChatViewController : RCMessagesView

- (IBAction)actionInputSend:(id)sender;

@end

NS_ASSUME_NONNULL_END
