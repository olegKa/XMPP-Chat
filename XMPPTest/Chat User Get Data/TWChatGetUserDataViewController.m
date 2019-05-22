//
//  TWGetUserDataViewController.m
//  XMPPTest
//
//  Created by OLEG KALININ on 18.04.2019.
//  Copyright © 2019 oki. All rights reserved.
//

#import "TWChatGetUserDataViewController.h"
#import "TWChatInputFieldCell.h"
#import "TWChatEmptyCell.h"
#import "TWChatButtonCell.h"
#import "TWChatComboBoxCell.h"
#import "TWChatCheckBoxCell.h"
#import "TWChatSwitchCell.h"

#import "TWChatBotFunctionCheckBoxParam.h"

@interface TWChatGetUserDataViewController () <UIScrollViewDelegate>
{
    NSIndexPath *_indexPathButton;
}
@end

@implementation TWChatGetUserDataViewController

static NSString *const identCellInputField  = @"cellInputField";
static NSString *const identCellBoolean     = @"cellBoolean";
static NSString *const identCellComboBox    = @"cellComboBox";
static NSString *const identCellCheckBox    = @"cellCheckBox";
static NSString *const identCellButton      = @"cellButton";
static NSString *const identCellUnknown     = @"cellUnknown";

+ (instancetype)chatGetUserDataViewControllerWithFunction:(TWChatBotFunction *)function {
    UINavigationController *nav = [UIStoryboard storyboardWithName:NSStringFromClass(self.class) bundle:nil].instantiateInitialViewController;
    TWChatGetUserDataViewController *vc = nav.viewControllers.firstObject;
    vc.function = function;
    return vc;
}

- (void)setFunction:(TWChatBotFunction *)function {
    _function = function;
    [self addKeyValueObservers];
}

#pragma mark - KVO -
- (void)addKeyValueObservers {
    [self.function.outputParams enumerateObjectsUsingBlock:^(TWChatBotFunctionParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }];
}

- (void)removeKeyValueObservers {
    [self.function.outputParams enumerateObjectsUsingBlock:^(TWChatBotFunctionParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeObserver:self forKeyPath:@"value" context:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"value"]) {
        /*
        NSMutableArray *ips = @[].mutableCopy;
        NSIndexPath *ip = [self indexPathOfParam:object];
        
        if (ip) [ips addObject:ip];
        if (_indexPathButton) [ips addObject:_indexPathButton];
        [self.tableView reloadRowsAtIndexPaths:ips
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        */
        
        [self.view endEditing:YES];
        [self.tableView reloadData];
        
    }
}

#pragma mark - Life -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatInputFieldCell" bundle:nil] forCellReuseIdentifier:identCellInputField];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatEmptyCell" bundle:nil] forCellReuseIdentifier:identCellUnknown];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatButtonCell" bundle:nil] forCellReuseIdentifier:identCellButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatComboBoxCell" bundle:nil] forCellReuseIdentifier:identCellComboBox];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatSwitchCell" bundle:nil] forCellReuseIdentifier:identCellBoolean];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatCheckBoxCell" bundle:nil] forCellReuseIdentifier:identCellCheckBox];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 10;
    self.tableView.tableFooterView = [UIView new];
    
    [self configureNavigationBar];
}

- (void)configureNavigationBar {
 
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                              target:self
                                                                              action:@selector(buttonCancel:)];
    self.navigationItem.rightBarButtonItem = btnClose;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UITableViewCell *firstCell;
    @try {
        firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } @finally {
        if (firstCell && firstCell.canBecomeFirstResponder) {
            [firstCell becomeFirstResponder];
        }
    }
}

- (void)buttonCancel:(id)sender {
    
    [self removeKeyValueObservers];
    self.function.resultType = kChatBotFunctionResultDenied;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (self.getUserDataHandler) {
            self.getUserDataHandler(NO, self.function);
        }
    }];
}

- (BOOL)validate {
    
    __block BOOL isValid = YES;
    [self.function.outputParams enumerateObjectsUsingBlock:^(TWChatBotFunctionParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isOptional) {
            isValid = isValid && obj.validate;
        }
    }];
    
    return isValid;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _function.outputParams.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    TWChatBotFunctionParam *param = [self paramAtSection:section];
    switch (param.type) {
        case TWFunctionParamTypeString:
        case TWFunctionParamTypeComboBox:
        case TWFunctionParamTypeBool:
            return 1;
        case TWFunctionParamTypeCheckBox:
            return [(TWChatBotFunctionCheckBoxParam *)param values].count;
        default:
            break;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TWChatUserDataCell *cell;
    
    if (indexPath.section == _function.outputParams.count) {
        
        _indexPathButton = indexPath;
        cell = [tableView dequeueReusableCellWithIdentifier:identCellButton
                                               forIndexPath:indexPath];
        [self configureButtonCell:(TWChatButtonCell *)cell atIndexPath:indexPath];
        
    } else {
        
        TWChatBotFunctionParam *param = [self paramAtIndexPath:indexPath];
        cell = [tableView dequeueReusableCellWithIdentifier:[self identifierCellWithParam:param]
                                               forIndexPath:indexPath];
        [cell configureCellWithParameter:param atIndexPath:indexPath];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell <TWChatUserDataCellProtocol> *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(TWChatUserDataCellProtocol)]) {
        [cell didSelectCellWithViewController:self];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    TWChatBotFunctionParam *param = [self paramAtSection:section];
    switch (param.type) {
        case TWFunctionParamTypeString:
        case TWFunctionParamTypeComboBox:
        case TWFunctionParamTypeBool:
        {
            /* Вывести пустой footer, если предыдущий параметр отображается как секция (например, CheckBox) */
            NSString *previosTitle = section? [self tableView:tableView titleForHeaderInSection:section - 1]:nil;
            return previosTitle? @" ":nil;
        }
            break;
        case TWFunctionParamTypeCheckBox:
            return param.desc;
        default:
            break;
    }
    return nil;
}

#pragma mark - Helpers

- (void)configureButtonCell:(TWChatButtonCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.enabled = [self validate];
    cell.buttonHandler = ^(id sender) {
        [self removeKeyValueObservers];
        self.function.resultType = kChatBotFunctionResultApproved;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if (self.getUserDataHandler) {
                self.getUserDataHandler(YES, self.function);
            }
        }];
    };
}

- (NSString *)identifierCellWithParam:(TWChatBotFunctionParam *)param {
    
    switch (param.type) {
        case TWFunctionParamTypeString:
            return identCellInputField;
        case TWFunctionParamTypeComboBox:
            return identCellComboBox;
        case TWFunctionParamTypeBool:
            return identCellBoolean;
        case TWFunctionParamTypeCheckBox:
            return identCellCheckBox;
        default:
            break;
    }
    
    return identCellUnknown;
}

- (TWChatBotFunctionParam *)paramAtIndexPath:(NSIndexPath *)indexPath {
    return [self paramAtSection:indexPath.section];
}

- (TWChatBotFunctionParam *)paramAtSection:(NSUInteger)section {
    if (section < _function.outputParams.count) {
        return [_function.outputParams objectAtIndex:section];
    }
    return nil;
}

- (NSIndexPath *)indexPathOfParam:(TWChatBotFunctionParam *)param {
    NSInteger idx = [self.function.outputParams indexOfObject:param];
    if (idx != NSNotFound) {
        return [NSIndexPath indexPathForRow:0 inSection:idx];
    }
    return nil;
}

#pragma mark - <UIScrollViewDelegate> -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
