//
//  SlotView.m
//  Swizzle
//
//  Created by Sami Aref on 4/17/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "SlotView.h"

static CGFloat kImageHeight = 66.0f;

@interface SlotView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *scrollImageViews;


@end

@implementation SlotView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollImageViews = @[
                              [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bone_slot"]],
                              [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball_slot"]],
                              [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat_slot"]],
                              [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"collar_slot"]],
                              [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"squirrel_slot"]],
                              [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3bone_slot"]]
                              ];
        
        CGFloat yPos = 0;
        for (UIView *view in _scrollImageViews)
        {
            view.contentMode = UIViewContentModeScaleAspectFit;
            view.frame = CGRectMake(0, yPos, CGRectGetWidth(self.bounds), kImageHeight);
            yPos = CGRectGetMaxY(view.frame);
            [_scrollView addSubview:view];
        }
        
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds),(kImageHeight * _scrollImageViews.count));
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        
        [self addSubview:_scrollView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
