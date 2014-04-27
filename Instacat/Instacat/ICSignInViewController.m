//
//  TLViewController.m
//  testLogin
//
//  Created by Manik Kalra on 16/04/14.
//  Copyright (c) 2014 Manik Kalra. All rights reserved.
//

#import "ICSignInViewController.h"
#import "ICSignUpViewController.h"

typedef NS_ENUM(NSInteger, InstacatSignInRows) {
    InstacatLoginRowUsername,
    InstacatLoginRowPassword,
    InstacatLoginRowCount,
};

@interface ICSignInViewController ()

@property(nonatomic, strong) UITextField *usernameField;
@property(nonatomic, strong) UITextField *passwordField;

@end

@implementation ICSignInViewController

- (instancetype)initWithCompletion:(void (^)())completion {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.completion = completion;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Sign In";
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(signUpButtonPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(dismiss)];
}

- (void)dismiss {
    self.completion(ICSignInResultCancelled);
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return InstacatLoginRowCount;
    }
    else if(section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    if(indexPath.section == 0 && indexPath.row == InstacatLoginRowUsername) {
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.view.bounds.size.width - 40, 31)];
        self.usernameField.placeholder = @"Username";
        self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.usernameField becomeFirstResponder];
        [self.usernameField setReturnKeyType:UIReturnKeyNext];
        self.usernameField.delegate = self;
        [cell.contentView addSubview:self.usernameField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section == 0 && indexPath.row == InstacatLoginRowPassword) {
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.view.bounds.size.width - 40, 31)];
        self.passwordField.placeholder = @"Password";
        self.passwordField.secureTextEntry = true;
        [self.passwordField setReturnKeyType:UIReturnKeyDone];
        self.passwordField.delegate = self;
        [cell.contentView addSubview:self.passwordField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"Sign In";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if(indexPath.section == 1 && indexPath.row == 0) {
        
        if (self.usernameField.text.length == 0 || self.passwordField.text.length == 0) {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                              message:@"All fields not filled"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil, nil];
            [message show];
        }
        else {
            [ICAPIClient.sharedInstance verifyUsername:self.usernameField.text
                                          withPassword:self.passwordField.text
                                                result:^(BOOL valid) {
                                                    if(valid) {
                                                        [ICGateway.sharedInstance signInWithUsername:self.usernameField.text
                                                                                            password:self.passwordField.text];
                                                        
                                                        [self.navigationController dismissViewControllerAnimated:YES
                                                                                                      completion:NULL];
                                                        self.completion(ICSignInResultSuccess);
                                                    }
                                                    else {
                                                        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                    message:@"Invalid username or password."
                                                                                                   delegate:nil
                                                                                          cancelButtonTitle:@"OK"
                                                                                          otherButtonTitles:nil];
                                                        [a show];
                                                    }
                                                }];
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if(section == 1)
        return @"Sign in to Instacat. The best feline picture sharer in the visible cat universe. If you do not have an account yet, press the 'Sign Up' Button to create an account";
    else
        return nil;
}

-(void) signUpButtonPressed {
    ICSignUpViewController *signup = [[ICSignUpViewController alloc] initWithCompletion:self.completion];
    [self.navigationController pushViewController:signup animated:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.usernameField) {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
