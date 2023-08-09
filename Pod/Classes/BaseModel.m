//
//  BaseModel.m
//  TOI
//
//  Created by Ravi Sahu on 09/10/13.
//  Copyright (c) 2013 Times Internet Limited. All rights reserved.
//

#import "BaseModel.h"
#import "NSObject+NSCoding.h"

@implementation BaseModel

- (void)encodeWithCoder:(NSCoder *)coder {
    [self autoEncodeWithCoder:coder];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        [self autoDecode:coder];
    }
    return self;
}

- (BOOL)beginContentAccess {
    return true;
}

- (void)discardContentIfPossible {}

- (void)endContentAccess {}

- (BOOL)isContentDiscarded {
    return [self isDataShouldDiscarded];
}

-(BOOL)isDataShouldDiscarded {
    return true;
}

+ (BOOL)supportsSecureCoding{
    return true;
}
@end
