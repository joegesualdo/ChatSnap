//
//  FriendsTableViewController.h
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsTableViewController : UITableViewController

@property(nonatomic,strong)PFRelation *friendsRelation;
@property(nonatomic, strong) NSArray *friends;

@end
