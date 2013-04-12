//
//  ViewController.h
//  Swizzle
//
//  Created by Lance Hughes on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_DONT_USE_WORDS 6

@interface HintViewController : UIViewController <UITextFieldDelegate>
{
    NSArray* _wordsToGuess;
    NSArray* _dontUseWords;
    
    NSString* _textToSend;
}
@property (strong, nonatomic) IBOutlet UILabel *wordToGuess;

- (IBAction)submitButtonTouch:(id)sender;

@end
