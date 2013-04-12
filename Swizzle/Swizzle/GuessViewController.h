//
//  GuessViewController.h
//  Swizzle
//
//  Created by Lance Hughes on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GuessViewController : UIViewController
{
    NSString* _theWord;
    NSMutableArray* _currentLetters;
}
@property (strong, nonatomic) IBOutlet UILabel *correctLabel;

@property (nonatomic,strong) NSString* currentWord;
@property (strong, nonatomic) IBOutlet UILabel *wordInputLabel;

@property (strong, nonatomic) IBOutlet UILabel *hintLabel;

- (IBAction)clearButtonTouch:(id)sender;

- (IBAction)undoButtonTouch:(id)sender;
@end
