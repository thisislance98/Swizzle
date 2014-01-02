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
        [self increaseCoins:-amount labelToUpdate:label];

        return YES;
    }
    
    return NO;
}

-(void)increaseCoins:(int)increase labelToUpdate:(UILabel*)label
{

    updatingLabel = label;
    
    if (increase == 0)
        return;

    float increment = increase/ABS(increase);
 
    
    for (int i=0; ABS(i) < ABS(increase); i += increment)
    {
        

        [self performSelector:@selector(increaseCoins:) withObject:@(increment) afterDelay:ABS(i) / 20.0];
        
        
    }
    
}

-(void)increaseCoins:(NSNumber*)increase
{
    self.coins += increase.intValue;
    
    if (updatingLabel != nil)
        updatingLabel.text = [self coinsString];
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.coins forKey:@"Coins"];
}


@end
