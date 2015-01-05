//
//  ViewController.m
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ViewController.h"
#import "HHPasswordCell.h"

@interface ViewController ()

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
            break;
        }
            
        default:
            break;
    }
    
    return passwordCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 120;
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
            break;
        }
            
        default:
            break;
    }
    
    heightForRow = [passwordCell height];
    NSLog(@"[%ld, %ld] heightForRow = %f", (long)indexPath.section, (long)indexPath.row, heightForRow);
    
    return heightForRow;

}

@end
