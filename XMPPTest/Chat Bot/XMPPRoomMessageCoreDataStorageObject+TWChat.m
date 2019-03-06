//
//  XMPPRoomMessageCoreDataStorageObject+TWChat.m
//  XMPPTest
//
//  Created by OLEG KALININ on 04.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "XMPPRoomMessageCoreDataStorageObject+TWChat.h"

@implementation XMPPRoomMessageCoreDataStorageObject (TWChat)

- (NSString *)elementID
{
    return self.message.elementID? : self.objectID.URIRepresentation.absoluteString;
}

@end
