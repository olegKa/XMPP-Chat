//
//  TWChatCheckBoxCell.m
//  XMPPTest
//
//  Created by OLEG KALININ on 22.05.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatCheckBoxCell.h"
#import "TWChatBotFunctionCheckBoxParam.h"

@interface TWChatCheckBoxCell ()
{
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UIButton *_buttonCheck;
}

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation TWChatCheckBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    
    [_buttonCheck setImage:[UIImage imageNamed:isSelected? @"img_check":@"img_uncheck"] forState:UIControlStateNormal];
    
    NSMutableSet *value = [(NSSet *)self.param.value mutableCopy];
    if (isSelected) {
        [value addObject:[self paramValueAtIndex:_indexOfValue]];
    } else {
        [value removeObject:[self paramValueAtIndex:_indexOfValue]];
    }
    
    self.param.value = value.copy;
}

- (void)setIndexOfValue:(NSUInteger)indexOfValue {
    
    _indexOfValue = indexOfValue;
    
    _labelTitle.text = [self paramValueAtIndex:_indexOfValue];
    TWChatBotFunctionCheckBoxParam *param = (TWChatBotFunctionCheckBoxParam *)self.param;
    if ([param.value isKindOfClass:NSSet.class]) {
        _isSelected = [(NSSet *)param.value containsObject:[self paramValueAtIndex:_indexOfValue]];
        [_buttonCheck setImage:[UIImage imageNamed:_isSelected? @"img_check":@"img_uncheck"] forState:UIControlStateNormal];
    }
}

- (IBAction)buttonCheck:(id)sender {
    self.isSelected = !_isSelected;
}

- (id)paramValueAtIndex:(NSUInteger)index {
    return [[(TWChatBotFunctionCheckBoxParam *)self.param values] objectAtIndex:index];
}

#pragma mark - <TWChatUserDataCellProtocol> -
- (void)configureCellWithParameter:(TWChatBotFunctionParam *)param atIndexPath:(NSIndexPath *)indexPath {
    [super configureCellWithParameter:param atIndexPath:indexPath];
    [self setIndexOfValue:indexPath.row];
}

@end
