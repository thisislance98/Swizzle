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
#import <iAd/iAd.h>
#import "LetterButton.h"
#import "BlankSlot.h"
#import "UIImageView+AnimateImages.h"

#define BUY_LETTER_COST 10
#define NUM_WIN_COINS 20
#define NUM_HINTS 4
#define SMALL_BUTTON_SCALE .85
#define MAX_NUM_LETTERS 8
#define WORD_FOR_SLOTS 3

@interface GuessViewController : UIViewController <ADBannerViewDelegate>
{
    WordObj* _currentWordObj;
    int _currentWordObjIndex;
    int _hintIndex;
    int _numCorrectWords;
    NSMutableArray* _letterButtons;
    
    NSMutableArray* _allWordObjs;
    
}
- (IBAction)onFacebookTouch:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *bonesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dog;

@property (nonatomic, strong) NSMutableArray* blankSlots;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@property (strong, nonatomic) IBOutlet UILabel *correctLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) NSString* currentWord;

@property (strong, nonatomic) IBOutlet UIImageView *startBlankImage;

@property (strong, nonatomic) IBOutlet UILabel *hintLabel;

@property (strong, nonatomic) IBOutletCollection(LetterButton) NSArray *allLetterButtons;

- (IBAction)nextHintTouch:(id)sender;

- (IBAction)buyLetterTouch:(id)sender;

- (IBAction)clearButtonTouch:(id)sender;

@end
