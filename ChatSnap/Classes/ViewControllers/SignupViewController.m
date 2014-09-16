//
//  SignupViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  // Put focus for keyboard on username
  [self.usernameField becomeFirstResponder];
}

- (IBAction)signup:(UIButton *)sender {
  
  // This stringByTrimmingCharactersInSet method trims the trailing whitespace and new lines
  NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  // Shows an alert if fields are blank
  if ([username length] == 0 || [email length] == 0 || [password length] == 0) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"Please enter a username, password, and email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
    [alertView show];
  } else {
      [self signupUserWithUsername:username password:password email:email];
  }
}

/**
 *  Signes up a user and sends info to parse
 *
 *  @param username The username for the user
 *  @param password The password for the user
 *  @param email    The email for the user
 *
 *  @return The PFUser object
 */
- (PFUser *)signupUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email {
  PFUser *user = [PFUser user];
  user.username = username;
  user.password = password;
  user.email = email;
  
  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
        // Whenver we have a view controller nested in a navigation controler we have a property of navigationController on it (self). And then we can access any of the views within that navigation controller.
        // In this case, we want to navigate to the rootViewController (the inbox view)
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
      NSString *errorString = [error userInfo][@"error"];
      // Show the errorString somewhere and let the user try again.
        NSLog(@"Error: %@",errorString);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
  }];
  return user;
}
@end
