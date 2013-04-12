//
//  GuessViewController.m
//  Swizzle
//
//  Created by Lance Hughes on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "GuessViewController.h"


@implementation GuessViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _currentLetters = [[NSMutableArray alloc] init];
    _nameLabel.text = [[PFUser currentUser] username];
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameData"];
    [query whereKeyExists:@"currentHint"];

    
    __weak GuessViewController* weakSelf = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            weakSelf.hintLabel.text = [[objects lastObject] objectForKey:@"currentHint"];
            _theWord = [[objects lastObject] objectForKey:@"currentWord"];
            
            [weakSelf setupLetterButtons];
            [weakSelf updateLettersLabel];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)updateLettersLabel
{
    self.wordInputLabel.text = @"";
    
    NSMutableArray* letters = [[NSMutableArray alloc] initWithArray:_currentLetters];
    
    for (int i=0; i < _theWord.length; i++)
    {
        if (letters.count > 0)
        {
            self.wordInputLabel.text = [NSString stringWithFormat:@"%@ %@",self.wordInputLabel.text, [letters objectAtIndex:0]];
            [letters removeObjectAtIndex:0];
        }
        else
            self.wordInputLabel.text = [NSString stringWithFormat:@"%@ _",self.wordInputLabel.text];
    }
}

-(void)letterButtonTouch:(id)sender
{
    UIButton* button = (UIButton*)sender;

    [self onLetterSelected:button.titleLabel.text];

}

-(void)onLetterSelected:(NSString*)letter
{
    [_currentLetters addObject:letter];
    [self updateLettersLabel];
    
    if (_currentLetters.count == _theWord.length)
    {
        BOOL isCorrectWord = YES;
        
        for (int i=0; i <  _theWord.length; i++)
        {
            NSString* correctLetter = [NSString stringWithFormat: @"%C", [_theWord characterAtIndex:i]];
            NSString* inputLetter = _currentLetters[i];
            
            if ( [inputLetter isEqualToString:[correctLetter uppercaseString]] == NO)
            {
                isCorrectWord = NO;
                break;
            }
        }
        
        if (isCorrectWord == YES)
            [self onGotCorrectWord];
    }
    
}

-(void)onGotCorrectWord
{
    [self.correctLabel setHidden:NO];
}


-(void)setupLetterButtons
{
    NSMutableArray* letters = [[NSMutableArray alloc] init];
    NSMutableArray* buttonTags = [[NSMutableArray alloc] init];
    
    for (int i=0; i < _theWord.length; i++)
    {
        NSString* theLetter = [NSString stringWithFormat: @"%C", [_theWord characterAtIndex:i]];
        
        [letters addObject:[theLetter uppercaseString]];
    }

    for (int i=100; i <= 111; i++)
    {
        [buttonTags addObject:[NSNumber numberWithInt:i]];
    }
    
    int buttonCount = buttonTags.count;
    for (int i=0; i < buttonCount; i++)
    {
        int tagIndex = arc4random() % buttonTags.count;
        NSNumber* tag = [buttonTags objectAtIndex:tagIndex];
        [buttonTags removeObjectAtIndex:tagIndex];
        UIButton* button = (UIButton*)[self.view viewWithTag:tag.integerValue];
        [button addTarget:self action:@selector(letterButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        if (letters.count > 0)
        {
            int letterIndex = arc4random() % letters.count;
            NSString* letter = [letters objectAtIndex:letterIndex];
            [letters removeObjectAtIndex:letterIndex];
            [button setTitle:letter forState:UIControlStateNormal];
        }
        else
        {
            NSString *allLetters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            NSString* randomLetter = [NSString stringWithFormat: @"%C", [allLetters characterAtIndex:arc4random()%allLetters.length]];
            [button setTitle:randomLetter forState:UIControlStateNormal];
        }
        
    }
    
}

- (IBAction)clearButtonTouch:(id)sender {
    if (_currentLetters.count == 0)
        return;
    
    [_currentLetters removeAllObjects];
    [self updateLettersLabel];
}

- (IBAction)undoButtonTouch:(id)sender {
    if (_currentLetters.count == 0)
        return;
    
    [_currentLetters removeObjectAtIndex:_currentLetters.count-1];
    [self updateLettersLabel];
}
@end
