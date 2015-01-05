//
//  HHPasswordCell.h
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HHPasswordCellStyle) {
    HHPasswordCellCreateStyle,
    HHPasswordCellUpdateStyle
};

typedef NS_ENUM(NSUInteger, HHConfirmPasswordStyle) {
    HHConfirmPasswordAlwaysShowStyle,
    HHConfirmPasswordShowWhenSatisfyStyle
};

@interface HHPasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (readonly, nonatomic) HHPasswordCellStyle style;
@property (readonly, nonatomic) HHConfirmPasswordStyle confirmStyle;

+ (instancetype)cellWithIdentifier:(NSString *)identifier
                         tableView:(UITableView *)tableView
                             style:(HHPasswordCellStyle)style
                      confirmStyle:(HHConfirmPasswordStyle)confirmStyle;

- (CGFloat)height;

@end
