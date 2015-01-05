//
//  HHPasswordCell.m
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "HHPasswordCell.h"

@interface HHPasswordCell() <UITextFieldDelegate>

@property (assign, nonatomic) HHPasswordCellStyle style;
@property (assign, nonatomic) HHConfirmPasswordStyle confirmStyle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPasswordTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPasswordHeightLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTopLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordBottomLayout;


@end

@implementation HHPasswordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
    self.currentPasswordTopLayout.constant = 7;
    self.currentPasswordHeightLayout.constant = 30;
    self.passwordTopLayout.constant = 8;
    self.confirmPasswordTopLayout.constant = 8;
    self.confirmPasswordHeightLayout.constant = 30;
    self.confirmPasswordBottomLayout.constant = 6;
}

+ (instancetype)cellWithIdentifier:(NSString *)identifier
                         tableView:(UITableView *)tableView
                             style:(HHPasswordCellStyle)style
                      confirmStyle:(HHConfirmPasswordStyle)confirmStyle {
    HHPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.style = style;
    cell.confirmStyle = confirmStyle;
    cell.passwordTextField.delegate = cell;
    cell.confirmPasswordTextField.delegate = cell;
    
    // Set up layout constraints base on styles
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[c]|" options:0 metrics:nil views:@{@"c" : cell.contentView}]];
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (HHPasswordCellCreateStyle == style) {
        cell.passwordTopLayout.constant = cell.currentPasswordTopLayout.constant;
        
        cell.currentPasswordTextField.hidden = 0;
        cell.currentPasswordTopLayout.constant = 0;
        cell.currentPasswordHeightLayout.constant = 0;
    }
    
    if (HHConfirmPasswordShowWhenSatisfyStyle == confirmStyle) {
        cell.confirmPasswordTopLayout.constant = cell.confirmPasswordBottomLayout.constant;
        
        cell.confirmPasswordTextField.hidden = 0;
        cell.confirmPasswordHeightLayout.constant = 0;
        cell.confirmPasswordBottomLayout.constant = 0;
    }
    
    
    return cell;
}

- (void)setStyle:(HHPasswordCellStyle)style {
    _style = style;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (CGFloat)height {
    [self updateConstraints];
    [self layoutIfNeeded];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return height;
    
}

@end
