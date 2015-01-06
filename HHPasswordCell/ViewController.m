//
//  ViewController.m
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ViewController.h"
#import "HHPasswordCell.h"
#import "HHPasswordValidator.h"
#import "HHValidationMessageCell.h"

@interface HHPasswordForm : NSObject

@property (copy, nonatomic) NSString *currentPassword;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *confirmPassword;
@property (copy, nonatomic) NSArray *validations;

@end

@implementation HHPasswordForm

@end

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *passwords;

@end

typedef NS_ENUM(NSInteger, HHSection) {
    HHCreatePasswordSection = 0,
    HHCreatePasswordLockConfirmUntilSatisfySection,
    HHCreatePasswordSatisfyConfirmSection,
    HHUpdatePasswordSection,
    HHUpdatePasswordSatisfyConfirmSection,
    HHSectionCount
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Password Cell";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHPasswordCell" bundle:nil] forCellReuseIdentifier:@"HHPasswordCell"];
    [self.tableView registerClass:[HHValidationMessageCell class] forCellReuseIdentifier:@"HHValidationMessageCell"];
    self.passwords = [@{
                        @(HHCreatePasswordSection) : [[HHPasswordForm alloc] init],
                        @(HHCreatePasswordLockConfirmUntilSatisfySection) : [[HHPasswordForm alloc] init],
                        @(HHCreatePasswordSatisfyConfirmSection) : [[HHPasswordForm alloc] init],
                        @(HHUpdatePasswordSection) : [[HHPasswordForm alloc] init],
                        @(HHUpdatePasswordSatisfyConfirmSection) : [[HHPasswordForm alloc] init],
                        } mutableCopy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleRefresh:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HHSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleForHeader = nil;
    
    switch (section) {
        case HHCreatePasswordSection:
        case HHCreatePasswordLockConfirmUntilSatisfySection:
        case HHCreatePasswordSatisfyConfirmSection: {
            titleForHeader = @"Create Password";
            break;
        }
            
            
        case HHUpdatePasswordSection:
        case HHUpdatePasswordSatisfyConfirmSection:  {
            titleForHeader = @"Update Password";
            break;
        }
            
        default:
            break;
    }
    
    return titleForHeader;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *titleForFooter = nil;
    switch (section) {
        case HHCreatePasswordSatisfyConfirmSection:
        case HHUpdatePasswordSatisfyConfirmSection:
            titleForFooter = @"Satisfy Confirm";
            break;
            
        case HHCreatePasswordLockConfirmUntilSatisfySection:
            titleForFooter = @"Lock Until Satisfy";
            break;
            
        default:
            break;
    }
    
    return titleForFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 1;
    HHPasswordForm *form = self.passwords[@(section)];
    
    if (form.validations) {
        numberOfRows += 1;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    HHPasswordForm *form = self.passwords[@(indexPath.section)];
    
    __weak typeof(tableView) weakTableView = tableView;
    __weak typeof(form) weakForm = form;
    
    void (^HHPasswordCellEditingBlock)(HHPasswordCell*, UITextField *) = ^(HHPasswordCell *cell, UITextField *textField) {
        if (textField == cell.currentPasswordTextField) {
            weakForm.currentPassword = textField.text;
        } else if (textField == cell.passwordTextField) {
            weakForm.password = textField.text;
        } else if (textField == cell.confirmPasswordTextField) {
            weakForm.confirmPassword = textField.text;
        }
    };
    
    void (^HHPasswordCellSatisfyBlock)(UITextField *) = ^(UITextField *textField) {
        [weakTableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
        HHPasswordCell *newCell = (HHPasswordCell *)[weakTableView cellForRowAtIndexPath:indexPath];
        [newCell.passwordTextField becomeFirstResponder];
    };
    
    BOOL (^HHPasswordCellValidatingBlock)(NSString *password) = ^BOOL(NSString *password) {
        
        return ([HHPasswordValidator validateWithPassword:password] == HHPasswordValidationSuccess);
    };
    
    NSArray* (^HHPasswordCellPasswordValidationsBlock)(NSString *password) = ^NSArray* (NSString *password) {
        
        HHPasswordValidation results = [HHPasswordValidator validateWithPassword:password];
        return [HHPasswordValidator messagesFromValiationResults:results];
        
    };
    
    NSArray* (^HHPasswordCellConfirmPasswordValidationsBlock)(NSString *password, NSString *confirmPassword) = ^NSArray* (NSString *password, NSString *confirmPassword) {
        return [HHPasswordValidator confirmMessagesWithPassword:password confirmPassword:confirmPassword];
    };
    
    void (^HHPasswordCellValidationUpdatingBlock)(NSArray *, UITextField *) = ^(NSArray *validations, UITextField *textField) {
        [weakTableView beginUpdates];
        
        if (weakForm.validations == nil) {
            weakForm.validations = validations;
            [weakTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else {
            if (![weakForm.validations isEqual:validations]) {
                weakForm.validations = validations;
                [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [weakTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        
        [textField becomeFirstResponder];
        
        [weakTableView endUpdates];
    };
    
    if (indexPath.row == 0) {
        HHPasswordCell *passwordCell = nil;
        switch (indexPath.section) {
            case HHCreatePasswordSection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case HHCreatePasswordSatisfyConfirmSection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                passwordCell.satisfyBlock = HHPasswordCellSatisfyBlock;
                
                
                break;
            }
                
            case HHCreatePasswordLockConfirmUntilSatisfySection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordLockUntilSatisfy];
//                passwordCell.satisfyBlock = HHPasswordCellSatisfyBlock;
                
                
                break;
            }
                
            case HHUpdatePasswordSection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case HHUpdatePasswordSatisfyConfirmSection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                passwordCell.satisfyBlock = HHPasswordCellSatisfyBlock;
                
                break;
            }
                
            default:
                break;
        }
        
        [passwordCell updateWithCurrentPassword:form.currentPassword
                                       password:form.password
                                confirmPassword:form.confirmPassword
                                   editingBlock:HHPasswordCellEditingBlock
                                validatingBlock:HHPasswordCellValidatingBlock];
        
        passwordCell.passwordValidationsBlock = HHPasswordCellPasswordValidationsBlock;
        passwordCell.confirmPasswordValidationsBlock = HHPasswordCellConfirmPasswordValidationsBlock;
        passwordCell.validationsUpdatingBlock = HHPasswordCellValidationUpdatingBlock;
        cell = passwordCell;
        
        // hacking way to hide the separator line
        cell.separatorInset = UIEdgeInsetsMake(0, cell.frame.size.width / 2, 0, cell.frame.size.width / 2);
        
    } else {
        HHPasswordForm *form = self.passwords[@(indexPath.section)];
        HHValidationMessageCell *messageCell = [HHValidationMessageCell cellWithIdentifier:@"HHValidationMessageCell"
                                                                                 tableView:tableView
                                                                               validations:form.validations
                                                                                validColor:VALIDATION_GREEN
                                                                              invalidColor:VALIDATION_RED];
        cell = messageCell;
        
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 120;
    
    HHPasswordForm *form = self.passwords[@(indexPath.section)];
    
    if (indexPath.row == 0) {
        HHPasswordCell *passwordCell = nil;
        
        switch (indexPath.section) {
            case HHCreatePasswordSection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case HHCreatePasswordSatisfyConfirmSection: {
                
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                
                
                break;
            }
                
            case HHCreatePasswordLockConfirmUntilSatisfySection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordLockUntilSatisfy];                
                
                break;
            }
                
            case HHUpdatePasswordSection: {
                
                if (passwordCell == nil) {
                    passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                            tableView:tableView
                                                                style:HHPasswordCellUpdateStyle
                                                         confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                }
                break;
            }
                
            case HHUpdatePasswordSatisfyConfirmSection: {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"HHPasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                break;
            }
                
            default:
                break;
        }
        
        
        BOOL (^HHPasswordCellValidatingBlock)(NSString *password) = ^BOOL(NSString *password) {
            return ([HHPasswordValidator validateWithPassword:password] == HHPasswordValidationSuccess);
        };
        
        
        [passwordCell updateWithCurrentPassword:form.currentPassword
                                       password:form.password
                                confirmPassword:form.confirmPassword
                                   editingBlock:nil
                                validatingBlock:HHPasswordCellValidatingBlock];
        
        heightForRow = [passwordCell height];
        
    } else {
        HHPasswordForm *form = self.passwords[@(indexPath.section)];
        HHValidationMessageCell *messageCell = [HHValidationMessageCell cellWithIdentifier:@"HHValidationMessageCell"
                                                                                 tableView:tableView
                                                                               validations:form.validations
                                                                                validColor:VALIDATION_GREEN
                                                                              invalidColor:VALIDATION_RED];
        
        heightForRow = [messageCell height];
        
    }
    
    NSLog(@"[%ld, %ld] heightForRow = %f", (long)indexPath.section, (long)indexPath.row, heightForRow);

    return heightForRow;

}

@end
