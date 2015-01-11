//
//  CKPasswordValidator.m
//  CKPasswordCell
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "CKPasswordValidator.h"
#import "CKValidationMessage.h"

@implementation CKPasswordValidator

+ (CKPasswordValidation)validateWithPassword:(NSString *)password {
    if (password.length == 0) {
        return CKPasswordValidationLengthInvalid
                | CKPasswordValidationNeedsUpperCase
                | CKPasswordValidationNeedsLowerCase
                | CKPasswordValidationNeedsNumber
                | CKPasswordValidationNeedsSpecialCharacter;
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
    CKPasswordValidation result = 0;
    if (isValid) {
        return CKPasswordValidationSuccess;
    } else {
        if (!foundUppercase) {
            result |= CKPasswordValidationNeedsUpperCase;
        }
        
        if (!foundLowercase) {
            result |= CKPasswordValidationNeedsLowerCase;
        }
        
        if (!foundSpecialCharacters) {
            result |= CKPasswordValidationNeedsSpecialCharacter;
        }
        
        if (!foundNumericSet) {
            result |= CKPasswordValidationNeedsNumber;
        }
        
        if (!correctLength) {
            result |= CKPasswordValidationLengthInvalid;
        }
        
        return result;
    }

}

+ (NSArray *)messagesFromValiationResults:(CKPasswordValidation)results {
    
    NSMutableArray *validations = [NSMutableArray array];
    
    // At least 1 upper-case character
    if ((results & CKPasswordValidationLengthInvalid) == CKPasswordValidationLengthInvalid) {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"8 to 32 characters" isValid:NO]];
    } else {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"8 to 32 characters" isValid:YES]];
    }
    
    // At least 1 upper-case character
    if ((results & CKPasswordValidationNeedsUpperCase) == CKPasswordValidationNeedsUpperCase) {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 upper-case character" isValid:NO]];
    } else {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 upper-case character" isValid:YES]];
    }
    
    // At least 1 lower-case character
    if ((results & CKPasswordValidationNeedsLowerCase) == CKPasswordValidationNeedsLowerCase) {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 lower-case character" isValid:NO]];
    } else {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 lower-case character" isValid:YES]];
    }
    
    // At least 1 number
    if ((results & CKPasswordValidationNeedsNumber) == CKPasswordValidationNeedsNumber) {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 number" isValid:NO]];
    } else {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 number" isValid:YES]];
    }
    
    // At least 1 special character
    if ((results & CKPasswordValidationNeedsSpecialCharacter) == CKPasswordValidationNeedsSpecialCharacter) {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 special character\n    ! @ # $ % ^ & ( ) < > ? / \\" isValid:NO]];
    } else {
        [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"At least 1 special character\n    ! @ # $ % ^ & ( ) < > ? / \\" isValid:YES]];
    }
    
    return validations;
    
}

+ (NSArray *)confirmMessagesWithPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword {
    NSMutableArray *validations = [NSMutableArray array];
    [validations addObject:[[CKValidationMessage alloc] initWithMessage:@"Password confirme"
                                                                isValid:(password && [password isEqual:confirmPassword])]];
    return validations;
}

@end
