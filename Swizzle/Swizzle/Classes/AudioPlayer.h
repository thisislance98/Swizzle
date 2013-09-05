//
//  AudioPlayer.h
//  Swizzle
//
//  Created by Lance Hughes on 9/5/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AudioPlayer : NSObject
{
    AVAudioPlayer* player;
}

+(AudioPlayer*)sharedController;

-(AVAudioPlayer*)playSound:(NSString*)name extension:(NSString*)extension;
@end
