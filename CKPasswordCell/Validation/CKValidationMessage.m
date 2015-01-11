//
//  CKValidationMessage.m
//  CKValidationMessage
//
//  Created by Kevin Chen on 1/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "CKValidationMessage.h"

@implementation CKValidationMessage

- (instancetype)initWithMessage:(NSString *)message
                        isValid:(BOOL)isValid {
    self = [super init];
    if (self) {
        self.message = message;
        self.valid = isValid;
    }
    
    return self;
}

- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"%@: %@", self.isValid ? @"Valid" : @"Invalid", self.message];
    return string;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (object == nil) return NO;
    if (![object isKindOfClass:[self class]]) return NO;
    
    return (self.isValid == [(CKValidationMessage *)object isValid])
    && ([self.message isEqual:[(CKValidationMessage *)object message]]);
    
}



@end
