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

static NSString* kServer = @"juragv.fvds.ru";

@class TWXMPPProvider;

typedef NS_ENUM(NSInteger, XMPPChatState) {
    kChatStateUnknown = 0,
    kChatStateComposing,
    kChatStatePaused,
    kChatStateActive,
    kChatStateInactive,
    kChatStateGone
};

@protocol XMPPChatStateDelegate <NSObject>

@optional
- (void)xmppProvider:(TWXMPPProvider *)provider didChangeState:(XMPPChatState)state room:(XMPPRoom *)room occupant:(XMPPJID *)occupant;
- (void)xmppProvider:(TWXMPPProvider *)provider didJoinToRoom:(XMPPRoom *)room;
- (void)xmppProvider:(TWXMPPProvider *)provider occupantDidJoin:(XMPPJID *)occupantJID;
- (void)xmppProvider:(TWXMPPProvider *)provider occupantDidLeave:(XMPPJID *)occupantJID;
- (void)xmppProvider:(TWXMPPProvider *)provider didChangeOccupantSet:(NSSet<XMPPJID *> *)occupants;
- (void)didLeaveRoomXmppProvider:(TWXMPPProvider *)provider;


@end

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

@property (nonatomic, readonly) XMPPJID *bot;
@property (nonatomic, readonly) XMPPJID *operator;
@property (nonatomic, readonly) NSSet<XMPPJID *> *users;

@property (nonatomic, weak) id <XMPPChatStateDelegate> chatStateDelegate;

+ (instancetype)shared;
- (BOOL)connect;
- (void)disconnect;
- (void)teardownStream;
- (void)resetRoomWithCompletion:(void (^)(BOOL success))completion;
- (void)sendPresenceShow:(NSString *)show;


- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *)managedObjectContext_room;
- (NSManagedObjectContext *)managedObjectContext_vCard;

- (void)getAllRegisteredUsers;

- (XMPPvCardTemp *)vCardTempWithJID:(XMPPJID *)jid;
- (XMPPvCardTemp *)vCardTempSenderOfMessage:(XMPPRoomMessageCoreDataStorageObject *)roomMessage;
- (XMPPvCardTemp *)vCardTempWithOccupantJID:(XMPPJID *)occupantJID;

@end

#define chat [TWXMPPProvider shared]
