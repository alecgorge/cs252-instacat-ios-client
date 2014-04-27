//
//  ICGateway.m
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICGateway.h"

#import "ICSignInViewController.h"

#import <FXKeychain/FXKeychain.h>

@implementation ICGateway

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if(self = [super init]) {
        self.isSignedIn = self.username && self.password;
    }
    
    return self;
}

- (NSString *)username {
    return FXKeychain.defaultKeychain[@"username"];
}

- (NSString *)password {
    return FXKeychain.defaultKeychain[@"password"];
}

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password {
    FXKeychain.defaultKeychain[@"username"] = username;
    FXKeychain.defaultKeychain[@"password"] = password;
    self.isSignedIn = YES;
}

- (void)signOut {
    FXKeychain.defaultKeychain[@"username"] = nil;
    FXKeychain.defaultKeychain[@"password"] = nil;
    self.isSignedIn = NO;
}

- (void)performAfterSignInFrom:(UIViewController *)from completed:(void (^)())blk {
    if(!self.isSignedIn) {
        ICSignInViewController *vc = [[ICSignInViewController alloc] initWithCompletion: ^(ICSignInResult res){
            if(res == ICSignInResultSuccess) {
                blk();
            }
        }];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [from presentViewController:nav
                           animated:YES
                         completion:NULL];
    }
    else {
        blk();
    }
}

@end
