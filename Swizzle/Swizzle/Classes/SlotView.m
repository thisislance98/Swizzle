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
@property (nonatomic, strong) NSMutableArray *visibleImages;
@property (nonatomic, strong) UIView *containerView;
@property NSUInteger imageIndex;

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
    _visibleImages = [NSMutableArray array];
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds),1000);
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    
    _containerView = [[UIView alloc] init];
    _containerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self addSubview:_containerView];
    _containerView.userInteractionEnabled = NO;
    
}

- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0))
    {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (UIImageView *imageView in _visibleImages)
        {
            CGPoint center = [_containerView convertPoint:imageView.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            imageView.center = [self convertPoint:center toView:_containerView];
            imageView.image = [self imageForYPos:imageView.frame.origin.y];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:_containerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    [self imagesFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
}

- (void)imagesFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY {
    
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleImages count] == 0)
    {
        [self placeNewImageOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on top side
    UIImageView *lastImageView = [_visibleImages lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastImageView frame]);
    while (bottomEdge < maximumVisibleY)
    {
        bottomEdge = [self placeNewImageOnBottom:bottomEdge];
    }
    
    // add labels that are missing on bottom side
    UIImageView *firstImageView = [_visibleImages objectAtIndex:0];
    CGFloat topEdge = CGRectGetMinY([firstImageView frame]);
    while (topEdge > minimumVisibleY)
    {
        topEdge = [self placeNewImageOnTop:topEdge];
    }
    
    // remove labels that have fallen off right edge
    lastImageView = [_visibleImages lastObject];
    while ([lastImageView frame].origin.y > maximumVisibleY)
    {
        [lastImageView removeFromSuperview];
        [_visibleImages removeLastObject];
        lastImageView = [_visibleImages lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstImageView = [_visibleImages objectAtIndex:0];
    while (CGRectGetMaxY([firstImageView frame]) < minimumVisibleY)
    {
        [firstImageView removeFromSuperview];
        [_visibleImages removeObjectAtIndex:0];
        firstImageView = [_visibleImages objectAtIndex:0];
    }
}
- (UIImageView *)insertImageAtYPos:(CGFloat)yPos
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageForYPos:yPos]];
    imageView.frame = CGRectMake(0, yPos, kImageWidth, kImageHeight);
    [_containerView addSubview:imageView];
    return imageView;
}

- (UIImage *)imageForYPos:(CGFloat)yPos
{
    NSLog(@"ypos:%f , ratio: %f",yPos ,(yPos  / kImageHeight));
    int index = yPos / kImageHeight;
    index %= _scrollImages.count;
    NSLog(@"index: %d",index);
    return _scrollImages[index];
}

- (CGFloat)placeNewImageOnBottom:(CGFloat)bottomEdge
{
    UIImageView *imageView = [self insertImageAtYPos:bottomEdge];
    [_visibleImages addObject:imageView]; // add rightmost label at the end of the array
    return CGRectGetMaxY(imageView.frame);
}

- (CGFloat)placeNewImageOnTop:(CGFloat)topEdge
{
    UIImageView *imageView = [self insertImageAtYPos:(topEdge - kImageHeight)];
    [_visibleImages insertObject:imageView atIndex:0]; // add leftmost label at the beginning of the array
    return CGRectGetMinY(imageView.frame);
}

@end
