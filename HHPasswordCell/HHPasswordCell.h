//
//  HHPasswordCell.h
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHPasswordCell;

typedef NS_ENUM(NSUInteger, HHPasswordCellStyle) {
    HHPasswordCellCreateStyle,
    HHPasswordCellUpdateStyle
};

typedef NS_ENUM(NSUInteger, HHConfirmPasswordStyle) {
    HHConfirmPasswordAlwaysShowStyle,
    HHConfirmPasswordShowWhenSatisfyStyle
};

typedef void (^HHPasswordCellSatisfyBlock)(UITextField *textField);
typedef void (^HHPasswordCellEditingBlock)(HHPasswordCell *cell, UITextField *textField);
typedef BOOL (^HHPasswordCellValidatingBlock)(NSString *password);

@interface HHPasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (readonly, nonatomic) HHPasswordCellStyle style;
@property (readonly, nonatomic) HHConfirmPasswordStyle confirmStyle;

@property (strong, nonatomic) HHPasswordCellSatisfyBlock satisfyBlock;
@property (readonly, nonatomic) HHPasswordCellValidatingBlock validatingBlock;
@property (readonly, nonatomic) HHPasswordCellEditingBlock editingBlock;

+ (instancetype)cellWithIdentifier:(NSString *)identifier
                         tableView:(UITableView *)tableView
                             style:(HHPasswordCellStyle)style
                      confirmStyle:(HHConfirmPasswordStyle)confirmStyle;

/**
 *  Call it to restore / maintain the textfields property after dequeue reused cell from tableview
 *
 *  @param currentPassword
 *  @param password
 *  @param confirmPassword
 *  @param editingBlock
 *  @param validtingBlock  required, cannot be nil
 */
- (void)updateWithCurrentPassword:(NSString *)currentPassword
                         password:(NSString *)password
                  confirmPassword:(NSString *)confirmPassword
                     editingBlock:(HHPasswordCellEditingBlock)editingBlock
                  validatingBlock:(HHPasswordCellValidatingBlock)validtingBlock;

- (CGFloat)height;

@end
