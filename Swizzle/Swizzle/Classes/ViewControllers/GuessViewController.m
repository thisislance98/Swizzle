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
    
    self.blankSlots = [[NSMutableArray alloc] init];
    _letterButtons = [[NSMutableArray alloc] init];
    _nameLabel.text = [[PFUser currentUser] username];
    
    [self setupForWordAtIndex:0];
    
    self.bonesLabel.text = [[CoinsController sharedController] coinsString];
    
    
    for (LetterButton* button in self.allLetterButtons)
    {
        [button.titleLabel setFont:[UIFont fontWithName:@"Luckiest Guy" size:23]];
    }
    
    [self.hintLabel setFont:[UIFont fontWithName:@"Luckiest Guy" size:34]];
    
    [self.bonesLabel setFont:[UIFont fontWithName:@"Luckiest Guy" size:24]];
    
}

#pragma mark - setup functions


-(void)setupForWordAtIndex:(int)index
{
    _currentWordObjIndex = index;
    _currentWordObj = [_allWordObjs objectAtIndex:_currentWordObjIndex];
    _hintIndex = 0;
    
 //   [self.hintButton setHidden:NO];
    [self setupLetterLabels:_currentWordObj.word.length];
    [self resetLetterButtons:_letterButtons];
    [self setupLetterButtons:_currentWordObj.word];
    
    

    // this will stop the hint words from cycling
    self.hintLabel.alpha = 0;
    [self cycleHintWords];
}


-(void)setupLetterLabels:(int)letterCount
{
    if (letterCount > MAX_NUM_LETTERS)
    {
        NSLog(@"ERROR: TOO MANY LETTERS!");
        return;
    }
    
    for (BlankSlot* slot in self.blankSlots)
    {
        [slot removeFromSuperview];
    }
    [self.blankSlots removeAllObjects];
    
    float letterPadding = 5;
    
    float lastLabelXPos = self.startBlankImage.center.x + ((letterCount+1) * self.startBlankImage.frame.size.width + letterPadding);
    float center = (lastLabelXPos + self.startBlankImage.center.x) / 2;
    float screenCenter = [[UIScreen mainScreen] bounds].size.width / 2;
    float offset = screenCenter - center;
    
    for (int i=0; i < letterCount; i++)
    {
        BlankSlot* blankSlot = [[BlankSlot alloc] initWithImage:[UIImage imageNamed:@"empty_slot.png"]];
        
        blankSlot.center = CGPointMake(offset + self.startBlankImage.center.x + i * (blankSlot.frame.size.width + letterPadding), self.startBlankImage.center.y);
    
        [self.view insertSubview:blankSlot belowSubview:self.startBlankImage];
        [self.blankSlots addObject:blankSlot];
    }
    
    CGPoint lastBlankCenter = ((UIImageView*)self.blankSlots[self.blankSlots.count-1]).center;
    self.facebookButton.center =  CGPointMake(lastBlankCenter.x + self.startBlankImage.frame.size.width + letterPadding*2, self.facebookButton.center.y);
}

// sets the letter titles on all the buttons to include all the letters in the word along and the rest being random
-(void)setupLetterButtons:(NSString*)theWord
{
    NSMutableArray* letters = [[NSMutableArray alloc] init];
    NSMutableArray* letterButtons = [[NSMutableArray alloc] initWithArray:self.allLetterButtons];
    
    // create an array with all the letters in the word
    for (int i=0; i < theWord.length; i++)
    {
        NSString* theLetter = [NSString stringWithFormat: @"%C", [theWord characterAtIndex:i]];
        
        [letters addObject:[theLetter uppercaseString]];
    }

    int buttonCount = self.allLetterButtons.count;
    for (int i=0; i < buttonCount; i++)
    {
        int index = arc4random() % letterButtons.count;
        LetterButton* button = letterButtons[index];
        [letterButtons removeObjectAtIndex:index];
        button.startPos = button.center;
        
        [button addTarget:self action:@selector(letterButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanButton:)];
        
        [button addGestureRecognizer:panGestureRecognizer];
        
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

-(void)cycleHintWords
{
    self.hintLabel.text = [_currentWordObj.hints objectAtIndex:_hintIndex];
    
    __weak GuessViewController* weakSelf = self;
    
    [UIView animateWithDuration:1 animations:^(void)
     {
         weakSelf.hintLabel.alpha = 1;
         
     }completion:^(BOOL finished)
     {
         if (finished)
         {
             [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void)
              {
                  weakSelf.hintLabel.alpha = 0;
                  
              }completion:^(BOOL finished)
              {
                  if (finished)
                  {
                      _hintIndex = (_hintIndex + 1) % _currentWordObj.hints.count;
                      
                      [weakSelf cycleHintWords];
                  }
              }];
         }
         
     }];
    
}

-(void)gotoNextWord
{
    [self.correctLabel setHidden:YES];
    _currentWordObjIndex = (_currentWordObjIndex + 1) % _allWordObjs.count;
    [self setupForWordAtIndex:_currentWordObjIndex];
}



-(void)onGotCorrectWord
{
    [self.correctLabel setHidden:NO];
    [[CoinsController sharedController] increaseCoins:NUM_WIN_COINS labelToUpdate:self.bonesLabel];
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
    
    if (indicies.count == 0)
        return;
    
    int index = [((NSNumber*)indicies[arc4random() % indicies.count]) intValue];
    NSString* correctLetter = [self getCorrectLetterAtIndex:index];
    
    LetterButton* currentLetterButtonAtIndex = [self getLetterButtonAtIndex:index];
    
    // if there is a letter currently at the index we want to add the bought letter.. then move down
    if (currentLetterButtonAtIndex != nil)
        [self resetLetterButton:currentLetterButtonAtIndex];
    
    // now find the letter we want to place.. first we check the letters below
    for (LetterButton* button in self.allLetterButtons)
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
            [self resetLetterButton:button animated:NO sendToStartPos:YES];
            [self moveLetterButton:button toSlotAtIndex:index];
        }
    }
    
}

-(LetterButton*)getLetterButtonAtIndex:(int)index
{
    BlankSlot* blankAtIndex = self.blankSlots[index];
    
    return blankAtIndex.button;
    
}

-(int)getIndexForLetterButton:(LetterButton*)letterButton
{
    for (int i=0; i < self.blankSlots.count; i++)
    {
        BlankSlot* slot = self.blankSlots[i];
        if (slot.button == letterButton)
            return i;
    }
    
    return -1;
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

-(int)getCloseBlankSlotIndex:(LetterButton*)button
{
    float minDist = 99999;
    int retIndex = -1;
    
    for (int i=0; i < self.blankSlots.count; i++)
    {
        BlankSlot* slot = self.blankSlots[i];
        if (slot.button != nil)
            continue;
        
        float dist = [self distanceFrom:slot.center to:button.center];
        
        if (dist < minDist && dist < 30)
        {
            minDist = dist;
            retIndex = i;
        }
    }
    return retIndex;
}


-(void)moveLetterButton:(LetterButton*)letterButton toSlotAtIndex:(int)index
{
    [_letterButtons addObject:letterButton];


    BlankSlot* blankSlot = self.blankSlots[index];
    
    if (blankSlot == nil)
        return;
    
    blankSlot.button = letterButton;
    
    __weak GuessViewController* weakSelf = self;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void)
     {
        
         [weakSelf scaleButton:letterButton scale:SMALL_BUTTON_SCALE];

         letterButton.center = CGPointMake(blankSlot.center.x, blankSlot.center.y+2)  ;
         
         
     }completion:^(BOOL finished)
     {
         
     }];
    
    if ([self didGetCorrectWord])
        [self onGotCorrectWord];
}


-(void)onLetterPanned:(LetterButton*)letterButton
{
    int slotIndex = [self getCloseBlankSlotIndex:letterButton];
    
    if (slotIndex != -1)
    {
        [self resetLetterButton:letterButton animated:NO sendToStartPos:NO];
        [self moveLetterButton:letterButton toSlotAtIndex:slotIndex];
    }
    else
        [self resetLetterButton:letterButton];
}

-(void)onLetterSelected:(LetterButton*)letterButton
{

    // is the button in the bottom letter pad?
    if ([_letterButtons containsObject:letterButton] == NO && _letterButtons.count < self.blankSlots.count)
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
    [self resetLetterButton:button animated:YES sendToStartPos:YES];
}

-(void)resetLetterButton:(LetterButton*)button animated:(BOOL)animated sendToStartPos:(BOOL)sendToStartPos
{
    int index = [self getIndexForLetterButton:button];
    
    if (index != -1)
    {
        BlankSlot* slot = self.blankSlots[index];
        slot.button = nil;
    }
    
    if (sendToStartPos)
    {
        if (animated)
        {
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void)
             {
                 button.center = button.startPos;
                 button.frame = button.startFrame;
             }completion:^(BOOL complete)
             {
             
             }];
 
        }
        else
        {
            button.center = button.startPos;
            [self scaleButton:button scale:1];
        }
    }
    
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

-(void)didPanButton:(UIPanGestureRecognizer*)recognizer
{
    LetterButton* button = (LetterButton*)recognizer.view;
    static CGPoint startPos;
    
    if (recognizer.state == UIGestureRecognizerStateBegan )
    {
        startPos = button.center;
        
        if ([_letterButtons containsObject:button])
        {
            BlankSlot* slot = self.blankSlots[[self getIndexForLetterButton:button]];
            slot.button = nil;
            
            
            [UIView animateWithDuration:.3 animations:^(void)
            {
                button.frame = button.startFrame;
            }];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
        [self onLetterPanned:button];
    else
    {
        CGPoint delta = [recognizer translationInView:self.view];
        button.center = CGPointMake(startPos.x + delta.x, startPos.y + delta.y);
    }
}


-(void)letterButtonTouch:(id)sender
{
    LetterButton* button = (LetterButton*)sender;
    
    if ([_letterButtons containsObject:button])
    {
        BlankSlot* slot = self.blankSlots[[self getIndexForLetterButton:button]];
        slot.button = nil;
    }
    
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
    
    if ([[CoinsController sharedController] buyForAmount:BUY_LETTER_COST labelToUpdate:self.bonesLabel])
    {
        [self buyLetter];
        
        self.bonesLabel.text = [[CoinsController sharedController] coinsString];
    }
    
}

- (IBAction)clearButtonTouch:(id)sender {
    if (_letterButtons.count == 0)
        return;
    
    [self resetLetterButtons:_letterButtons];
}


#pragma mark - helper functions

-(int)getFirstVisibleBlankLabelIndex
{
    for (int i=0; i < self.blankSlots.count; i++) 
    {
        BlankSlot* slot = self.blankSlots[i];
        if (slot.button == nil)
            return i;
    }
    return -1;
}

-(NSMutableArray*)getIncorrectOrBlankIndicies
{
    NSMutableArray* indicies = [[NSMutableArray alloc] init];
    
    for (int i=0; i < self.blankSlots.count; i++)
    {
        if (((BlankSlot*)self.blankSlots[i]).button == nil)
            [indicies addObject:@(i)];
        else if ( [[self getLetterButtonLetterAtIndex:i] isEqualToString:[self getCorrectLetterAtIndex:i]] == NO)
        {
            [indicies addObject:@(i)];
        }
    }
    
    return indicies;
}

-(void)scaleButton:(LetterButton*)button scale:(float)scale;
{
    CGRect frame = button.startFrame;
    frame.origin = button.frame.origin;
    frame.size.width = scale * frame.size.width;
    frame.size.height = scale * frame.size.height;
    
    button.frame = frame;
}

-(float)distanceFrom:(CGPoint)point1 to:(CGPoint)point2
{
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (void)viewDidUnload {
    [self setAllLetterButtons:nil];
    [self setStartBlankImage:nil];
    [self setFacebookButton:nil];
    [super viewDidUnload];
}


#pragma -mark Facebook Stuff

-(void)publishToFBWall
{

    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Uploaded thru app",  @"message", nil];
    [params setObject:[UIImage imageNamed:@"clear_btn1.png"] forKey:@"source"];
//    [params setObject:[UIImage imageNamed:@"image-name.png"] forKey:@"source"];
    FBRequest* request = [FBRequest requestWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" ];

 //   FBRequest* request = [FBRequest requestForPostStatusUpdate:<#(NSString *)#>:@"me/photos"];
 //   FBRequest* request = [FBRequest req:<#(UIImage *)#>:@"test test"];
//    FBRequest * request = [[FBRequest alloc] initWithSession:[PFFacebookUtils session] graphPath:@"me" parameters:params HTTPMethod:@"POST"];
 
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data

            NSLog(@"Facebook request complete");
        }
        else
        {
            NSLog(@"got FB error: %@",[error localizedDescription]);
        }
    }];
}


@end
