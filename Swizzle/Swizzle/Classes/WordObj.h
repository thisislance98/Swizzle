//
//  WordObj.h
//  Swizzle
//
//  Created by Lance Hughes on 4/14/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordObj : NSObject
{
    
}

@property (nonatomic,strong) NSArray* hints;
@property (nonatomic,strong) NSString* word;

-(id)initWithWord:(NSString*)word andHints:(NSArray*)hints;

@end
