//
//  LoginViewController.m
//  Swizzle
//
//  Created by Sami Aref on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImageView+AnimateImages.h"
#import <Parse/PFFacebookUtils.h>

@interface LoginViewController ()

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIImageView* pupImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self animatePuppy];
    
	// Do any additional setup after loading the view.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    _activityIndicator = spinner;
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        [self transitionToFirstScreen];
    }
    
    [PFFacebookUtils initializeFacebook];
}

- (void)animatePuppy
{
    [_pupImageView animateWithImages:[UIImageView imagesFromName:@"login_pup_" count:4] duration:1.0f];
    [self performSelector:@selector(animatePuppy) withObject:nil afterDelay:7.0f];
}


- (IBAction)loginButtonTouchHandler:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[  @"publish_stream", @"status_update"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
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

-(void)transitionToFirstScreen
{
    [self performSegueWithIdentifier:@"guessSegue" sender:self];
}

@end
