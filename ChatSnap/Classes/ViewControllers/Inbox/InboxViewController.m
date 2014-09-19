//
//  InboxViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "ImageViewController.h"

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
        //returns so we don't run anymore code
        return;
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
    
    // we allocate the movie player so we can assign it properties later
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    
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
    
    NSString *fileType = [message objectForKey:@"fileType"];
    
    if ([fileType isEqualToString:@"image"]) {
        //all default cell have an image view on the left side
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    } else{
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    cell.textLabel.text = [message objectForKey:@"senderName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedMessage = self.messages[indexPath.row];
    
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else{
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        //sets the url for the video
        self.moviePlayer.contentURL = fileUrl;
        //this sets up oru movei player to play
        [self.moviePlayer prepareToPlay];
        
        // This will provide us with a thumbnail of the first keyframe while it waits for the movie to load
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        [self.view addSubview:self.moviePlayer.view];
        // This sets it to full screem, can only be called after we add the view to our heirachy
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    // Delete!
    NSMutableArray *recipientsIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    // If you are the only recipient in the recipientId array, then delete the message
    if ([recipientsIds count] == 1){
        [self.selectedMessage deleteInBackground];
    } else{
        // this updates it locally
        [recipientsIds removeObject:[[PFUser currentUser]objectId]];
        // Save the data to parse
        [self.selectedMessage setObject:recipientsIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }
    
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        // THis will hide the tab bar at the bottom of the login screen
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:@"showImage"]){
        ImageViewController *destinationViewController = (ImageViewController *)segue.destinationViewController;
        // Hides the tab bar in image view
        [destinationViewController setHidesBottomBarWhenPushed:YES];
        destinationViewController.message = self.selectedMessage;
    }
}


- (IBAction)logout:(UIBarButtonItem *)sender {
  // logs the currentUser out
  [PFUser logOut];
  // performs a segue to login page
  [self performSegueWithIdentifier:@"showLogin" sender:self];
}
@end
