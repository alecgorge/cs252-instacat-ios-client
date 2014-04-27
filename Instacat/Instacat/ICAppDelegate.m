//
//  ICAppDelegate.m
//  Instacat
//
//  Created by Alec Gorge on 4/16/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICAppDelegate.h"

#import "ICHomeFeedTableViewController.h"
#import "ICPhotoPickerViewController.h"

@implementation ICAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    
    ICHomeFeedTableViewController *home = [[ICHomeFeedTableViewController alloc] init];
    
    self.tabs = [[UITabBarController alloc] init];
    self.tabs.viewControllers = @[
                             [[UINavigationController alloc] initWithRootViewController:home],
                             [[UIViewController alloc] init],
                             [[UIViewController alloc] init],
                             ];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setImage:[UIImage imageNamed:@"glyphicons_011_camera"]
       forState:UIControlStateNormal];
    b.frame = CGRectMake(0, 0, 44, 44);
    [b addTarget:self
          action:@selector(takePhoto)
    forControlEvents:UIControlEventTouchUpInside];
    
    b.center = self.tabs.tabBar.center;
    
    [self.tabs.view addSubview:b];
    
    self.window.rootViewController = self.tabs;
    
    [self.window makeKeyAndVisible];
    
	return YES;
}

- (void)takePhoto {
    [ICGateway.sharedInstance performAfterSignInFrom:self.tabs
                                           completed:^{
                                               [self.tabs presentViewController:[[ICPhotoPickerViewController alloc] init]
                                                                       animated:YES
                                                                     completion:NULL];                                               
                                           }];
}

@end
