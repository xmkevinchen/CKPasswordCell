//
//  CKPasswordValidation.h
//  CKPasswordCell
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CKPasswordValidation) {
    CKPasswordValidationSuccess = 1 << 0,
    CKPasswordValidationLengthInvalid = 1 << 1,
    CKPasswordValidationNeedsUpperCase = 1 << 2,
    CKPasswordValidationNeedsLowerCase = 1 << 3,
    CKPasswordValidationNeedsNumber = 1 << 4,
    CKPasswordValidationNeedsSpecialCharacter = 1 << 5
};

@interface CKPasswordValidator : NSObject

+ (CKPasswordValidation)validateWithPassword:(NSString *)password;

+ (NSArray *)messagesFromValiationResults:(CKPasswordValidation)results;
+ (NSArray *)confirmMessagesWithPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword;

@end
