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
    HHUpdatePasswordSection,
    HHSectionCount
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHPasswordCell" bundle:nil] forCellReuseIdentifier:@"CreatePasswordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHPasswordCell" bundle:nil] forCellReuseIdentifier:@"UpdatePasswordCell"];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    switch (section) {
        case HHCreatePasswordSection:
            numberOfRows = 2;
            break;
            
        case HHUpdatePasswordSection:
            numberOfRows = 2;
            break;
            
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHPasswordCell *passwordCell = nil;
    switch (indexPath.section) {
        case HHCreatePasswordSection: {
            if (indexPath.row == 0) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"CreatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
            } else if (indexPath.row == 1) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"CreatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfiedStyle];
            }
            break;
        }
            
        case HHUpdatePasswordSection: {
            if (indexPath.row == 0) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"UpdatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
            } else if (indexPath.row == 1) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"UpdatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfiedStyle];
            }
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
            if (indexPath.row == 0) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"CreatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
            } else if (indexPath.row == 1) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"CreatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellCreateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfiedStyle];
            }
            break;
        }
            
        case HHUpdatePasswordSection: {
            if (indexPath.row == 0) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"UpdatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordAlwaysShowStyle];
            } else if (indexPath.row == 1) {
                passwordCell = [HHPasswordCell cellWithIdentifier:@"UpdatePasswordCell"
                                                        tableView:tableView
                                                            style:HHPasswordCellUpdateStyle
                                                     confirmStyle:HHConfirmPasswordShowWhenSatisfiedStyle];
            }
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
