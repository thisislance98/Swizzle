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
#import "AudioPlayer.h"

@interface SlotMachineViewController ()<SlotViewDelegate>
{
    UIButton *_playButton;
    BOOL _playing;
    AVAudioPlayer* _pantingPlayer;
    AVAudioPlayer* _winPlayer;
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
    
    _pantingPlayer = [[AudioPlayer sharedController] playSound:@"longPant" extension:@"wav"];
    _pantingPlayer.numberOfLoops = -1;
    
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
    [[AudioPlayer sharedController] playSound:@"slots" extension:@"wav"];
    for (int i = 0; i < _slotMachine.resultSlots.count; i++)
    {
        SlotItemType slotItemType = [_slotMachine.resultSlots[i] integerValue];
        SlotView *slotView = (SlotView *)[self.view viewWithTag:(i+1)];
        [slotView spinToSlotType:slotItemType delay:((i+1) * 0.15)];
        
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
    [_doggy animateWithImages:[UIImageView imagesFromName:@"sit" count:5 zeroBased:YES hasLeadingZeros:NO]
                  duration:0.35f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:0.36f];
}

- (void)animateDogHappy
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateDogIdle) object:nil];
    
    [_pantingPlayer stop];
    [[AudioPlayer sharedController] playSound:@"pant" extension:@"wav"];
    [_doggy animateWithImages:[UIImageView imagesFromName:@"happy" count:35 zeroBased:YES hasLeadingZeros:NO]
                     duration:3.0f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:3.0f];
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
    
    [_pantingPlayer stop];
    [[AudioPlayer sharedController] playSound:@"growl" extension:@"wav"];
    [_doggy animateWithImages:[UIImageView imagesFromName:@"sad" count:21 zeroBased:YES hasLeadingZeros:NO]
                     duration:2.5f];
    
    [self performSelector:@selector(animateDogIdle) withObject:nil afterDelay:2.5f];
}

- (void)animateWin
{
    _winPlayer = [[AudioPlayer sharedController] playSound:@"slotsPayout" extension:@"wav"];
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
    _playButton.userInteractionEnabled = YES;
}

- (void)goBackToMainViewController
{
    [CoinsController sharedController].coins = self.coins;
    [self dismissModalViewControllerAnimated:YES];
}

@end
