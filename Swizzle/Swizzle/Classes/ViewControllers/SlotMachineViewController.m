//
//  SlotMachineViewController.m
//  Swizzle
//
//  Created by Sami Aref on 4/16/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "SlotMachineViewController.h"
#import "SlotMachine.h"

@interface SlotMachineViewController ()

@property (nonatomic)  NSInteger coins;
@property (nonatomic, strong) SlotMachine *slotMachine;

@property (weak, nonatomic) IBOutlet UIView *slotContainerView;
@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;

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
        UILabel *slotLabel = (UILabel *)[_slotContainerView viewWithTag:(i + 1)];
        slotLabel.text = [SlotMachine nameForSlotType:slotItemType];
    }
}

- (void)setCoins:(NSInteger)coins
{
    _coins = coins;
    _coinsLabel.text = [NSString stringWithFormat:@"%d",coins];
}

- (IBAction)playTapped:(id)sender
{
    [self playAndSetLabels];
}


@end
