//
//  TWChatViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 23.01.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatViewController.h"
#import "TWChatSettingsViewController.h"

@interface TWChatViewController () <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}
@end

@implementation TWChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    
    //[chat getAllRegisteredUsers];
    
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
    [self.tableView reloadData];
    [self scrollToBottom:YES];
}

- (RCMessage *)rcmessage:(NSIndexPath *)indexPath
{
    XMPPRoomMessageCoreDataStorageObject *obj = [self objectAtIndexPath:indexPath];
    RCMessage *msg = [[RCMessage alloc] initWithText:obj.body incoming:!obj.isFromMe];
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
