//
//  SignupViewController.h
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

#pragma mark - IBActions

- (IBAction)signup:(UIButton *)sender;

@end
