//
//  TLSignUpViewController.m
//  testLogin
//
//  Created by Manik Kalra on 18/04/14.
//  Copyright (c) 2014 Manik Kalra. All rights reserved.
//

#import "ICSignUpViewController.h"

typedef NS_ENUM(NSInteger, InstacatSignInRows) {
    InstacatSignUpRowName,
    InstacatSignUpRowUsername,
    InstacatSignUpRowPassword,
    InstacatSignUpRowCheckPassword,
    InstacatSignUpRowCount,
};


@interface ICSignUpViewController ()

@property(nonatomic, strong) UITextField *nameField;
@property(nonatomic, strong) UITextField *usernameField;
@property(nonatomic, strong) UITextField * passwordField;
@property(nonatomic, strong) UITextField *checkPasswordField;

@end

@implementation ICSignUpViewController

- (instancetype)initWithCompletion:(void (^)())completion {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.completion = completion;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sign Up";
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(dismiss)];
}

- (void)dismiss {
    self.completion(ICSignInResultCancelled);
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
        return InstacatSignUpRowCount;
    else if(section == 1)
        return 1;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];

    if(indexPath.section == 0 && indexPath.row == InstacatSignUpRowName) {
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.view.bounds.size.width - 40, 31)];
        self.nameField.placeholder = @"Enter Your Name";
        self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self.nameField setReturnKeyType:UIReturnKeyNext];
        self.nameField.delegate = self;
        [cell.contentView addSubview:self.nameField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 0 && indexPath.row == InstacatSignUpRowUsername) {
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.view.bounds.size.width - 40, 31)];
        self.usernameField.placeholder = @"Enter a Username";
        self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.usernameField setReturnKeyType:UIReturnKeyNext];
        self.usernameField.delegate = self;
        [cell.contentView addSubview:self.usernameField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 0 && indexPath.row == InstacatSignUpRowPassword) {
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.view.bounds.size.width - 40, 31)];
        self.passwordField.placeholder = @"Choose a Password";
        self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.passwordField.secureTextEntry = true;
        [self.passwordField setReturnKeyType:UIReturnKeyNext];
        self.passwordField.delegate = self;
        [cell.contentView addSubview:self.passwordField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 0 && indexPath.row == InstacatSignUpRowCheckPassword) {
        self.checkPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.view.bounds.size.width - 40, 31)];
        self.checkPasswordField.placeholder = @"Re-enter Password";
        self.checkPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.checkPasswordField.secureTextEntry = true;
        [self.checkPasswordField setReturnKeyType:UIReturnKeyDone];
        self.checkPasswordField.delegate = self;
        [cell.contentView addSubview:self.checkPasswordField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"Sign Up";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 1)
        return @"Sign up for instacat. The picture sharer preferred by felines everywhere.\n"
            "Note : Nine lives required to create an account.";
    else
        return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.nameField) {
        [textField resignFirstResponder];
        [self.usernameField becomeFirstResponder];
    }
    else if (textField == self.usernameField) {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [textField resignFirstResponder];
        [self.checkPasswordField becomeFirstResponder];
    }
    else if (textField == self.checkPasswordField) {
        [textField resignFirstResponder];
    }
    
    return NO;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if(indexPath.row == 0 && indexPath.section == 1){
        
        if (self.nameField.text.length == 0 || self.usernameField.text.length == 0 || self.passwordField.text.length == 0) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                              message:@"All fields are not filled"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        else if(![self.passwordField.text isEqualToString:self.checkPasswordField.text]) {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                              message:@"Passwords do not match"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];

        }
        else {
            [ICAPIClient.sharedInstance signUpWithHandle:self.usernameField.text
                                                password:self.passwordField.text
                                                    name:self.nameField.text
                                                 success:^(NSError *err) {
                                                     if(err == nil) {
                                                         [ICGateway.sharedInstance signInWithUsername:self.usernameField.text
                                                                                             password:self.passwordField.text];
                                                         
                                                         [self.navigationController dismissViewControllerAnimated:YES
                                                                                                       completion:NULL];
                                                         self.completion(ICSignInResultSuccess);
                                                     }
                                                     else {
                                                         UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                     message:err.localizedDescription
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"OK"
                                                                                           otherButtonTitles:nil];
                                                         [a show];
                                                     }
                                                 }];
        }
        
    }
}


@end
