//
//  GuessViewController.h
//  Swizzle
//
//  Created by Lance Hughes on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WordObj.h"
#import "LetterButton.h"

#define BUY_LETTER_COST 10
#define NUM_WIN_COINS 20
#define NUM_HINTS 4

@interface GuessViewController : UIViewController
{
    WordObj* _currentWordObj;
    int _currentWordObjIndex;
    int _hintIndex;
    NSMutableArray* _letterButtons;
    
    NSMutableArray* _allWordObjs;
    
}

@property (strong, nonatomic) IBOutlet UILabel *coinsLabel;

@property (nonatomic, strong) NSMutableArray* blankLabels;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@property (strong, nonatomic) IBOutlet UILabel *correctLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) NSString* currentWord;

@property (strong, nonatomic) IBOutlet UILabel *startBlankLabel;

@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
- (IBAction)nextHintTouch:(id)sender;

- (IBAction)buyLetterTouch:(id)sender;

- (IBAction)clearButtonTouch:(id)sender;

- (IBAction)undoButtonTouch:(id)sender;
@end
