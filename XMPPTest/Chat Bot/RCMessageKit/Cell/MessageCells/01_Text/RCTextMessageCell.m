//
// Copyright (c) 2018 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RCTextMessageCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RCTextMessageCell() <UITextViewDelegate>
{
	NSIndexPath *indexPath;
	RCMessagesView *messagesView;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RCTextMessageCell

@synthesize textView;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(NSIndexPath *)indexPath_ messagesView:(RCMessagesView *)messagesView_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	indexPath = indexPath_; messagesView = messagesView_;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	RCMessage *rcmessage = [messagesView rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	[super bindData:indexPath messagesView:messagesView];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.viewBubble.backgroundColor = rcmessage.incoming ? [RCMessages textBubbleColorIncoming] : [RCMessages textBubbleColorOutgoing];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (textView == nil)
	{
		textView = [[UITextView alloc] init];
		textView.font = [RCMessages textFont];
        textView.delegate = self;
		textView.editable = NO;
		textView.selectable = YES;
		textView.scrollEnabled = NO;
		textView.userInteractionEnabled = NO;
		textView.backgroundColor = [UIColor clearColor];
		textView.textContainer.lineFragmentPadding = 0;
		textView.textContainerInset = [RCMessages textInset];
		[self.viewBubble addSubview:textView];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	textView.textColor = rcmessage.incoming ? [RCMessages textTextColorIncoming] : [RCMessages textTextColorOutgoing];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    if (rcmessage.attributedText) {
        textView.text = nil;
        textView.attributedText = rcmessage.attributedText;
    } else {
        //textView.attributedText = ;
        //textView.text = rcmessage.text;
        //textView.font = [RCMessages textFont];
    }
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGSize size = [RCTextMessageCell size:indexPath messagesView:messagesView];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[super layoutSubviews:size];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	textView.frame = CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - Size methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)height:(NSIndexPath *)indexPath messagesView:(RCMessagesView *)messagesView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGSize size = [self size:indexPath messagesView:messagesView];
	return size.height;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (CGSize)size:(NSIndexPath *)indexPath messagesView:(RCMessagesView *)messagesView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessage *rcmessage = [messagesView rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat widthTable = messagesView.tableView.frame.size.width;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat maxwidth = (0.6 * widthTable) - [RCMessages textInsetLeft] - [RCMessages textInsetRight];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    
    CGRect rect;
    if (rcmessage.attributedText) {
        rect = [rcmessage.attributedText boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    } else {
        rect = [rcmessage.text boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[RCMessages textFont]} context:nil];
    }
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat width = rect.size.width + [RCMessages textInsetLeft] + [RCMessages textInsetRight];
	CGFloat height = rect.size.height + [RCMessages textInsetTop] + [RCMessages textInsetBottom];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return CGSizeMake(fmaxf(width, [RCMessages textBubbleWidthMin]), fmaxf(height, [RCMessages textBubbleHeightMin]));
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize retVal = [RCTextMessageCell size:indexPath messagesView:messagesView];
    return retVal;
}

#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if ([self.delegate respondsToSelector:@selector(textMessageCell:didInteractURL:)]) {
        [self.delegate textMessageCell:self didInteractURL:URL];
    }
    return NO;
}

@end
