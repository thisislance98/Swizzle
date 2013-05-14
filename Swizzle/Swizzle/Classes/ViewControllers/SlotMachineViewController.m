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
{
    UIButton *_playButton;
    BOOL _playing;
}

@property (nonatomic)  NSInteger coins;
@property (nonatomic)  BOOL didWin;

@property (nonatomic, strong) SlotMachine *slotMachine;

@property (weak, nonatomic) IBOutlet UIImageView *leverImage;
@property (weak, nonatomic) IBOutlet UIImageView *doggy;
@property (weak, nonatomic) IBOutlet UIImageView *pipe;
@property (weak, nonatomic) IBOutlet UIImageView *bowl;
@property (weak, nonatomic) IBOutlet UILabel *bonesLabel;

@end

@implementation SlotMachineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _slotMachine = [[SlotMachine alloc] init];
    self.coins = 100;
    [self.bonesLabel setFont:[UIFont fontWithName:@"Luckiest Guy" size:24]];
    _bonesLabel.text = [NSString stringWithFormat:@"%d",_coins];
    
    [self animateDogIdle];
}

- (void)play
{
    _didWin = [_slotMachine playWithCoins:&_coins];
    
    for (int i = 0; i < _slotMachine.resultSlots.count; i++)
    {
        SlotItemType slotItemType = [_slotMachine.resultSlots[i] integerValue];
        SlotView *slotView = (SlotView *)[self.view viewWithTag:(i+1)];
        [slotView spinToSlotType:slotItemType delay:(1 * 0.15)];
        
        if (i == 2)
        {
            slotView.slotDelegate = self;
        }
    }
}

- (IBAction)playTapped:(id)sender
{
    if (_playing) return;
    
    _playing = YES;
    
    _playButton = sender;
    _playButton.userInteractionEnabled = NO;
    [self play];
    [self animateLever];
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

- (void)slotViewDidFinishAnimation
{
    [_playButton performSelector:@selector(setUserInteractionEnabled:) withObject:@(YES) afterDelay:2.0f];
    
    (_didWin) ? [self animateWin] : [self animateLoss];
    
    _bonesLabel.text = [NSString stringWithFormat:@"%d",_coins];
    _playing = NO;
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

@end
