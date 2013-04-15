//
//  WordObj.m
//  Swizzle
//
//  Created by Lance Hughes on 4/14/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "WordObj.h"

@implementation WordObj

-(id)initWithWord:(NSString*)word andHints:(NSArray*)hints
{
    self = [super init];
    
    if (self != nil)
    {
        self.word = word;
        self.hints = [[NSArray alloc] initWithArray:hints];
    }
    
    return self;
}

@end
