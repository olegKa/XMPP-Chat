//
//  TWMessageView.m
//  XMPPTest
//
//  Created by OLEG KALININ on 20.02.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWMessagesView.h"
#import "TWChatBotActionButton.h"
#import "TWMessage.h"

@interface TWMessagesView () <HPGrowingTextViewDelegate>
{
    __weak IBOutlet UIView *_actionsPanel;
    __weak IBOutlet NSLayoutConstraint *_inputViewHeight;
    __weak IBOutlet NSLayoutConstraint *_actionsViewHeight;
    __weak IBOutlet NSLayoutConstraint *_actionsBottom;
    
    NSTimer *_timerUserTyping;
}

@property (nonatomic, assign) BOOL userTyping;

@end

@implementation TWMessagesView

@synthesize enabled = _enabled;

- (instancetype)init
{
    self = [self initWithNibName:@"TWMessagesView" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //_actions = @[];
    
    _gTextInput.isScrollable = NO;
    _gTextInput.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _gTextInput.minNumberOfLines = 1;
    _gTextInput.maxNumberOfLines = 6;
    _gTextInput.font = [UIFont systemFontOfSize:15.0f];
    _gTextInput.delegate = self;
    _gTextInput.clipsToBounds = YES;
    _gTextInput.layer.cornerRadius = _gTextInput.bounds.size.height / 2;
    _gTextInput.placeholder = @"Введите сообщение";
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

static const CGFloat actionButtonHeight = 40.0f;
static const CGFloat space = 8.0f;
static const CGFloat halfSpace = 0.5f * space;

- (void)updateActionsPanel
{
    for (UIView *v in _actionsPanel.subviews) {
        [v removeFromSuperview];
    }
    
    NSUInteger rows = _actions.count % 2 + _actions.count / 2;
    
    int idx = 0;
    CGFloat posX = space, posY = space;
    CGFloat width = (self.view.bounds.size.width - 3 * space) / 2;
    for (NSUInteger i = 0; i < rows; i++) {
        
        TWChatBotAction *actionL = [_actions objectAtIndex:idx];
        actionL.handler = ^(TWChatBotAction *action) {
            [self actionSendMessage:[TWMessage messageTextWithAction:action]];
        };
        TWChatBotActionButton *btnActionL = [TWChatBotActionButton buttonWithAction:actionL];
        CGRect frameL = CGRectMake(posX,
                                   posY + halfSpace,
                                   _actions.count > idx + 1? width : width * 2 + space,
                                   actionButtonHeight);
        btnActionL.frame = frameL;
        [_actionsPanel addSubview:btnActionL];
        
        idx ++;
        
        if (_actions.count > idx) {
            TWChatBotAction *actionR = [_actions objectAtIndex:idx];
            actionR.handler = ^(TWChatBotAction *action) {
                [self actionSendMessage:[TWMessage messageTextWithAction:action]];
            };
            TWChatBotActionButton *btnActionR = [TWChatBotActionButton buttonWithAction:actionR];
            CGRect frameR = CGRectMake(posX + width + (0.5 * space), posY + halfSpace, width, actionButtonHeight);
            btnActionR.frame = frameR;
            [_actionsPanel addSubview:btnActionR];
            idx ++;
        } 
        
        posY += actionButtonHeight + halfSpace;
        posX = space;
    }
    
    _actionsViewHeight.constant = posY > space? posY : 0;
    [UIView animateWithDuration:0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Properties
- (void)setActions:(NSArray<TWChatBotAction *> *)actions
{
    _actions = actions;
    [self updateActionsPanel];
}

- (void)setUserTyping:(BOOL)userTyping
{
    if (_userTyping != userTyping) {
        [self updateUserTypingState:userTyping];
    }
        _userTyping = userTyping;
        
        if (userTyping && !_timerUserTyping.isValid) {
            _timerUserTyping = [NSTimer scheduledTimerWithTimeInterval:1.f repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self setUserTyping:NO];
            }];
        } else {
            [_timerUserTyping invalidate];
            _timerUserTyping = nil;
            
        }
    //}
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    _gTextInput.editable = enabled;
    
    for (UIView *button in _actionsPanel.subviews) {
        if ([button isKindOfClass:UIButton.class]) {
            [(UIButton *)button setEnabled:enabled];
        }
    }
}

- (BOOL)isEnabled
{
    return _enabled;
}

#pragma mark - Override
- (void)inputPanelUpdate {
    
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)typingIndicatorUpdate
{
    
}

- (void)updateUserTypingState:(BOOL)typing
{
    NSLog(@"user %@", typing? @"taping...": @"stop taping");
}

#pragma mark - User Actions
- (IBAction)actionInputAttach:(id)sender
{
    [self actionAttachMessage];
}

- (IBAction)actionInputSend:(id)sender
{
    if ([_gTextInput.text length] != 0)
    {
        //[self actionSendMessage:_gTextInput.text];
        NSString *jsonString = [TWMessage messageTextWithText:_gTextInput.text];
        [self actionSendMessage:jsonString];
        [self dismissKeyboard];
        _gTextInput.text = nil;
        [self inputPanelUpdate];
    }
}

- (void)actionAttachMessage
{
    
}

- (void)actionSendAudio:(NSString *)path
{
    
}

- (void)actionSendMessage:(NSString *)text
{
    
}


#pragma mark - <HPGrowingTextViewDelegate>
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView {
    return YES;
}

- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView {
    return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return  YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    self.userTyping = YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    
    float diff = (growingTextView.frame.size.height - height);
    _inputViewHeight.constant -= diff;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height {
    
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView {
    
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    return YES;
}

#pragma mark - Keyboard Notification Overloaded
- (void)keyboardShow:(NSNotification *)notification
{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        bottomPadding = window.safeAreaInsets.bottom;
    }
    
    _actionsBottom.constant = (keyboardBounds.size.height - bottomPadding);
    _actionsViewHeight.constant = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self scrollToBottom:NO];
    }];
    
}

- (void)keyboardHide:(NSNotification *)notification
{
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _actionsBottom.constant = 0;
    [self updateActionsPanel];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
/*
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (indexPath.row == 0) // Section header
    {
        return [RCSectionHeaderCell height:indexPath messagesView:self];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (indexPath.row == 1) // Bubble header
    {
        return [RCBubbleHeaderCell height:indexPath messagesView:self];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (indexPath.row == 2) // Message body
    {
        RCMessage *rcmessage = [self rcmessage:indexPath];
        if (rcmessage.type == RC_TYPE_STATUS)    return [RCStatusCell height:indexPath messagesView:self];
        if (rcmessage.type == RC_TYPE_TEXT)        return [RCTextMessageCell height:indexPath messagesView:self];
        if (rcmessage.type == RC_TYPE_EMOJI)    return [RCEmojiMessageCell height:indexPath messagesView:self];
        if (rcmessage.type == RC_TYPE_PICTURE)    return [RCPictureMessageCell height:indexPath messagesView:self];
        if (rcmessage.type == RC_TYPE_VIDEO)    return [RCVideoMessageCell height:indexPath messagesView:self];
        if (rcmessage.type == RC_TYPE_AUDIO)    return [RCAudioMessageCell height:indexPath messagesView:self];
        if (rcmessage.type == RC_TYPE_LOCATION)    return [RCLocationMessageCell height:indexPath messagesView:self];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (indexPath.row == 3) // Bubble footer
    {
        return [RCBubbleFooterCell height:indexPath messagesView:self];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (indexPath.row == 4) // Section footer
    {
        return [RCSectionFooterCell height:indexPath messagesView:self];
    }
    return 0;
}
*/

@end
