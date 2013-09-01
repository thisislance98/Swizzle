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
@property (nonatomic) SlotItemType slotItemType;

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
    _scrollImages = @[[UIImage imageNamed:@"bone_slot"],
                      [UIImage imageNamed:@"ball_slot"],
                      [UIImage imageNamed:@"3bone_slot"],
                      [UIImage imageNamed:@"squirrel_slot"],
                      [UIImage imageNamed:@"collar_slot"],
                      [UIImage imageNamed:@"cat_slot"]];
    
    self.showsVerticalScrollIndicator = NO;
    self.userInteractionEnabled = NO;
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
    self.contentOffset = CGPointMake(0, ([_scrollImages count]+([_scrollImages count]-1))*kImageHeight);
}

- (void)spinToSlotType:(SlotItemType)slotType delay:(NSTimeInterval)delay
{
    _slotItemType = slotType;
    [self animateWithCount:5 delay:delay];
}

- (void)animateWithCount:(int)count delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:0.2
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         if (count == 0)
         {
             self.contentOffset = CGPointMake(0, (_slotItemType)*kImageHeight);
         }
         else
         {
             self.contentOffset = CGPointMake(0, ([_scrollImages count]-1)*kImageHeight);
         }
         
     } completion:^(BOOL finished)
     {
         if (count != 0)
         {
             self.contentOffset = CGPointMake(0, ([_scrollImages count]+([_scrollImages count]-1))*kImageHeight);
             [self animateWithCount:(count - 1) delay:0];
         }
         else
         {
             [_slotDelegate slotViewDidFinishAnimation];
         }
         
     }];
    
}

- (void)addImage:(UIImage*)image atPosition:(int)position
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, position*(kImageHeight), kImageWidth, kImageHeight);
    [self addSubview:imageView];
}

@end
