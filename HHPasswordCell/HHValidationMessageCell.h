//
//  HHValidationMessageCell.h
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VALIDATION_GREEN [UIColor colorWithRed:0x46/255.0 green:0x88/255.0 blue:0x43/255.0 alpha:1]
#define VALIDATION_RED [UIColor colorWithRed:0xd9/255.0 green:0/255.0 blue:0/255.0 alpha:1]

@interface HHValidationMessageCell : UITableViewCell

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *validations;
@property (strong, nonatomic) UIColor *validColor;
@property (strong, nonatomic) UIColor *invalidColor;

+ (instancetype)cellWithIdentifier:(NSString *)identifier
                         tableView:(UITableView *)tableView
                       validations:(NSArray *)validations
                        validColor:(UIColor *)validColor
                      invalidColor:(UIColor *)invalidColor;

- (CGFloat)height;

@end
