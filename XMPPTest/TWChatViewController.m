//
//  TWChatViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 23.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatViewController.h"
#import "TWChatSettingsViewController.h"

#import "AppDelegate.h"

#import "TWMessage.h"
#import "TWChatTypingIndicator.h"
#import "NSDate+TWChat.h"

@interface TWChatViewController () <NSFetchedResultsControllerDelegate, XMPPChatStateDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    TWChatTypingIndicator *typingIndicatorView;
    NSArray <NSString *> *_firstMessageAtDay; // список из первых сообщений за каждый из дней (для группировки по датам)
    NSMutableArray <TWMessage *> *_messages;
    
    __weak IBOutlet UIBarButtonItem *_btnCall;
}
@end

@implementation TWChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messages = @[].mutableCopy;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(buttonSettings:)];
    
    self.navigationItem.rightBarButtonItem = btnSettings;
    
    typingIndicatorView = [TWChatTypingIndicator default];
    self.viewTypingIndicator = typingIndicatorView;
    chat.chatStateDelegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.actions = @[];
}

- (IBAction)buttonCall:(id)sender
{
    
}

- (IBAction)buttonSettings:(id)sender
{
    TWChatSettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"TWChatSettings" bundle:nil] instantiateViewControllerWithIdentifier:@"TWChatSettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)updateDates
{
    NSMutableDictionary *dates = @{}.mutableCopy;
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"dd MMMM yyyy";
    [fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(XMPPRoomMessageCoreDataStorageObject * _Nonnull msg, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *date = [df stringFromDate:msg.localTimestamp];
        if (![dates.allValues containsObject:date] && msg.message.elementID.length) {
            dates[msg.message.elementID] = date;
        }
    }];
    
    _firstMessageAtDay = dates.allKeys;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [chat managedObjectContext_room];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPRoomMessageCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"localTimestamp" ascending:YES];
        
        
        NSArray *sortDescriptors = @[sd1];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
        [fetchedResultsController setDelegate:self];
        
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            DDLogError(@"Error performing fetch: %@", error);
        }
        
    }
    
    return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateDates];
    [self.tableView endUpdates];
    [self scrollToBottom:YES];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.row] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            XMPPRoomMessageCoreDataStorageObject *obj = [controller objectAtIndexPath:newIndexPath];
            TWMessage *message = [[TWMessage alloc] initWithBody:obj.body incoming:![self isFromMeMessage:obj]];
            if (message.actions) {
                self.actions = message.actions.copy;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - XMPPChatStateDelegate
- (void)xmppProvider:(TWXMPPProvider *)provider didChangeState:(XMPPChatState)state room:(XMPPRoom *)room occupant:(XMPPJID *)occupant
{
    [self typingIndicatorShow:(state == kChatStateComposing) animated:YES];
    typingIndicatorView.text = [NSString stringWithFormat:@"%@ печатает...", occupant.resource];
}

#pragma mark - Message Processing
- (TWMessage *)rcmessage:(NSIndexPath *)indexPath
{
    //XMPPRoomMessageCoreDataStorageObject *obj = [self objectAtIndexPath:indexPath];
    
    TWMessage *msg = [self messageAtIndexPath:indexPath];
    
    /*
    TWMessage *msg = [[TWMessage alloc] initWithBody:obj.body incoming:!obj.isFromMe];
    msg.loadingHandle = ^{
        [self.tableView reloadData];
        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
     */
    return msg;
}

- (BOOL)isFromMeMessage:(XMPPRoomMessageCoreDataStorageObject *)message
{
    BOOL isFromMe = [message.jid.resource hasPrefix:chat.xmppStream.myJID.user];
    return isFromMe;
}

- (TWMessage *)messageAtIndexPath:(NSIndexPath *)indexPath
{
    TWMessage *message;
    XMPPRoomMessageCoreDataStorageObject *obj = [self objectAtIndexPath:indexPath];
    NSUInteger msgIdx = [_messages indexOfObjectPassingTest:^BOOL(TWMessage * _Nonnull msg, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([msg.elementID isEqualToString:obj.message.elementID]) {
            *stop = YES;
        }
        return *stop;
    }];
    
    if (msgIdx == NSNotFound) {
        message = [[TWMessage alloc] initWithBody:obj.body incoming:![self isFromMeMessage:obj]];
        message.elementID = obj.message.elementID;
        if (message.type == RC_TYPE_LOCATION) {
            message.loadingHandle = ^(TWMessage * _Nonnull message) {
                NSIndexPath *ip = [self indexPathOfMessage:message];
                if (ip) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ip.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            };
        }
        [_messages addObject:message];
    } else {
        message = _messages[msgIdx];
    }
    
    return message;
}

- (NSIndexPath *)indexPathOfMessage:(TWMessage *)message
{
    NSUInteger idx = [_messages indexOfObjectPassingTest:^BOOL(TWMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([message.elementID isEqualToString:obj.elementID]) {
            *stop = YES;
        }
        return *stop;
    }];
    
    if (idx == NSNotFound) {
        return nil;
    }
    
    return [NSIndexPath indexPathForRow:0 inSection:idx];
}

- (XMPPRoomMessageCoreDataStorageObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *realIndexPath = [NSIndexPath indexPathForRow:indexPath.section inSection:0];
    XMPPRoomMessageCoreDataStorageObject *obj = [[self fetchedResultsController] objectAtIndexPath:realIndexPath];
    return obj;
}

- (NSString *)textBubbleHeader:(NSIndexPath *)indexPath
{
    NSString *bubbleHeader;
    XMPPRoomMessageCoreDataStorageObject *message = [self objectAtIndexPath:indexPath];
    if (![self isFromMeMessage:message]) {
        
        XMPPvCardTemp *vCardFrom = [chat vCardTempSenderOfMessage:message];
        bubbleHeader = vCardFrom.nickname;
    }
    return bubbleHeader;
}

- (NSString *)textBubbleFooter:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *obj = [self objectAtIndexPath:indexPath];
    return [obj.localTimestamp stringMessage];
}

- (NSString *)textSectionHeader:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *obj = [self objectAtIndexPath:indexPath];
    if ([_firstMessageAtDay containsObject:obj.message.elementID]) {
        return [obj.localTimestamp stringGroup];
    }
    return nil;
}

- (UIImage *)avatarImage:(NSIndexPath *)indexPath
{
    UIImage *photo;
    XMPPRoomMessageCoreDataStorageObject *message = [self objectAtIndexPath:indexPath];
    if (chat.vCard.photo && [self isFromMeMessage:message]) {
        photo = [UIImage imageWithData:chat.vCard.photo];
    } else if (![self isFromMeMessage:message]) {
        
        XMPPvCardTemp *vCardFrom = [chat vCardTempSenderOfMessage:message];
        photo = [UIImage imageWithData:vCardFrom.photo];
    }
    return photo;
}

#pragma mark - Actions
- (void)actionSendMessage:(NSString *)text
{
    [chat.xmppRoom sendMessageWithBody:text];
}

- (void)actionTapBubble:(NSIndexPath *)indexPath
{
    [chat.xmppvCardAvatarModule.xmppvCardTempModule fetchvCardTempForJID:[XMPPJID jidWithString:@"bot@192.168.10.3"] ignoreStorage:YES];
}

- (void)updateUserTypingState:(BOOL)typing
{
    XMPPMessage *msg = [XMPPMessage message];
    if (typing) {
        [msg addComposingChatState];
    } else {
        [msg addPausedChatState];
    }
    
    [chat.xmppRoom sendMessage:msg];
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections][0] numberOfObjects];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueChatSettings"]) {
 
    }
}

@end
