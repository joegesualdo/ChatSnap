//
//  InboxViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "InboxViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Since the segway we created from the inbox to the login, doen't have a button trigger, we must trigger the segue programatically.
    [self performSegueWithIdentifier:@"showLogin" sender:self];
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

@end
