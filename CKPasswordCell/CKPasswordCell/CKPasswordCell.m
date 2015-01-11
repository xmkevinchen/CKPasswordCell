//
//  CKPasswordCell.m
//  CKPasswordCell
//
//  Created by Kevin Chen on 1/2/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "CKPasswordCell.h"

@interface CKPasswordCell() <UITextFieldDelegate>

@property (assign, nonatomic) CKPasswordCellStyle style;
@property (assign, nonatomic) CKConfirmPasswordStyle confirmStyle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPasswordTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPasswordHeightLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTopLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordBottomLayout;

@property (strong, nonatomic) CKPasswordCellEditingBlock editingBlock;
@property (strong, nonatomic) CKPasswordCellValidatingBlock validatingBlock;


@end

@implementation CKPasswordCell


+ (instancetype)cellWithIdentifier:(NSString *)identifier
                         tableView:(UITableView *)tableView
                             style:(CKPasswordCellStyle)style
                      confirmStyle:(CKConfirmPasswordStyle)confirmStyle {
    CKPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    cell.style = style;
    cell.confirmStyle = confirmStyle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    // Set up layout constraints base on styles
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[c]|" options:0 metrics:nil views:@{@"c" : cell.contentView}]];
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // We update the layout constraints via KVO
    if (CKPasswordCellCreateStyle == style) {
        cell.currentPasswordTextField.hidden = YES;
    }
    
    if (CKConfirmPasswordShowWhenSatisfyStyle == confirmStyle) {
        cell.confirmPasswordTextField.hidden = YES;
    } else if (CKConfirmPasswordLockUntilSatisfy == confirmStyle) {
        cell.confirmPasswordTextField.enabled = NO;
    }
    
    
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.confirmPasswordTextField removeObserver:self forKeyPath:@"hidden"];
    [self.currentPasswordTextField removeObserver:self forKeyPath:@"hidden"];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.currentPasswordTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:self.passwordTextField
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        [weakSelf textFieldDidChange:note.object];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:self.confirmPasswordTextField
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
     {
         [weakSelf textFieldDidChange:note.object];
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:self.currentPasswordTextField
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
     {
         [weakSelf textFieldDidChange:note.object];
     }];
    
    [self.confirmPasswordTextField addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPasswordTextField addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)prepareForReuse {
//    self.currentPasswordTopLayout.constant = 7;
//    self.currentPasswordHeightLayout.constant = 30;
    self.currentPasswordTextField.hidden = NO;
    
    self.passwordTopLayout.constant = 8;
    
//    self.confirmPasswordTopLayout.constant = 8;
//    self.confirmPasswordHeightLayout.constant = 30;
//    self.confirmPasswordBottomLayout.constant = 6;
    self.confirmPasswordTextField.hidden = NO;
    
}



- (void)setStyle:(CKPasswordCellStyle)style {
    _style = style;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -

- (void)updateWithCurrentPassword:(NSString *)currentPassword
                         password:(NSString *)password
                  confirmPassword:(NSString *)confirmPassword
                     editingBlock:(CKPasswordCellEditingBlock)editingBlock
                  validatingBlock:(CKPasswordCellValidatingBlock)validtingBlock {
    
    self.currentPasswordTextField.text = currentPassword;
    self.passwordTextField.text = password;
    self.confirmPasswordTextField.text = confirmPassword;
    self.editingBlock = editingBlock;
    self.validatingBlock = validtingBlock;
    
    if (CKConfirmPasswordShowWhenSatisfyStyle == self.confirmStyle) {
        if (self.validatingBlock(password) && self.confirmPasswordTextField.hidden == YES) {
            self.confirmPasswordTextField.hidden = NO;
        } else if (self.validatingBlock(password) && self.confirmPasswordTextField.hidden == NO) {
            self.confirmPasswordTextField.hidden = YES;
        }
    }
    
}

- (CGFloat)height {
    
    [self updateConstraints];
    [self layoutIfNeeded];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return height;
    
}

#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.editingBlock) {
        self.editingBlock(self, textField);
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (self.editingBlock) {
        self.editingBlock(self, textField);
    }
    
    NSString *text = textField.text;
    
    if (textField == self.currentPasswordTextField) {
        
    } else if (textField == self.passwordTextField) {
        
        if (self.passwordValidationsBlock && self.validationsUpdatingBlock) {
            NSArray *validations = self.passwordValidationsBlock(text);
            self.validationsUpdatingBlock(validations, textField);
        }
        
        
        if (CKConfirmPasswordShowWhenSatisfyStyle == self.confirmStyle) {
            
            if ((self.validatingBlock(text) && self.confirmPasswordTextField.hidden == YES)
                || (!self.validatingBlock(text) && self.confirmPasswordTextField.hidden == NO)) {
                if (self.satisfyBlock) {
                    self.satisfyBlock(textField);
                }
            }
        } else if (CKConfirmPasswordLockUntilSatisfy == self.confirmStyle) {
            self.confirmPasswordTextField.enabled = self.validatingBlock(text);
        }
        
    } else if (textField == self.confirmPasswordTextField) {
        if (self.confirmPasswordValidationsBlock && self.validationsUpdatingBlock) {
            NSArray *validations = self.confirmPasswordValidationsBlock(self.passwordTextField.text, text);
            self.validationsUpdatingBlock(validations, textField);
        }
    }
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.confirmPasswordTextField && [keyPath isEqual:@"hidden"]) {
        if ([change[NSKeyValueChangeNewKey] isEqual:@YES]) {
            self.confirmPasswordTopLayout.constant = self.confirmPasswordBottomLayout.constant;
            self.confirmPasswordHeightLayout.constant = 0;
            self.confirmPasswordBottomLayout.constant = 0;
        } else {
            self.confirmPasswordTopLayout.constant = 8;
            self.confirmPasswordHeightLayout.constant = 30;
            self.confirmPasswordBottomLayout.constant = 6;
        }
    } else if (object == self.currentPasswordTextField && [keyPath isEqual:@"hidden"]) {
        if ([change[NSKeyValueChangeNewKey] isEqual:@YES]) {
            self.passwordTopLayout.constant = self.currentPasswordTopLayout.constant;
            self.currentPasswordTopLayout.constant = 0;
            self.currentPasswordHeightLayout.constant = 0;
        } else {
            self.currentPasswordTopLayout.constant = 7;
            self.currentPasswordHeightLayout.constant = 30;
            self.passwordTopLayout.constant = 8;

        }
    }
}

@end
