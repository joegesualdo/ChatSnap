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
-(void)viewWillAppear:(BOOL)animated
{
    // this gets the current user
    PFUser *currentUser = [PFUser currentUser];
    // Only show the root screen if user is logged in
    if (!currentUser) {
      [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    // query the message class (which is PFObject)
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:currentUser.objectId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else{
            self.messages = objects;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Since the segway we created from the inbox to the login, doen't have a button trigger, we must trigger the segue programatically.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inboxItem" forIndexPath:indexPath];
    
    PFObject *message = self.messages[indexPath.row];
    
    cell.textLabel.text = [message objectForKey:@"senderName"];
    return cell;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        // THis will hide the tab bar at the bottom of the login screen
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}


- (IBAction)logout:(UIBarButtonItem *)sender {
  // logs the currentUser out
  [PFUser logOut];
  // performs a segue to login page
  [self performSegueWithIdentifier:@"showLogin" sender:self];
}
@end
