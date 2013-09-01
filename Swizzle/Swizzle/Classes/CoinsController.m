//
//  ScoreController.m
//  Swizzle
//
//  Created by Lance Hughes on 4/15/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "CoinsController.h"

@implementation CoinsController

#define DEFAULT_COINS 10

static CoinsController* sharedController;


+(CoinsController*)sharedController
{
    if (sharedController == nil)
    {
        sharedController = [[CoinsController alloc] init];

    }
    
    return sharedController;
}

-(id)init
{
    self = [super init];
    
    if (self != nil)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CoinsSet"] == nil)
        {
            self.coins = DEFAULT_COINS;
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.coins forKey:@"Coins"];
            [[NSUserDefaults standardUserDefaults] setObject:@"set" forKey:@"CoinsSet"];
        }
        else
            self.coins = [[NSUserDefaults standardUserDefaults] integerForKey:@"Coins"];
    }
    
    return self;
}


-(NSString*)coinsString
{
    return [NSString stringWithFormat:@"%d",self.coins];
}

-(BOOL)buyForAmount:(int)amount labelToUpdate:(UILabel*)label
{
    if (amount <= self.coins)
    {
        [self decreaseCoins:amount labelToUpdate:label];

        return YES;
    }
    
    return NO;
}

-(void)increaseCoins:(int)increase labelToUpdate:(UILabel*)label
{
    self.coins += increase;
    
    if (label != nil)
        label.text = [self coinsString];
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.coins forKey:@"Coins"];
}

-(void)decreaseCoins:(int)decrease labelToUpdate:(UILabel*)label
{
    self.coins -= decrease;
    
    if (label != nil)
        label.text = [self coinsString];
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.coins forKey:@"Coins"];
}

@end
