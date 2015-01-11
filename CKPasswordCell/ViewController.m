//
//  ViewController.m
//  CKPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ViewController.h"
#import "CKPasswordCell.h"
#import "CKPasswordValidator.h"
#import "CKValidationMessageCell.h"

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CKPasswordCell" bundle:nil] forCellReuseIdentifier:@"CKPasswordCell"];
    [self.tableView registerClass:[CKValidationMessageCell class] forCellReuseIdentifier:@"CKValidationMessageCell"];
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
    
    void (^CKPasswordCellEditingBlock)(CKPasswordCell*, UITextField *) = ^(CKPasswordCell *cell, UITextField *textField) {
        if (textField == cell.currentPasswordTextField) {
            weakForm.currentPassword = textField.text;
        } else if (textField == cell.passwordTextField) {
            weakForm.password = textField.text;
        } else if (textField == cell.confirmPasswordTextField) {
            weakForm.confirmPassword = textField.text;
        }
    };
    
    void (^CKPasswordCellSatisfyBlock)(UITextField *) = ^(UITextField *textField) {
        [weakTableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
        CKPasswordCell *newCell = (CKPasswordCell *)[weakTableView cellForRowAtIndexPath:indexPath];
        [newCell.passwordTextField becomeFirstResponder];
    };
    
    BOOL (^CKPasswordCellValidatingBlock)(NSString *password) = ^BOOL(NSString *password) {
        
        return ([CKPasswordValidator validateWithPassword:password] == CKPasswordValidationSuccess);
    };
    
    NSArray* (^CKPasswordCellPasswordValidationsBlock)(NSString *password) = ^NSArray* (NSString *password) {
        
        CKPasswordValidation results = [CKPasswordValidator validateWithPassword:password];
        return [CKPasswordValidator messagesFromValiationResults:results];
        
    };
    
    NSArray* (^CKPasswordCellConfirmPasswordValidationsBlock)(NSString *password, NSString *confirmPassword) = ^NSArray* (NSString *password, NSString *confirmPassword) {
        return [CKPasswordValidator confirmMessagesWithPassword:password confirmPassword:confirmPassword];
    };
    
    void (^CKPasswordCellValidationUpdatingBlock)(NSArray *, UITextField *) = ^(NSArray *validations, UITextField *textField) {
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
        CKPasswordCell *passwordCell = nil;
        switch (indexPath.section) {
            case HHCreatePasswordSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case HHCreatePasswordSatisfyConfirmSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                passwordCell.satisfyBlock = CKPasswordCellSatisfyBlock;
                
                
                break;
            }
                
            case HHCreatePasswordLockConfirmUntilSatisfySection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordLockUntilSatisfy];
//                passwordCell.satisfyBlock = CKPasswordCellSatisfyBlock;
                
                
                break;
            }
                
            case HHUpdatePasswordSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case HHUpdatePasswordSatisfyConfirmSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                passwordCell.satisfyBlock = CKPasswordCellSatisfyBlock;
                
                break;
            }
                
            default:
                break;
        }
        
        [passwordCell updateWithCurrentPassword:form.currentPassword
                                       password:form.password
                                confirmPassword:form.confirmPassword
                                   editingBlock:CKPasswordCellEditingBlock
                                validatingBlock:CKPasswordCellValidatingBlock];
        
        passwordCell.passwordValidationsBlock = CKPasswordCellPasswordValidationsBlock;
        passwordCell.confirmPasswordValidationsBlock = CKPasswordCellConfirmPasswordValidationsBlock;
        passwordCell.validationsUpdatingBlock = CKPasswordCellValidationUpdatingBlock;
        cell = passwordCell;
        
        // hacking way to hide the separator line
        cell.separatorInset = UIEdgeInsetsMake(0, cell.frame.size.width / 2, 0, cell.frame.size.width / 2);
        
    } else {
        HHPasswordForm *form = self.passwords[@(indexPath.section)];
        CKValidationMessageCell *messageCell = [CKValidationMessageCell cellWithIdentifier:@"CKValidationMessageCell"
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
        CKPasswordCell *passwordCell = nil;
        
        switch (indexPath.section) {
            case HHCreatePasswordSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case HHCreatePasswordSatisfyConfirmSection: {
                
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                
                
                break;
            }
                
            case HHCreatePasswordLockConfirmUntilSatisfySection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordLockUntilSatisfy];                
                
                break;
            }
                
            case HHUpdatePasswordSection: {
                
                if (passwordCell == nil) {
                    passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                            tableView:tableView
                                                                style:CKPasswordCellUpdateStyle
                                                         confirmStyle:HHConfirmPasswordAlwaysShowStyle];
                }
                break;
            }
                
            case HHUpdatePasswordSatisfyConfirmSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfyStyle];
                break;
            }
                
            default:
                break;
        }
        
        
        BOOL (^CKPasswordCellValidatingBlock)(NSString *password) = ^BOOL(NSString *password) {
            return ([CKPasswordValidator validateWithPassword:password] == CKPasswordValidationSuccess);
        };
        
        
        [passwordCell updateWithCurrentPassword:form.currentPassword
                                       password:form.password
                                confirmPassword:form.confirmPassword
                                   editingBlock:nil
                                validatingBlock:CKPasswordCellValidatingBlock];
        
        heightForRow = [passwordCell height];
        
    } else {
        HHPasswordForm *form = self.passwords[@(indexPath.section)];
        CKValidationMessageCell *messageCell = [CKValidationMessageCell cellWithIdentifier:@"CKValidationMessageCell"
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
