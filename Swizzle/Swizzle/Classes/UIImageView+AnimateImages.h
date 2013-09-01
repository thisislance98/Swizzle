//
//  UIImageView+AnimateImages.h
//  Swizzle
//
//  Created by Sami Aref on 5/30/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AnimateImages)

- (void)animateWithImages:(NSArray *)images duration:(NSTimeInterval)duration;
- (void)animateWithImages:(NSArray *)images duration:(NSTimeInterval)duration looping:(BOOL)looping;

+ (NSArray *)imagesFromName:(NSString *)name count:(NSInteger)count zeroBased:(BOOL)zeroBased;
+ (NSArray *)imagesFromName:(NSString *)name count:(NSInteger)count;


@end
