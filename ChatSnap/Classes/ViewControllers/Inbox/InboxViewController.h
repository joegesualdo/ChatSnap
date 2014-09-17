//
//  InboxViewController.h
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController

@property(nonatomic, strong)NSArray *messages;
@property(nonatomic,strong)PFObject *selectedMessage;
@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;

- (IBAction)logout:(UIBarButtonItem *)sender;

@end
