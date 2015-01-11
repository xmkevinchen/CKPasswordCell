//
//  CKPasswordCell.h
//  CKPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKPasswordCell;

typedef NS_ENUM(NSUInteger, CKPasswordCellStyle) {
    CKPasswordCellCreateStyle,
    CKPasswordCellUpdateStyle
};

typedef NS_ENUM(NSUInteger, CKConfirmPasswordStyle) {
    CKConfirmPasswordAlwaysShowStyle,
    CKConfirmPasswordLockUntilSatisfy,
    CKConfirmPasswordShowWhenSatisfyStyle
};

typedef void (^CKPasswordCellSatisfyBlock)(UITextField *textField);
typedef void (^CKPasswordCellEditingBlock)(CKPasswordCell *cell, UITextField *textField);
typedef BOOL (^CKPasswordCellValidatingBlock)(NSString *password);

typedef NSArray* (^CKPasswordCellPasswordValidationsBlock)(NSString *password);
typedef NSArray* (^CKPasswordCellConfirmPasswordValidationsBlock)(NSString *password, NSString* confirmPassword);
typedef void (^CKPasswordCellValidationsUpdatingBlock)(NSArray *validations, UITextField *textField);

@interface CKPasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (readonly, nonatomic) CKPasswordCellStyle style;
@property (readonly, nonatomic) CKConfirmPasswordStyle confirmStyle;

@property (strong, nonatomic) CKPasswordCellSatisfyBlock satisfyBlock;
@property (readonly, nonatomic) CKPasswordCellValidatingBlock validatingBlock;
@property (readonly, nonatomic) CKPasswordCellEditingBlock editingBlock;

@property (strong, nonatomic) CKPasswordCellPasswordValidationsBlock passwordValidationsBlock;
@property (strong, nonatomic) CKPasswordCellConfirmPasswordValidationsBlock confirmPasswordValidationsBlock;
@property (strong, nonatomic) CKPasswordCellValidationsUpdatingBlock validationsUpdatingBlock;

+ (instancetype)cellWithIdentifier:(NSString *)identifier
                         tableView:(UITableView *)tableView
                             style:(CKPasswordCellStyle)style
                      confirmStyle:(CKConfirmPasswordStyle)confirmStyle;

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
                     editingBlock:(CKPasswordCellEditingBlock)editingBlock
                  validatingBlock:(CKPasswordCellValidatingBlock)validtingBlock;

- (CGFloat)height;

@end
