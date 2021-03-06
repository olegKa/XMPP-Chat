//
//  TWChatInputFieldCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatInputFieldCell.h"
#import "UITextFieldMask.h"
#import "NSStringMask.h"

@interface TWChatInputFieldCell () <UITextFieldDelegate>
{
    __weak IBOutlet UIButton *_btnInfo;
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UILabel *_labelAnnotation;
}
@end

@implementation TWChatInputFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _textField.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParam:(TWChatBotFunctionParam *)param {
    [super setParam:param];
    
    _labelTitle.text = param.desc;
    _labelAnnotation.text = nil;
    _textField.text = param.value;
    _textField.placeholder = param.desc;
    
}

- (BOOL)canBecomeFirstResponder {
    return _textField.canBecomeFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return _textField.becomeFirstResponder;
}

#pragma mark - <UITextFieldDelegate> -
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.param.value = textField.text;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.param.value = textField.text;
    return YES;
}

@end
