//
//  SlotView.h
//  Swizzle
//
//  Created by Sami Aref on 4/17/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlotMachine.h"

@protocol SlotViewDelegate <NSObject>

- (void)slotViewDidFinishAnimation;

@end

@interface SlotView : UIScrollView

@property (nonatomic, assign) id<SlotViewDelegate> slotDelegate;

- (void)spinToSlotType:(SlotItemType)slotType delay:(NSTimeInterval)delay;

@end
