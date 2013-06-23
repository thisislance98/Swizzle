//
//  LoginViewController.m
//  Swizzle
//
//  Created by Sami Aref on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImageView+AnimateImages.h"
#import "MBProgressHUD.h"
#import <Parse/PFFacebookUtils.h>

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UIImageView* pupImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self animatePuppy];
    
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

- (IBAction)skipButtonTouched:(id)sender
{
    [self transitionToFirstScreen];
}

-(void)transitionToFirstScreen
{
    [self performSegueWithIdentifier:@"guessSegue" sender:self];
}

@end
