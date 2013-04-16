//
//  SlotMachine.h
//  Swizzle
//
//  Created by Sami Aref on 4/16/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int NUMBER_OF_SLOTS = 3;

typedef enum
{
    SlotItemTypeCherry,
    SlotItemTypeSeven,
    SlotItemTypeDoubleSeven,
    SlotItemTypeBar,
    SlotItemTypeSmiley,
    SlotItemCOUNT
} SlotItemType;


@interface SlotMachine : NSObject

@property (nonatomic, strong) NSArray *slots;

+ (NSString *)nameForSlotType:(SlotItemType)type;

- (NSArray *)playWithCoins:(NSInteger *)coins;

@end
