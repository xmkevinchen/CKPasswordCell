//
//  HHValidationMessageCell.m
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "HHValidationMessageCell.h"
#import "HHValidationMessage.h"



@interface HHValidationInnerMessageCell : UITableViewCell

@property (strong, nonatomic) HHValidationMessage *message;
@property (strong, nonatomic) UIImageView *checkmarkImageView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIImage *imgOK;
@property (strong, nonatomic) UIImage *imgError;

@end

@implementation HHValidationInnerMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
    }
    
    return self;
}

- (void)_init {
    self.checkmarkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.checkmarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.checkmarkImageView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[v(16)]" options:0 metrics:nil views:@{@"v" : self.checkmarkImageView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[v(16)]" options:0 metrics:nil views:@{@"v" : self.checkmarkImageView}]];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:14.0];
    self.messageLabel.font = [UIFont systemFontOfSize:14.0f];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[c]-10-[m]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"c" : self.checkmarkImageView, @"m" : self.messageLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[m]-5-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"m" : self.messageLabel}]];
    
    [self updateConstraints];
    [self layoutIfNeeded];
}

- (UIImage *)imgOK {
    if (_imgOK == nil) {
        _imgOK = [UIImage imageNamed:@"pwd_ok"];
    }
    
    return _imgOK;
}

- (UIImage *)imgError {
    if (_imgError == nil) {
        _imgError = [UIImage imageNamed:@"pwd_error"];
    }
    
    return _imgError;
}

- (void)setMessage:(HHValidationMessage *)message {
    _message = message;
    
    if (message.isValid) {
        self.checkmarkImageView.image = self.imgOK;
    } else {
        self.checkmarkImageView.image = self.imgError;
    }
    
    self.messageLabel.textColor = message.isValid ? VALIDATION_GREEN : VALIDATION_RED;
    self.messageLabel.text = message.message;
}

@end

@interface HHValidationMessageCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HHValidationMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
    }
    
    return self;
}


- (void)_init {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.scrollEnabled = NO;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.allowsSelection = NO;
    
    [self.contentView addSubview:self.tableView];
    
    // Setup constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[v]-|" options:0 metrics:nil views:@{@"v" : self.tableView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]-|" options:0 metrics:nil views:@{@"v" : self.tableView}]];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[HHValidationInnerMessageCell class] forCellReuseIdentifier:@"HHValidationInnerMessageCell"];
    
    [self addObserver:self forKeyPath:@"validations" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"validations"];
}

+ (instancetype)cellWithIdentifier:(NSString *)identifier
                         tableView:(UITableView *)tableView
                       validations:(NSArray *)validations
                        validColor:(UIColor *)validColor
                      invalidColor:(UIColor *)invalidColor {
    
    HHValidationMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell) {
        cell.validations = validations;
        cell.validColor = validColor;
        cell.invalidColor = invalidColor;
    }
    
    return cell;
}

- (CGFloat) height {
    [self updateConstraints];
    [self layoutIfNeeded];
    CGFloat height = 8 + self.tableView.contentSize.height;
    
    return height;
        
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.validations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHValidationInnerMessageCell *cell = (HHValidationInnerMessageCell *)[tableView dequeueReusableCellWithIdentifier:@"HHValidationInnerMessageCell"];
    HHValidationMessage *message = self.validations[indexPath.row];
    
//    UIColor *validColor = self.validColor ? self.validColor : VALIDATION_GREEN;
//    UIColor *invalidColor = self.invalidColor ? self.invalidColor : VALIDATION_RED;
    
    cell.message = message;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHValidationInnerMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHValidationInnerMessageCell"];
    HHValidationMessage *message = self.validations[indexPath.row];
    
    cell.message = message;
    
    [cell updateConstraints];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    return MAX(height, 30);
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self && [keyPath isEqual:@"validations"]) {
        [self.tableView reloadData];
    }
}

@end
