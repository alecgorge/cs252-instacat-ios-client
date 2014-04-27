//
//  TLSignUpViewController.h
//  testLogin
//
//  Created by Manik Kalra on 18/04/14.
//  Copyright (c) 2014 Manik Kalra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICSignInViewController.h"

@interface ICSignUpViewController : UITableViewController <UITextFieldDelegate>

- (instancetype)initWithCompletion:(void(^)())completion;

@property (nonatomic, copy) void(^completion)();

@end
