//
//  TWChatViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 23.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatViewController.h"
#import "TWChatSettingsViewController.h"
#import "TWImageViewController.h"

#import "AppDelegate.h"

#import "TWMessage.h"
#import "TWChatTypingIndicator.h"
#import "NSDate+TWChat.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface TWChatViewController () <NSFetchedResultsControllerDelegate, XMPPChatStateDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    TWChatTypingIndicator *typingIndicatorView;
    NSArray <NSString *> *_firstMessageAtDay; // список из первых сообщений за каждый из дней (для группировки по датам)
    NSMutableArray <TWMessage *> *_messages;
    
    __weak IBOutlet UIBarButtonItem *_btnCall;
    
    NSTimer *activityTimer;
}
@end

@implementation TWChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    _messages = @[].mutableCopy;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView reloadEmptyDataSet];
    
    UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(buttonSettings:)];
    
    self.navigationItem.rightBarButtonItem = btnSettings;
    
    UIBarButtonItem *btnClearRoom = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(buttonClearRoom:)];
    
    //self.navigationItem.leftBarButtonItem = btnClearRoom;
    
    typingIndicatorView = [TWChatTypingIndicator default];
    self.viewTypingIndicator = typingIndicatorView;
    chat.chatStateDelegate = self;
    
    //[self fetchedResultsController];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.tableView reloadEmptyDataSet];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [chat sendPresenceShow:@"chat"];
    
    //self.actions = @[];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [chat sendPresenceShow:@"away"];
}

- (void)applicationDidEnterBackground:(NSNotification *)notify
{
    [self.view endEditing:YES];
}

- (void)applicationWillEnterForeground:(NSNotification *)notify
{
}

- (IBAction)buttonCall:(id)sender
{
    
}

- (IBAction)buttonSettings:(id)sender
{
    TWChatSettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"TWChatSettings" bundle:nil] instantiateViewControllerWithIdentifier:@"TWChatSettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)buttonClearRoom:(id)sender
{
    [chat resetRoomWithCompletion:^(BOOL success) {
        
    }];
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
        [self.tableView reloadData];
        [self.tableView reloadEmptyDataSet];
        
    }
    
    return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateDates];
    [self.tableView reloadEmptyDataSet];
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.row] withRowAnimation:UITableViewRowAnimationFade];
            
            XMPPRoomMessageCoreDataStorageObject *obj = [controller objectAtIndexPath:newIndexPath];
            TWMessage *message = [[TWMessage alloc] initWithBody:obj.body incoming:![self isFromMeMessage:obj]];
            if (message.actions) {
                self.actions = message.actions.copy;
            }
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        default:
            break;
    }
}

#pragma mark - XMPPChatStateDelegate
- (void)xmppProvider:(TWXMPPProvider *)provider didChangeState:(XMPPChatState)state room:(XMPPRoom *)room occupant:(XMPPJID *)occupant
{
    typingIndicatorView.text = [NSString stringWithFormat:@"%@ печатает...", occupant.resource];
    [self typingIndicatorShow:(state == kChatStateComposing) animated:YES];
}

- (void)xmppProvider:(TWXMPPProvider *)provider didJoinToRoom:(XMPPRoom *)room
{
    self.title = @"Онлайн";
    self.enabled = YES;
    if (fetchedResultsController) {
        fetchedResultsController.delegate = nil;
        fetchedResultsController = nil;
        [self fetchedResultsController];
    }
}

- (void)didLeaveRoomXmppProvider:(TWXMPPProvider *)provider
{
    self.title = @"Оффлайн";
    self.enabled = NO;
}

#pragma mark - Message Processing
- (TWMessage *)rcmessage:(NSIndexPath *)indexPath
{
    TWMessage *msg = [self messageAtIndexPath:indexPath];
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
        if ([msg.elementID isEqualToString:obj.elementID]) {
            *stop = YES;
        }
        return *stop;
    }];
    
    if (msgIdx == NSNotFound) {
        BOOL isFromMe = [self isFromMeMessage:obj];
        message = [[TWMessage alloc] initWithBody:obj.body incoming:!isFromMe];
        message.elementID = obj.elementID;
        if (message.type == RC_TYPE_LOCATION || message.type == RC_TYPE_PICTURE) {
            message.loadingHandle = ^(TWMessage * _Nonnull message) {
                NSIndexPath *ip = [self indexPathOfMessage:message];
                if (ip) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ip.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self scrollToBottom:YES];
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
    //return [NSString stringWithFormat:@"ID:[%@]", obj.message.elementID];
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
    
    
    TWMessage *message = [self messageAtIndexPath:indexPath];
    switch (message.senderType) {
        case kSenderTypeClient:
            photo = [UIImage imageWithData:chat.xmppvCardTempModule.myvCardTemp.photo];
            break;
        case kSenderTypeBot:
            photo = [UIImage imageNamed:@"bot_avatar"];
            break;
        case kSenderTypeOperator:
            
            break;
        default:
            break;
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
    TWMessage *msg = [self messageAtIndexPath:indexPath];
    if (msg.picture_image) {
        TWImageViewController *vc = [UIStoryboard storyboardWithName:@"TWImageViewController" bundle:nil].instantiateInitialViewController;
        vc.image = msg.picture_image;
        [self presentViewController:vc animated:YES completion:nil];
    }
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

#pragma mark - <DZNEmptyDataSetSource> -
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"";
    if (chat.xmppStream.isConnecting) {
        title = @"Подключение...";
        [self startActivityTimer];
    } else if (chat.xmppStream.isDisconnected) {
        title = @"Сервер не доступен";
    }
    return [[NSAttributedString alloc] initWithString:title attributes:@{}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"";
    if (chat.xmppStream.isConnecting) {
        title = @"Загружается история сообщений";
    } else if (chat.xmppStream.isDisconnected) {
        title = @"Мы уже все исправляем. Попробуйте зайти позже.";
    }
    return [[NSAttributedString alloc] initWithString:title];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *title = @"";
    if (chat.xmppStream.isDisconnected) {
        title = @"Повторить";
    }
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightBold],
                                                        NSForegroundColorAttributeName: self.view.tintColor
                                                        }];
}

#pragma mark - <DZNEmptyDataSetDelegate> -
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView
{
    //[self startActivityTimer];
}

- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView
{
    [self stopActivityTimer];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    NSLog(@"tap reconnect");
    [chat connect];
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.tableView reloadEmptyDataSet];
    });
    
}

#pragma mark - Activity Timer -
- (void)startActivityTimer {
    if (!activityTimer || !activityTimer.valid) {
        activityTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self.tableView reloadEmptyDataSet];
        }];
        //activityTimer.tolerance = 2.0;
    }
}

- (void)stopActivityTimer {
    [activityTimer invalidate];
    activityTimer = nil;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueChatSettings"]) {
        
    }
}

@end
