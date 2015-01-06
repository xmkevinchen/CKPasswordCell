//
//  HHPasswordValidator.h
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, HHPasswordValidation) {
    HHPasswordValidationSuccess = 1 << 0,
    HHPasswordValidationLengthInvalid = 1 << 1,
    HHPasswordValidationNeedsUpperCase = 1 << 2,
    HHPasswordValidationNeedsLowerCase = 1 << 3,
    HHPasswordValidationNeedsNumber = 1 << 4,
    HHPasswordValidationNeedsSpecialCharacter = 1 << 5
};

@interface HHPasswordValidator : NSObject

+ (HHPasswordValidation)validateWithPassword:(NSString *)password;

+ (NSArray *)messagesFromValiationResults:(HHPasswordValidation)results;

@end
