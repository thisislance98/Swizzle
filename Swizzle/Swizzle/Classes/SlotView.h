//
//  SlotView.h
//  Swizzle
//
//  Created by Sami Aref on 4/17/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlotMachine.h"

@interface SlotView : UIScrollView

- (void)spinToSlotType:(SlotItemType)slotType delay:(NSTimeInterval)delay;

@end
