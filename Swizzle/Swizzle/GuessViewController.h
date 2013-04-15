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

@interface GuessViewController : UIViewController
{
    WordObj* _currentWordObj;
    int _currentWordObjIndex;
    int _hintIndex;
    NSMutableArray* _currentLetters;
    
    NSMutableArray* _allWordObjs;
    
}
@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@property (strong, nonatomic) IBOutlet UILabel *correctLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) NSString* currentWord;
@property (strong, nonatomic) IBOutlet UILabel *wordInputLabel;

@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
- (IBAction)nextHintTouch:(id)sender;

- (IBAction)clearButtonTouch:(id)sender;

- (IBAction)undoButtonTouch:(id)sender;
@end
