//
//  UIImageView+AnimateImages.m
//  Swizzle
//
//  Created by Sami Aref on 5/30/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "UIImageView+AnimateImages.h"

@implementation UIImageView (AnimateImages)

- (void)animateWithImages:(NSArray *)images
                duration:(NSTimeInterval)duration
{
    [self setAnimationImages:images];
    
    [self setAnimationDuration:duration];
    self.animationRepeatCount = 1;
    
    [self startAnimating];
}

+ (NSArray *)imagesFromName:(NSString *)name count:(NSInteger)count
{
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++)
    {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%.2d",name,i+1]]];
    }
    
    return images;
}

@end
