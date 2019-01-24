//
//  TWChatMessageCell.h
//  XMPPTest
//
//  Created by OLEG KALININ on 22.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWChatMessageCell : UITableViewCell

@property (nonatomic, weak) XMPPMessage *message;

@end

NS_ASSUME_NONNULL_END
