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

@interface SlotMachineViewController ()<SlotViewDelegate>

@property (nonatomic)  NSInteger coins;
@property (nonatomic, strong) SlotMachine *slotMachine;
@property (weak, nonatomic) IBOutlet UIImageView *leverImage;
@property (weak, nonatomic) IBOutlet UIImageView *doggy;
@property (weak, nonatomic) IBOutlet UIImageView *pipe;
@property (weak, nonatomic) IBOutlet UIImageView *bowl;

@end

@implementation SlotMachineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _slotMachine = [[SlotMachine alloc] init];
    self.coins = 100;
    
    [self animateDogIdle];
}

- (void)playAndSetLabels
{
    NSArray *slots = [_slotMachine playWithCoins:&_coins];
    self.coins = _coins;
    
    for (int i = 0; i < slots.count; i++)
    {
        SlotItemType slotItemType = [slots[i] integerValue];
        SlotView *slotView = (SlotView *)[self.view viewWithTag:(i+1)];
        [slotView spinToSlotType:slotItemType delay:(1 * 0.15)];
        if (i == 2)
        {
            slotView.slotDelegate = self;
        }
    }
}

- (void)setCoins:(NSInteger)coins
{
    _coins = coins;
}

- (IBAction)playTapped:(id)sender
{
    [self animateLever];
    [self playAndSetLabels];
}

- (void)animateImageView:(UIImageView *)imageView
              WithImages:(NSArray *)images
                duration:(NSTimeInterval)duration
{
    [imageView setAnimationImages:images];
    
    [imageView setAnimationDuration:duration];
    imageView.animationRepeatCount = 1;
    
    [imageView startAnimating];
}

- (NSArray *)imagesFromName:(NSString *)name count:(NSInteger)count
{
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++)
    {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%.2d",name,i+1]]];
    }
    
    return images;
}

- (void)animateLever
{
    [self animateImageView:_leverImage
                WithImages:[self imagesFromName:@"lever" count:5]
                  duration:0.31f];
}

- (void)animateDogIdle
{
    [self animateImageView:_doggy
                WithImages:[self imagesFromName:@"idle_slots_" count:4]
                  duration:0.31f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:0.31f];
}

- (void)animateDogHappy
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self animateImageView:_doggy
                WithImages:[self imagesFromName:@"happy_slots_" count:11]
                  duration:2.0f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:2.0f];
}

- (void)animatePipe
{
    [self animateImageView:_pipe
                WithImages:[self imagesFromName:@"pipe_bones_" count:6]
                  duration:0.7f];
}

- (void)animateBowl
{
    [self animateImageView:_bowl
                WithImages:[self imagesFromName:@"bowl" count:5]
                  duration:0.7f];
}

- (void)animateDogSad
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self animateImageView:_doggy
                WithImages:[self imagesFromName:@"sad_slots_" count:11]
                  duration:2.0f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:2.0f];
}

- (void)slotViewDidFinishAnimation
{
    (arc4random_uniform(2) == 0) ?  [self animateWin]: [self animateLoss];
}

- (void)animateWin
{
    [self animateDogHappy];
    [self animateBowl];
    [self animatePipe];
}

- (void)animateLoss
{
    [self animateDogSad];
}



@end
