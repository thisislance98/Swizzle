//
//  GuessViewController.m
//  Swizzle
//
//  Created by Lance Hughes on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "GuessViewController.h"
#import "CoinsController.h"


@implementation GuessViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self initWordObjs];
    
    self.blankLabels = [[NSMutableArray alloc] init];
    _letterButtons = [[NSMutableArray alloc] init];
    _nameLabel.text = [[PFUser currentUser] username];
    
    [self setupForWordAtIndex:0];
    
    self.coinsLabel.text = [[CoinsController sharedController] coinsString];
    
}

#pragma mark - setup functions


-(void)setupForWordAtIndex:(int)index
{
    _currentWordObjIndex = index;
    _currentWordObj = [_allWordObjs objectAtIndex:_currentWordObjIndex];
    _hintIndex = 0;
    
 //   [self.hintButton setHidden:NO];
    [self setupLetterButtons:_currentWordObj.word];
    [self setupLetterLabels:_currentWordObj.word.length];
    [self resetLetterButtons:_letterButtons];

    self.hintLabel.text = [_currentWordObj.hints objectAtIndex:0];
}

-(void)setupLetterLabels:(int)letterCount
{
    [self.blankLabels removeAllObjects];
    
    float lastLabelXPos = self.startBlankLabel.center.x + ((letterCount-1) * self.startBlankLabel.frame.size.width);
    float center = (lastLabelXPos + self.startBlankLabel.center.x) / 2;
    float screenCenter = [[UIScreen mainScreen] bounds].size.width / 2;
    float offset = screenCenter - center;
    
    for (int i=0; i < letterCount; i++)
    {
        UILabel* blankLabel =  [self deepLabelCopy:self.startBlankLabel];
        blankLabel.center = CGPointMake(offset + blankLabel.center.x + i * blankLabel.frame.size.width, blankLabel.center.y);
        [blankLabel setHidden:NO];
        [self.view addSubview:blankLabel];
        [self.blankLabels addObject:blankLabel];
    }
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

#pragma mark word functions

-(void)gotoNextWord
{
    [self.correctLabel setHidden:YES];
    _currentWordObjIndex = (_currentWordObjIndex + 1) % _allWordObjs.count;
    [self setupForWordAtIndex:_currentWordObjIndex];
}



-(void)onGotCorrectWord
{
    [self.correctLabel setHidden:NO];
    [[CoinsController sharedController] increaseCoins:NUM_WIN_COINS labelToUpdate:self.coinsLabel];
    [self performSelector:@selector(gotoNextWord) withObject:nil afterDelay:2];
}

-(BOOL)didGetCorrectWord
{
    BOOL isCorrectWord = NO;
    
    // check if they got the correct word
    if (_letterButtons.count == _currentWordObj.word.length)
    {
        isCorrectWord = YES;
        
        for (int i=0; i <  _currentWordObj.word.length; i++)
        {
            NSString* correctLetter = [self getCorrectLetterAtIndex:i];
            NSString* inputLetter = [self getLetterButtonLetterAtIndex:i];
            
            if ( [inputLetter isEqualToString:[correctLetter uppercaseString]] == NO)
            {
                isCorrectWord = NO;
                break;
            }
        }
    }
    
    return isCorrectWord;
}

#pragma mark - letter functions

-(void)buyLetter
{
    // first get the index of a blank slot or one that has an incorrect letter
    NSArray* indicies = [self getIncorrectOrBlankIndicies];
    int index = [((NSNumber*)indicies[arc4random() % indicies.count]) intValue];
    NSString* correctLetter = [self getCorrectLetterAtIndex:index];
    
    LetterButton* currentLetterButtonAtIndex = [self getLetterButtonAtIndex:index];
    
    // if there is a letter currently at the index we want to add the bought letter.. then move down
    if (currentLetterButtonAtIndex != nil)
        [self resetLetterButton:currentLetterButtonAtIndex];
    
    // now find the letter we want to place.. first we check the letters below
    for (LetterButton* button in [self getAllLetterButtons])
    {
        if ([_letterButtons containsObject:button])
            continue;
        
        if ([[button.titleLabel.text uppercaseString] isEqualToString:correctLetter])
        {
            [self moveLetterButton:button toSlotAtIndex:index];
            return;
        }
    }
    
    // otherwise the letter we want to place is at the top so we just move it
    for (int i=_letterButtons.count-1; i >=0; i--) 
    {
        LetterButton* button = _letterButtons[i];
        
        if ([[button.titleLabel.text uppercaseString] isEqualToString:correctLetter])
        {
            [self resetLetterButton:button animated:NO];
            [self moveLetterButton:button toSlotAtIndex:index];
        }
    }
    
}

-(LetterButton*)getLetterButtonAtIndex:(int)index
{
    UILabel* blankAtIndex = self.blankLabels[index];
    
    for (LetterButton* button in _letterButtons)
    {
        if (button.center.x == blankAtIndex.center.x)
            return button;
    }
    
    return nil;
}

-(NSString*)getLetterButtonLetterAtIndex:(int)index
{
    LetterButton* button = [self getLetterButtonAtIndex:index];
    return [button.titleLabel.text uppercaseString];
}

-(NSString*)getCorrectLetterAtIndex:(int)index
{
    NSString* correctWord = _currentWordObj.word;
    return [[NSString stringWithFormat: @"%C", [correctWord characterAtIndex:index]] uppercaseString];
}


-(NSMutableArray*)getAllLetterButtons
{
    NSMutableArray* buttons = [[NSMutableArray alloc] init];
    
    for (int i=100; i <= 111; i++)
    {
        [buttons addObject:[self.view viewWithTag:i]];
    }
    return buttons;
}

-(void)moveLetterButton:(LetterButton*)letterButton toSlotAtIndex:(int)index
{
    [_letterButtons addObject:letterButton];
    
    int labelIndex = index;
    UILabel* blankLabel = self.blankLabels[labelIndex];
    [blankLabel setHidden:YES];
    
    if (blankLabel == nil)
        return;
    
    letterButton.startPos = letterButton.center;
    
    [UIView animateWithDuration:.5 animations:^(void)
     {
         letterButton.center = blankLabel.center;
     }];
    
    
    if ([self didGetCorrectWord])
        [self onGotCorrectWord];
}

-(void)onLetterSelected:(LetterButton*)letterButton
{
    if (_letterButtons.count == self.blankLabels.count)
        return;
    
    // is the button in the bottom letter pad?
    if ([_letterButtons containsObject:letterButton] == NO)
    {
        [self moveLetterButton:letterButton toSlotAtIndex:[self getFirstVisibleBlankLabelIndex]];
    }
    else // its up in the word part
    {
        [self resetLetterButton:letterButton];
    }
}

-(void)resetLetterButton:(LetterButton*)button
{
    [self resetLetterButton:button animated:YES];
}

-(void)resetLetterButton:(LetterButton*)button animated:(BOOL)animated
{
    
    // first show the blank label that this button is leaving
    for (UILabel* blankLabel in self.blankLabels)
    {
        if (blankLabel.center.x == button.center.x)
        {
            [blankLabel setHidden:NO];
            break;
        }
    }
    
    if (animated)
    {
        [UIView animateWithDuration:.5 animations:^(void)
         {
             button.center = button.startPos;
         }];
    }
    else
        button.center = button.startPos;
    
    [_letterButtons removeObject:button];
}

-(void)resetLetterButtons:(NSArray*)letterButtons
{
    for (int i=letterButtons.count-1; i >=0; i--)
    {
        LetterButton* button = letterButtons[i];
        [self resetLetterButton:button];
    }
}



#pragma mark - button handlers

-(void)letterButtonTouch:(id)sender
{
    LetterButton* button = (LetterButton*)sender;
    
    [self onLetterSelected:button];
    
}

- (IBAction)nextHintTouch:(id)sender {
    _hintIndex++;
    
    if (_hintIndex == 2)
    {
        [self.hintButton setHidden:YES];
    }
    self.hintLabel.text = _currentWordObj.hints[_hintIndex];
    
}

- (IBAction)buyLetterTouch:(id)sender {
    
    if ([[CoinsController sharedController] buyForAmount:BUY_LETTER_COST labelToUpdate:self.coinsLabel])
    {
        [self buyLetter];
        
        self.coinsLabel.text = [[CoinsController sharedController] coinsString];
    }
    
}

- (IBAction)clearButtonTouch:(id)sender {
    if (_letterButtons.count == 0)
        return;
    
    [self resetLetterButtons:_letterButtons];
}


- (IBAction)undoButtonTouch:(id)sender {
    if (_letterButtons.count == 0)
        return;
    
    LetterButton* lastButton = _letterButtons[_letterButtons.count-1];
    [self resetLetterButton:lastButton];
}

#pragma mark - helper functions

-(UILabel*)deepLabelCopy:(UILabel*)label
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:label.frame];
    duplicateLabel.text = label.text;
    duplicateLabel.textColor = label.textColor;
    
    return duplicateLabel;
}

-(int)getFirstVisibleBlankLabelIndex
{
    for (int i=0; i < self.blankLabels.count; i++) 
    {
        UILabel* label = self.blankLabels[i];
        if (label.isHidden == NO)
            return i;
    }
    return -1;
}

-(NSMutableArray*)getIncorrectOrBlankIndicies
{
    NSMutableArray* indicies = [[NSMutableArray alloc] init];
    
    for (int i=0; i < self.blankLabels.count; i++)
    {
        if (((UILabel*)self.blankLabels[i]).isHidden == NO)
            [indicies addObject:@(i)];
        else if ( [[self getLetterButtonLetterAtIndex:i] isEqualToString:[self getCorrectLetterAtIndex:i]] == NO)
        {
            [indicies addObject:@(i)];
        }
    }
    
    return indicies;
}

@end
