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

@interface CKPasswordForm : NSObject

@property (copy, nonatomic) NSString *currentPassword;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *confirmPassword;
@property (copy, nonatomic) NSArray *validations;

@end

@implementation CKPasswordForm

@end

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *passwords;
@property (nonatomic, strong) id<NSObject> keywordWillShowObserver;
@property (nonatomic, strong) id<NSObject> keywordWillHideObserver;

@end

typedef NS_ENUM(NSInteger, CKSection) {
    CKCreatePasswordSection = 0,
    CKCreatePasswordLockConfirmUntilSatisfySection,
    CKCreatePasswordSatisfyConfirmSection,
    CKUpdatePasswordSection,
    CKUpdatePasswordSatisfyConfirmSection,
    CKSectionCount
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Password Cell";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CKPasswordCell" bundle:nil] forCellReuseIdentifier:@"CKPasswordCell"];
    [self.tableView registerClass:[CKValidationMessageCell class] forCellReuseIdentifier:@"CKValidationMessageCell"];
    self.passwords = [@{
                        @(CKCreatePasswordSection) : [[CKPasswordForm alloc] init],
                        @(CKCreatePasswordLockConfirmUntilSatisfySection) : [[CKPasswordForm alloc] init],
                        @(CKCreatePasswordSatisfyConfirmSection) : [[CKPasswordForm alloc] init],
                        @(CKUpdatePasswordSection) : [[CKPasswordForm alloc] init],
                        @(CKUpdatePasswordSatisfyConfirmSection) : [[CKPasswordForm alloc] init],
                        } mutableCopy];
    
    self.keywordWillShowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
    }];
    
    self.keywordWillHideObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.tableView.contentInset = UIEdgeInsetsZero;
        
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.keywordWillShowObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keywordWillHideObserver];
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
    return CKSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleForHeader = nil;
    
    switch (section) {
        case CKCreatePasswordSection:
        case CKCreatePasswordLockConfirmUntilSatisfySection:
        case CKCreatePasswordSatisfyConfirmSection: {
            titleForHeader = @"Create Password";
            break;
        }
            
            
        case CKUpdatePasswordSection:
        case CKUpdatePasswordSatisfyConfirmSection:  {
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
        case CKCreatePasswordSatisfyConfirmSection:
        case CKUpdatePasswordSatisfyConfirmSection:
            titleForFooter = @"Satisfy Confirm";
            break;
            
        case CKCreatePasswordLockConfirmUntilSatisfySection:
            titleForFooter = @"Lock Until Satisfy";
            break;
            
        default:
            break;
    }
    
    return titleForFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 1;
    CKPasswordForm *form = self.passwords[@(section)];
    
    if (form.validations) {
        numberOfRows += 1;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    CKPasswordForm *form = self.passwords[@(indexPath.section)];
    
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
            case CKCreatePasswordSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:CKConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case CKCreatePasswordSatisfyConfirmSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:CKConfirmPasswordShowWhenSatisfyStyle];
                passwordCell.satisfyBlock = CKPasswordCellSatisfyBlock;
                
                
                break;
            }
                
            case CKCreatePasswordLockConfirmUntilSatisfySection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:CKConfirmPasswordLockUntilSatisfy];
//                passwordCell.satisfyBlock = CKPasswordCellSatisfyBlock;
                
                
                break;
            }
                
            case CKUpdatePasswordSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellUpdateStyle
                                                     confirmStyle:CKConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case CKUpdatePasswordSatisfyConfirmSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellUpdateStyle
                                                     confirmStyle:CKConfirmPasswordShowWhenSatisfyStyle];
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
        CKPasswordForm *form = self.passwords[@(indexPath.section)];
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
    
    CKPasswordForm *form = self.passwords[@(indexPath.section)];
    
    if (indexPath.row == 0) {
        CKPasswordCell *passwordCell = nil;
        
        switch (indexPath.section) {
            case CKCreatePasswordSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:CKConfirmPasswordAlwaysShowStyle];
                break;
            }
                
            case CKCreatePasswordSatisfyConfirmSection: {
                
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:CKConfirmPasswordShowWhenSatisfyStyle];
                
                
                break;
            }
                
            case CKCreatePasswordLockConfirmUntilSatisfySection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellCreateStyle
                                                     confirmStyle:CKConfirmPasswordLockUntilSatisfy];                
                
                break;
            }
                
            case CKUpdatePasswordSection: {
                
                if (passwordCell == nil) {
                    passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                            tableView:tableView
                                                                style:CKPasswordCellUpdateStyle
                                                         confirmStyle:CKConfirmPasswordAlwaysShowStyle];
                }
                break;
            }
                
            case CKUpdatePasswordSatisfyConfirmSection: {
                passwordCell = [CKPasswordCell cellWithIdentifier:@"CKPasswordCell"
                                                        tableView:tableView
                                                            style:CKPasswordCellUpdateStyle
                                                     confirmStyle:CKConfirmPasswordShowWhenSatisfyStyle];
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
        CKPasswordForm *form = self.passwords[@(indexPath.section)];
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
