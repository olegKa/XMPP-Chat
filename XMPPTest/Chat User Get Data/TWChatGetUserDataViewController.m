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

@interface TWChatGetUserDataViewController ()

@end

@implementation TWChatGetUserDataViewController

static NSString *const identCellInputField = @"cellInputField";
static NSString *const identCellComboBox = @"cellComboBox";
static NSString *const identCellButton = @"cellButton";
static NSString *const identCellUnknown = @"cellUnknown";

+ (instancetype)chatGetUserDataViewControllerWithFunction:(TWChatBotFunction *)function {
    UINavigationController *nav = [UIStoryboard storyboardWithName:NSStringFromClass(self.class) bundle:nil].instantiateInitialViewController;
    TWChatGetUserDataViewController *vc = nav.viewControllers.firstObject;
    vc.function = function;
    return vc;
}


#pragma mark - Life -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatInputFieldCell" bundle:nil] forCellReuseIdentifier:identCellInputField];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatEmptyCell" bundle:nil] forCellReuseIdentifier:identCellUnknown];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatButtonCell" bundle:nil] forCellReuseIdentifier:identCellButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"TWChatComboBoxCell" bundle:nil] forCellReuseIdentifier:identCellComboBox];
    
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

- (void)buttonCancel:(id)sender {
    
    self.function.resultType = kChatBotFunctionResultDenied;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (self.getUserDataHandler) {
            self.getUserDataHandler(NO, self.function);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _function.outputParams.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TWChatUserDataCell *cell;
    
    if (indexPath.row == _function.outputParams.count) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:identCellButton forIndexPath:indexPath];
        [self configureButtonCell:(TWChatButtonCell *)cell atIndexPath:indexPath];
        
    } else {
        
        TWChatBotFunctionParam *param = _function.outputParams[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:[self identifierCellWithParam:param]
                                               forIndexPath:indexPath];
        
        [(TWChatUserDataCell *)cell setParam:param];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell <TWChatUserDataCellProtocol> *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(TWChatUserDataCellProtocol)]) {
        [cell didSelectCellWithViewController:self];
    }
}

#pragma mark - Helpers

- (void)configureButtonCell:(TWChatButtonCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.buttonHandler = ^(id sender) {
        self.function.resultType = kChatBotFunctionResultApproved;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if (self.getUserDataHandler) {
                self.getUserDataHandler(YES, self.function);
            }
        }];
    };
}

- (NSString *)identifierCellWithParam:(TWChatBotFunctionParam *)param {
    
    if ([param.type isEqualToString:@"string"]) {
        return identCellInputField;
    } else if ([param.type isEqualToString:@"comboBox"]) {
        return identCellComboBox;
    }
    return identCellUnknown;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
