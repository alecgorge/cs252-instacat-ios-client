//
//  TLViewController.h
//  testLogin
//
//  Created by Manik Kalra on 16/04/14.
//  Copyright (c) 2014 Manik Kalra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ICSignInResult) {
    ICSignInResultSuccess,
    ICSignInResultCancelled,
};

@interface ICSignInViewController : UITableViewController <UITextFieldDelegate>

- (instancetype)initWithCompletion:(void(^)())completion;

@property (nonatomic, copy) void(^completion)();

@end
