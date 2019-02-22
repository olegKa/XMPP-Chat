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

@interface TWChatViewController () <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    
    __weak IBOutlet UIBarButtonItem *_btnCall;
}
@end

@implementation TWChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(buttonSettings:)];
    
    self.navigationItem.rightBarButtonItem = btnSettings;
    
    UIView *viewTypingIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    viewTypingIndicator.backgroundColor = UIColor.redColor;
    self.viewTypingIndicator = viewTypingIndicator;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.actions = @[];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    
    [self typingIndicatorShow:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self typingIndicatorShow:NO animated:YES];
    });
    });
}

- (NSArray <TWChatBotAction *> *)actions
{
    
    NSMutableArray *arr = @[].mutableCopy;
    
    /*
    [arr addObject:[TWChatBotAction botActionWithTitle:@"Admin" image:[UIImage imageNamed:@"Admin"] handler:^{
        [chat.xmppRoom sendMessageWithBody:[NSString stringWithFormat:@"Сделай мне <Admin>"]];
    }]];
    [arr addObject:[TWChatBotAction botActionWithTitle:@"Banned" image:[UIImage imageNamed:@"Banned"] handler:^{
        [chat.xmppRoom sendMessageWithBody:[NSString stringWithFormat:@"Сделай мне <Banned>"]];
    }]];
    [arr addObject:[TWChatBotAction botActionWithTitle:@"Members" image:[UIImage imageNamed:@"Members"] handler:^{
        [chat.xmppRoom sendMessageWithBody:[NSString stringWithFormat:@"Сделай мне <Members>"]];
    }]];
    
    [arr addObject:[TWChatBotAction botActionWithTitle:@"DO 4" image:nil handler:^{
        NSLog(@"DO 4");
    }]];
    */
    return arr.copy;
    
}

- (IBAction)buttonCall:(id)sender
{
    
}

- (IBAction)buttonSettings:(id)sender
{
    TWChatSettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"TWChatSettings" bundle:nil] instantiateViewControllerWithIdentifier:@"TWChatSettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
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
            TWMessage *message = [[TWMessage alloc] initWithBody:obj.body incoming:!obj.isFromMe];
            if (message.actions) {
                self.actions = message.actions.copy;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Message Processing
- (TWMessage *)rcmessage:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *obj = [self objectAtIndexPath:indexPath];
    TWMessage *msg = [[TWMessage alloc] initWithBody:obj.body incoming:!obj.isFromMe];
    return msg;
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
    if (!message.isFromMe) {
        
        XMPPvCardTemp *vCardFrom = [chat vCardTempSenderOfMessage:message];
        bubbleHeader = vCardFrom.nickname;
    }
    return bubbleHeader;
}

- (NSString *)textBubbleFooter:(NSIndexPath *)indexPath
{
    return @"bubble footer";
}

- (NSString *)textSectionHeader:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *obj = [self objectAtIndexPath:indexPath];
    return [NSString stringWithFormat:@"%@", obj.localTimestamp];
}

- (UIImage *)avatarImage:(NSIndexPath *)indexPath
{
    UIImage *photo;
    XMPPRoomMessageCoreDataStorageObject *message = [self objectAtIndexPath:indexPath];
    if (chat.vCard.photo && message.isFromMe) {
        photo = [UIImage imageWithData:chat.vCard.photo];
    } else if (!message.isFromMe) {
        
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

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections][0] numberOfObjects];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueChatSettings"]) {
        /*
        __weak TWChatSettingsViewController *vc = segue.destinationViewController;
        vc.didSaveBlock = ^(BOOL success) {
            if (success) {
                [vc.navigationController popViewControllerAnimated:YES];
            } else {
                [UIAlertController alertWithTitle:@"Error" andMessage:@"Ошибка"];
            }
        };
         */
    }
}

@end
