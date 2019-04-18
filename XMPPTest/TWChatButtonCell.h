//
//  TWChatButtonCell.h
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatUserDataCell.h"

typedef void(^TWChatButtonCellBlock)(id sender);

NS_ASSUME_NONNULL_BEGIN

@interface TWChatButtonCell : TWChatUserDataCell

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) TWChatButtonCellBlock buttonHandler;

@end

NS_ASSUME_NONNULL_END
