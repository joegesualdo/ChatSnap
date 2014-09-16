//
//  InboxViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // this gets the current user
    PFUser *currentUser = [PFUser currentUser];
    // Only show the root screen if user is logged in
    if (!currentUser) {
      [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    // Since the segway we created from the inbox to the login, doen't have a button trigger, we must trigger the segue programatically.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inboxItem" forIndexPath:indexPath];
    
    return cell;
}


- (IBAction)logout:(UIBarButtonItem *)sender {
  // logs the currentUser out
  [PFUser logOut];
  // performs a segue to login page
  [self performSegueWithIdentifier:@"showLogin" sender:self];
}
@end
