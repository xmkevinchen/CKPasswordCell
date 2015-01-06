//
//  HHPasswordValidator.m
//  HHPasswordCell
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "HHPasswordValidator.h"
#import "HHValidationMessage.h"

@implementation HHPasswordValidator

+ (HHPasswordValidation)validateWithPassword:(NSString *)password {
    if (password.length == 0) {
        return HHPasswordValidationLengthInvalid
                | HHPasswordValidationNeedsUpperCase
                | HHPasswordValidationNeedsLowerCase
                | HHPasswordValidationNeedsNumber
                | HHPasswordValidationNeedsSpecialCharacter;
    }
    
    NSCharacterSet *specialCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSCharacterSet *numericSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *uppercaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *lowercaseSet = [NSCharacterSet lowercaseLetterCharacterSet];
    BOOL foundSpecialCharacters = ([password rangeOfCharacterFromSet:specialCharacters].location != NSNotFound) ? YES : NO;
    BOOL foundNumericSet = ([password rangeOfCharacterFromSet:numericSet].location != NSNotFound) ? YES : NO;
    BOOL foundUppercase = ([password rangeOfCharacterFromSet:uppercaseSet].location != NSNotFound) ? YES : NO;
    BOOL foundLowercase = ([password rangeOfCharacterFromSet:lowercaseSet].location != NSNotFound) ? YES : NO;
    BOOL correctLength = (password.length >= 8 && password.length <= 32) ? YES : NO;
    BOOL isValid = (foundSpecialCharacters && foundNumericSet && foundUppercase && correctLength && foundLowercase);
    HHPasswordValidation result = 0;
    if (isValid) {
        return HHPasswordValidationSuccess;
    } else {
        if (!foundUppercase) {
            result |= HHPasswordValidationNeedsUpperCase;
        }
        
        if (!foundLowercase) {
            result |= HHPasswordValidationNeedsLowerCase;
        }
        
        if (!foundSpecialCharacters) {
            result |= HHPasswordValidationNeedsSpecialCharacter;
        }
        
        if (!foundNumericSet) {
            result |= HHPasswordValidationNeedsNumber;
        }
        
        if (!correctLength) {
            result |= HHPasswordValidationLengthInvalid;
        }
        
        return result;
    }

}

+ (NSArray *)messagesFromValiationResults:(HHPasswordValidation)results {
    
    NSMutableArray *validations = [NSMutableArray array];
    
    // At least 1 upper-case character
    if ((results & HHPasswordValidationLengthInvalid) == HHPasswordValidationLengthInvalid) {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"8 to 32 characters" isValid:NO]];
    } else {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"8 to 32 characters" isValid:YES]];
    }
    
    // At least 1 upper-case character
    if ((results & HHPasswordValidationNeedsUpperCase) == HHPasswordValidationNeedsUpperCase) {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 upper-case character" isValid:NO]];
    } else {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 upper-case character" isValid:YES]];
    }
    
    // At least 1 lower-case character
    if ((results & HHPasswordValidationNeedsLowerCase) == HHPasswordValidationNeedsLowerCase) {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 lower-case character" isValid:NO]];
    } else {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 lower-case character" isValid:YES]];
    }
    
    // At least 1 number
    if ((results & HHPasswordValidationNeedsNumber) == HHPasswordValidationNeedsNumber) {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 number" isValid:NO]];
    } else {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 number" isValid:YES]];
    }
    
    // At least 1 special character
    if ((results & HHPasswordValidationNeedsSpecialCharacter) == HHPasswordValidationNeedsSpecialCharacter) {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 special character\n    ! @ # $ % ^ & ( ) < > ? / \\" isValid:NO]];
    } else {
        [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"At least 1 special character\n    ! @ # $ % ^ & ( ) < > ? / \\" isValid:YES]];
    }
    
    return validations;
    
}

+ (NSArray *)confirmMessagesWithPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword {
    NSMutableArray *validations = [NSMutableArray array];
    [validations addObject:[[HHValidationMessage alloc] initWithMessage:@"Password confirme"
                                                                isValid:(password && [password isEqual:confirmPassword])]];
    return validations;
}

@end
