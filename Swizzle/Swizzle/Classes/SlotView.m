//
//  SlotView.m
//  Swizzle
//
//  Created by Sami Aref on 4/17/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "SlotView.h"

static CGFloat kImageHeight = 66.0f;
static CGFloat kImageWidth = 87.0f;

@interface SlotView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *scrollImages;

@end

@implementation SlotView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
        
    }
    return self;
}

- (void)initialize
{
    _scrollImages = @[[UIImage imageNamed:@"bone_slot"],[UIImage imageNamed:@"ball_slot"],[UIImage imageNamed:@"3bone_slot"],[UIImage imageNamed:@"squirrel_slot"],[UIImage imageNamed:@"collar_slot"],[UIImage imageNamed:@"cat_slot"]];
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds),1000);
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    
    for (int i =0; i < [_scrollImages count]; i++) {
        [self addImage:_scrollImages[i] atPosition:i];
    }
    for (int i =0; i < [_scrollImages count]; i++) {
        [self addImage:_scrollImages[i] atPosition:i+[_scrollImages count]];
    }
    for (int i =0; i < [_scrollImages count]; i++) {
        [self addImage:_scrollImages[i] atPosition:i+2*[_scrollImages count]];
    }
    
    self.contentSize = CGSizeMake(kImageWidth, (3*[_scrollImages count])* kImageHeight);
    [self scrollRectToVisible:CGRectMake(0,kImageHeight,kImageWidth,kImageWidth) animated:NO];
}

- (void)spin
{
    [UIView animateWithDuration:3.0f animations:^{
       [self setContentOffset:CGPointMake(0, kImageHeight * 3) animated:YES];
    }];
   
}

- (void)addImage:(UIImage*)image atPosition:(int)position
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, position*(kImageHeight), kImageWidth, kImageHeight);
    [self addSubview:imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.contentOffset.y <=([_scrollImages count]-1)*kImageHeight)
    {
        [self setContentOffset:CGPointMake(0,([_scrollImages count]+([_scrollImages count]-1))*kImageHeight)];
    }
    else if (self.contentOffset.y >=(2*([_scrollImages count]))*kImageHeight)
    {
        [self setContentOffset:CGPointMake(0,([_scrollImages count])*kImageHeight)];
    }
}

@end
