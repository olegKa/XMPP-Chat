//
//  TWChatUserDataCell.h
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWChatBotFunction.h"

@class TWChatUserDataCell;

@protocol TWChatUserDataCellProtocol

@required
- (void)didSelectCellWithViewController:(UIViewController *)controller;

@end

@interface TWChatUserDataCell : UITableViewCell <TWChatUserDataCellProtocol>

@property (nonatomic, strong) TWChatBotFunctionParam *param;

@end
