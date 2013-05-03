//
//  LetterButton.m
//  Swizzle
//
//  Created by Lance Hughes on 4/15/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "LetterButton.h"

@implementation LetterButton

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.startFrame = self.frame;
    
    return self;
}

@end
