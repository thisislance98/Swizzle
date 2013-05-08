//
//  SlotMachineViewController.m
//  Swizzle
//
//  Created by Sami Aref on 4/16/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "SlotMachineViewController.h"
#import "SlotMachine.h"
#import "SlotView.h"

@interface SlotMachineViewController ()

@property (nonatomic)  NSInteger coins;
@property (nonatomic, strong) SlotMachine *slotMachine;

@property (strong, nonatomic) IBOutletCollection(SlotView) NSArray *slots;


@end

@implementation SlotMachineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _slotMachine = [[SlotMachine alloc] init];
    self.coins = 100;
    
    [self playAndSetLabels];
}

- (void)playAndSetLabels
{
     NSArray *slots = [_slotMachine playWithCoins:&_coins];
    self.coins = _coins;
    
    for (int i = 0; i < slots.count; i++)
    {
        SlotItemType slotItemType = [slots[i] integerValue];
    }
}

- (void)setCoins:(NSInteger)coins
{
    _coins = coins;
}

- (IBAction)playTapped:(id)sender
{
 //   [self playAndSetLabels];
    [_slots makeObjectsPerformSelector:@selector(spin)];
}


@end
