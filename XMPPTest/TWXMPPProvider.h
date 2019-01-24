//
//  TWXMPPProvider.h
//  XMPPTest
//
//  Created by OLEG KALININ on 22.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <XMPPFramework/XMPPFramework.h>

static NSString* kUserLoginKey = @"kUserLoginKey";
static NSString* kUserPasswordKey = @"kUserPasswordKey";
static NSString* kUserRoomKey = @"kUserRoomKey";

@interface TWXMPPProvider : NSObject <XMPPRosterDelegate, XMPPRoomDelegate, XMPPMUCDelegate, XMPPvCardTempModuleDelegate, XMPPvCardAvatarDelegate>

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong, readonly) XMPPRoom *xmppRoom;
@property (nonatomic, strong, readonly) XMPPRoomCoreDataStorage *xmppRoomStorage;

@property (nonatomic, strong, readonly) XMPPvCardTemp *vCard;

+ (instancetype)shared;
- (BOOL)connect;
- (void)disconnect;
- (void)teardownStream;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *)managedObjectContext_room;
- (NSManagedObjectContext *)managedObjectContext_vCard;

- (void)getAllRegisteredUsers;

@end

#define chat [TWXMPPProvider shared]
