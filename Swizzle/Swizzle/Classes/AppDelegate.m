//
//  AppDelegate.m
//  Swizzle
//
//  Created by Lance Hughes on 4/12/13.
//  Copyright (c) 2013 Lance Hughes. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"bFq8oR89k72yq2cRuuf6TyBZoFJrsVJPIdbKftN2"
                  clientKey:@"u4qcxY840IoLqq62LAKIb1Fd9Poqvu4JszuujBqm"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}


@end
