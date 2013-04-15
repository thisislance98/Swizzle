//
//  ViewController.m
//  Swizzle
//
//  Created by Lance Hughes on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "HintViewController.h"
#import <Parse/Parse.h>



const NSString* kWordsToGuess =
{
    @"Mexico"
};

@interface HintViewController ()

@end

@implementation HintViewController

-(void)initArrays
{
    _wordsToGuess =
    @[
      @"Mexico",
      @"Car"
    ];
    
    _dontUseWords = @[
                      @[@"South",@"Border",@"Central",@"Chavez",@"Borrito",@"Taco"],
                      @[@"Ride",@"Drive",@"Wheel",@"Engine",@"Transportation",@"Move"],
                      ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self initArrays];
    
    [self setScreenForWordAtIndex:0];

}

-(void)setScreenForWordAtIndex:(int)wordIndex
{
    self.wordToGuess.text = [_wordsToGuess objectAtIndex:wordIndex];
    
    
    for (int i=0; i < NUM_DONT_USE_WORDS; i++)
    {
        NSArray* dontUseArray = _dontUseWords[wordIndex];
        
        ((UILabel*)[self.view viewWithTag:i+100]).text = [dontUseArray objectAtIndex:i];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    _textToSend = theTextField.text;
    return YES;
}


- (IBAction)submitButtonTouch:(id)sender
{
    if (_textToSend == nil)
        return;
    
    PFObject* gameData = [PFObject objectWithClassName:@"GameData"];
    [gameData setObject:_textToSend forKey:@"currentHint"];
    [gameData setObject:self.wordToGuess.text forKey:@"currentWord"];
    [gameData save];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
