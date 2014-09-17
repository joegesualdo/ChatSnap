//
//  EditFriendsTableViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "EditFriendsTableViewController.h"

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    // This creates a query for all the users
    // [PFUser query] is a query for ALL the users
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else{
            self.allUsers = objects;
            NSLog(@"Users: %@", self.allUsers);
            // We need to reload the table, because table view loads before self.allUsers is populated
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // sets the current user to self.currentUser
    self.currentUser = [PFUser currentUser];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    
    PFUser *user = self.allUsers[indexPath.row];
    
    // Add checkmark if user is already a friend
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // removes the gray background on selection when clicked
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.textLabel.text = user.username;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // find the specific table view cell that was clicked
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = self.allUsers[indexPath.row];
    
    // Defines a relation
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    // Remove the checkmark, and the remote relation, and uers form self.friends if cell is clicked on
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        // find the friend in the self.friend array, and remove it
        for(PFUser *friend in self.friends){
            // check the parse id to see if there is a match
            if ([friend.objectId isEqualToString:user.objectId]){
                [friendsRelation removeObject:user];
                [self.friends removeObject:friend];
                // This is optimization so it doen't continue looping after we find it
                break;
            }
        }
    // Add the checkmark, and the remote relation, and uers form self.friends if cell is clicked on
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [friendsRelation addObject:user];
        [self.friends addObject:user];
        // This will save the relations we created above
    }
    // This will save the relations we created above
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Helper methods

-(BOOL)isFriend:(PFUser *)user
{
    for(PFUser *friend in self.friends){
        // check the parse id to see if there is a match
        if ([friend.objectId isEqualToString:user.objectId]){
            return YES;
        }
    }
    // if no match was found, return no
    return NO;
}


@end
