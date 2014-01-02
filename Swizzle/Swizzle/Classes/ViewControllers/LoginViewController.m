//
//  LoginViewController.m
//  Swizzle
//
//  Created by Sami Aref on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "LoginViewController.h"
#import "GuessViewController.h"
#import "UIImageView+AnimateImages.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "WordObj.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UIImageView* pupImageView;
@property (nonatomic, weak) IBOutlet UIButton* loginButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (nonatomic, strong) NSArray *words;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loginButton.alpha = 0;
    
    [PFFacebookUtils initializeFacebook];
    BOOL userCached = [PFUser currentUser] != nil;
    BOOL isLinked = [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
    BOOL gotoGuessScreenOnDownload = userCached && isLinked;
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Words"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [_activityIndicator stopAnimating];
         
         [UIView animateWithDuration:0.3f animations:^{
             _loginButton.alpha = 1.0f;
         }];
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             // The find succeeded.
             NSLog(@"Successfully retrieved %d objects.", objects.count);
             // Do something with the found objects
             
             NSMutableArray *words =[@[] mutableCopy];
             
             for (PFObject *object in objects)
             {
                 
                 NSString *word =  [object objectForKey:@"Word"];
                 NSArray *hints = [object objectForKey:@"Hints"];
                 
                 WordObj *wordObj = [[WordObj alloc] initWithWord:word andHints:hints];
                 
                 [words addObject:wordObj];
                 
                 NSLog(@"%@", object.objectId);
             }
             
             _words = words;
             
             if (gotoGuessScreenOnDownload)
                 [self transitionToFirstScreen];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    

    
    
}

- (IBAction)loginButtonTouchHandler:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // The permissions requested from the user
    NSArray *permissionsArray = @[  @"publish_stream", @"status_update"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (!user) {
             if (!error) {
                 NSLog(@"Uh oh. The user cancelled the Facebook login.");
             } else {
                 NSLog(@"Uh oh. An error occurred: %@", error);
             }
         } else if (user.isNew) {
             NSLog(@"User with facebook signed up and logged in!");
         } else {
             NSLog(@"User with facebook logged in!");
         }
         
         [self transitionToFirstScreen];
     }];
}

- (BOOL)prefersStatusBarHidden {return YES;}

- (IBAction)skipButtonTouched:(id)sender
{
    [self transitionToFirstScreen];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GuessViewController *gvc = segue.destinationViewController;
    gvc.words = self.words;
}

-(void)transitionToFirstScreen
{
    if (self.words)
    {
        [self performSegueWithIdentifier:@"guessSegue" sender:self];
    }
}

@end
