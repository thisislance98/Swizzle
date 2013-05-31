//
//  SlotMachineViewController.m
//  Swizzle
//
//  Created by Sami Aref on 4/16/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "SlotMachineViewController.h"
#import "SlotMachine.h"
#import "CoinsController.h"
#import "UIImageView+AnimateImages.h"
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
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *pipe;
@property (weak, nonatomic) IBOutlet UIImageView *bowl;
@property (weak, nonatomic) IBOutlet UILabel *bonesLabel;

@end

@implementation SlotMachineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self readjustHeightForiPhone5];
    
    _slotMachine = [[SlotMachine alloc] init];
    self.coins = [CoinsController sharedController].coins;
    [self.bonesLabel setFont:[UIFont fontWithName:@"Luckiest Guy" size:24]];
    _bonesLabel.text = [NSString stringWithFormat:@"%d",_coins];
    
    [self animateDogIdle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)readjustHeightForiPhone5
{
    if (self.view.frame.size.height > 480)
    {
        for (UIView *view in self.view.subviews)
        {
            if (view != _bgView)
            {
                view.center = CGPointMake(view.center.x, view.center.y + 40.0f);
            }
        }
    }
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
    [_leverImage animateWithImages:[UIImageView imagesFromName:@"lever" count:5]
                  duration:0.31f];
}

- (void)animateDogIdle
{
    [_doggy animateWithImages:[UIImageView imagesFromName:@"idle_slots_" count:4]
                  duration:0.31f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:0.31f];
}

- (void)animateDogHappy
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateDogIdle) object:nil];
    
    [_doggy animateWithImages:[UIImageView imagesFromName:@"happy_slots_" count:11]
                  duration:2.0f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:2.0f];
}

- (void)animatePipe
{
    [_pipe animateWithImages:[UIImageView imagesFromName:@"pipe_bones_" count:6]
                  duration:0.7f];
}

- (void)animateBowl
{
    [_bowl animateWithImages:[UIImageView imagesFromName:@"bowl" count:5]
                  duration:0.7f];
}

- (void)animateDogSad
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateDogIdle) object:nil];
    
    [_doggy animateWithImages:[UIImageView imagesFromName:@"sad_slots_" count:11]
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
    [self performSelector:@selector(goBackToMainViewController) withObject:nil afterDelay:2.0f];
    
    (_didWin) ? [self animateWin] : [self animateLoss];
    
    _bonesLabel.text = [NSString stringWithFormat:@"%d",_coins];
    _playing = NO;
}

- (void)goBackToMainViewController
{
    [CoinsController sharedController].coins = self.coins;
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
