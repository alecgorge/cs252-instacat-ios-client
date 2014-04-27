//
//  ICGateway.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICGateway : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) BOOL isSignedIn;

@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *password;

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password;

- (void)signOut;

- (void)performAfterSignInFrom:(UIViewController *)vc completed:(void (^)())blk;

@end
