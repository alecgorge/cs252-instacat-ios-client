//
//  ICAppDelegate.m
//  Instacat
//
//  Created by Alec Gorge on 4/16/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICAppDelegate.h"

@implementation ICAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
	return YES;
}

@end
