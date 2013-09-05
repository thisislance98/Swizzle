//
//  AudioPlayer.m
//  Swizzle
//
//  Created by Lance Hughes on 9/5/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

static AudioPlayer* sharedController;

+(AudioPlayer*)sharedController
{
    if (sharedController == nil)
    {
        sharedController = [[AudioPlayer alloc] init];
        
    }
    
    return sharedController;
}


-(AVAudioPlayer*)playSound:(NSString*)name extension:(NSString*)extension
{
    
    NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:name ofType:extension]];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
 
    [player play];
    return player;
    
}

@end
