//
//  SlotMachine.m
//  Swizzle
//
//  Created by Sami Aref on 4/16/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "SlotMachine.h"

@interface Slot : NSObject

@property (nonatomic, strong) NSArray *slotItems;
- (SlotItemType)randomSlotItem;

@end

@interface SlotMachine()
{
    NSArray *_slots;
}

@end


@implementation SlotMachine

- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *slots = [NSMutableArray arrayWithCapacity:NUMBER_OF_SLOTS];
        
        for (int i = 0; i < NUMBER_OF_SLOTS; i++)
        {
            [slots addObject:[[Slot alloc] init]];
        }
        
        _slots = slots;
    }
    
    return self;
}

+(NSString *)nameForSlotType:(SlotItemType)type
{
    switch (type)
    {
        case SlotItemTypeCherry:
            return @"Cherry";
        case SlotItemTypeDoubleSeven:
            return @"7 7";
        case SlotItemTypeSeven:
            return @"7";
        case SlotItemTypeTripleSeven:
            return @"7 7 7";
        case SlotItemTypeBar:
            return @"BAR";
        case SlotItemTypeSmiley:
            return @"=)";
        default:
            return @"UNKNOWN";
    }
}

- (BOOL)playWithCoins:(NSInteger *)coins
{
    if (*coins < 10) return nil;
    
    NSMutableArray *resultSlots = [NSMutableArray array];
    
    for (Slot *slot in _slots)
    {
        [resultSlots addObject:@([slot randomSlotItem])];
    }
    
    NSInteger amountWon  = [self amountFromSlots:resultSlots amount:*coins];
    BOOL didWin = (amountWon > *coins);
    
    *coins = amountWon;
    
    _resultSlots = resultSlots;
    return didWin;
}

- (NSInteger)amountFromSlots:(NSArray *)slotItems amount:(NSInteger)amount
{
    int addedAmount = 0;
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:slotItems];
    
    for (int i = SlotItemTypeCherry; i < SlotItemCOUNT; i++)
    {
        int count = [countedSet countForObject:@(i)];
        if (count == 3)
        {
            addedAmount = 1000;
            break;
        }
        if (count == 2)
        {
            addedAmount = 10;
            break;
        }
    }
    
    return (amount + addedAmount);
}


@end

@implementation Slot

- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *slotItems = [NSMutableArray arrayWithCapacity:SlotItemCOUNT];
        
        for (int i = SlotItemTypeCherry; i < SlotItemCOUNT; i++)
        {
            [slotItems addObject:@(i)];
        }
        
        _slotItems = slotItems;
        
    }
    return self;
}

- (SlotItemType)randomSlotItem
{
    int randomIndex = arc4random_uniform(SlotItemCOUNT);
    return [_slotItems[randomIndex] integerValue];
}

@end
