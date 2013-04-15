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
    
    
    [self initWordObjs];
    
    _currentLetters = [[NSMutableArray alloc] init];
    _nameLabel.text = [[PFUser currentUser] username];
    
    [self setupForWordAtIndex:_currentWordObjIndex];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"GameData"];
//    [query whereKeyExists:@"currentHint"];
//
//    
//    __weak GuessViewController* weakSelf = self;
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            
//            weakSelf.hintLabel.text = [[objects lastObject] objectForKey:@"currentHint"];
//            _theWord = [[objects lastObject] objectForKey:@"currentWord"];
//            
//            [weakSelf setupLetterButtons:_theWord];
//            [weakSelf updateLettersLabel:_currentLetters];
//            
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
}

-(void)setupForWordAtIndex:(int)index
{
    _currentWordObjIndex = index;
    _currentWordObj = [_allWordObjs objectAtIndex:_currentWordObjIndex];
    _hintIndex = 0;
    
    [self.hintButton setHidden:NO];
    [self setupLetterButtons:_currentWordObj.word];
    
    [_currentLetters removeAllObjects];
    [self updateLettersLabel:_currentLetters];
    
    self.hintLabel.text = [_currentWordObj.hints objectAtIndex:0];
}

-(void)gotoNextWord
{
    [self.correctLabel setHidden:YES];
    _currentWordObjIndex = (_currentWordObjIndex + 1) % _allWordObjs.count;
    [self setupForWordAtIndex:_currentWordObjIndex];
}

-(void)initWordObjs
{
    _allWordObjs = [[NSMutableArray alloc] init];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"WordAndHints" ofType:@"plist"];
    NSArray* words = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary* wordDict in words)
    {
        NSString* word = [wordDict objectForKey:@"Word"];
        NSArray* hints = [wordDict objectForKey:@"Hints"];
        [_allWordObjs addObject:[[WordObj alloc] initWithWord:word andHints:hints]];
    }
}


-(void)updateLettersLabel:(NSArray*)currentLetters
{
    self.wordInputLabel.text = @"";
    
    NSMutableArray* letters = [[NSMutableArray alloc] initWithArray:currentLetters];
    
    for (int i=0; i < _currentWordObj.word.length; i++)
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
    [self updateLettersLabel:_currentLetters];
    
    if (_currentLetters.count == _currentWordObj.word.length)
    {
        BOOL isCorrectWord = YES;
        
        for (int i=0; i <  _currentWordObj.word.length; i++)
        {
            NSString* correctLetter = [NSString stringWithFormat: @"%C", [_currentWordObj.word characterAtIndex:i]];
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
    [self performSelector:@selector(gotoNextWord) withObject:nil afterDelay:2];
}


// sets the letter titles on all the buttons to include all the letters in the word along and the rest being random
-(void)setupLetterButtons:(NSString*)theWord
{
    NSMutableArray* letters = [[NSMutableArray alloc] init];
    NSMutableArray* buttonTags = [[NSMutableArray alloc] init];
    
    // create an array with all the letters in the word
    for (int i=0; i < theWord.length; i++)
    {
        NSString* theLetter = [NSString stringWithFormat: @"%C", [theWord characterAtIndex:i]];
        
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
        
        
        // if there are letters left in the array add one
        if (letters.count > 0)
        {
            int letterIndex = arc4random() % letters.count;
            NSString* letter = [letters objectAtIndex:letterIndex];
            [letters removeObjectAtIndex:letterIndex];
            [button setTitle:letter forState:UIControlStateNormal];
        }
        else // add a random letter
        {
            NSString *allLetters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            NSString* randomLetter = [NSString stringWithFormat: @"%C", [allLetters characterAtIndex:arc4random()%allLetters.length]];
            [button setTitle:randomLetter forState:UIControlStateNormal];
        }
        
    }
    
}

- (IBAction)nextHintTouch:(id)sender {
    _hintIndex++;
    
    if (_hintIndex == 2)
    {
        [self.hintButton setHidden:YES];
    }
    self.hintLabel.text = [_currentWordObj.hints objectAtIndex:_hintIndex];
    
}

- (IBAction)clearButtonTouch:(id)sender {
    if (_currentLetters.count == 0)
        return;
    
    [_currentLetters removeAllObjects];
    [self updateLettersLabel:_currentLetters];
}


- (IBAction)undoButtonTouch:(id)sender {
    if (_currentLetters.count == 0)
        return;
    
    [_currentLetters removeObjectAtIndex:_currentLetters.count-1];
    [self updateLettersLabel:_currentLetters];
}
@end
