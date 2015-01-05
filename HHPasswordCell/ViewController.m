//
//  ViewController.m
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ViewController.h"
#import "HHPasswordCell.h"

@interface HHPasswordForm : NSObject

@property (copy, nonatomic) NSString *currentPassword;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *confirmPassword;

@end

@implementation HHPasswordForm

@end

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *passwords;

@end

typedef NS_ENUM(NSInteger, HHSection) {
    HHCreatePasswordSection = 0,
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
    self.passwords = [@{
                        @(HHCreatePasswordSection) : [[HHPasswordForm alloc] init],
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
            
        default:
            break;
    }
    
    return titleForFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 1;
        
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        
        return [password isEqual:@"password"];
    };
    
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
    

    
    return passwordCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 120;
    
    HHPasswordForm *form = self.passwords[@(indexPath.section)];
    
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
        return [password isEqual:@"password"];
    };
    

    [passwordCell updateWithCurrentPassword:form.currentPassword
                                   password:form.password
                            confirmPassword:form.confirmPassword
                               editingBlock:nil
                            validatingBlock:HHPasswordCellValidatingBlock];
    
    heightForRow = [passwordCell height];
    NSLog(@"[%ld, %ld] heightForRow = %f", (long)indexPath.section, (long)indexPath.row, heightForRow);
    
    return heightForRow;

}

@end
