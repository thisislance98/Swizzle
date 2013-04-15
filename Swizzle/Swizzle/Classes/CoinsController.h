//
//  CoinsController.h
//  Swizzle
//
//  Created by Lance Hughes on 4/15/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinsController : NSObject
{
    
}

@property (readwrite) int coins;

+(CoinsController*)sharedController;

-(BOOL)buyForAmount:(int)amount labelToUpdate:(UILabel*)label;

-(void)increaseCoins:(int)increase labelToUpdate:(UILabel*)label;
-(void)decreaseCoins:(int)decrease labelToUpdate:(UILabel*)label;

-(NSString*)coinsString;

@end
