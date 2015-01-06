//
//  HHValidationMessage.h
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHValidationMessage : NSObject

@property (assign, nonatomic, getter=isValid) BOOL valid;
@property (copy, nonatomic) NSString *message;

- (instancetype)initWithMessage:(NSString *)message
                          isValid:(BOOL)isValid;

@end
