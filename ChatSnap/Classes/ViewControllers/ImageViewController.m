//
//  ImageViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/17/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // The 'file' key on the message object only contains a reference to the image, not the image itsself
    // The file is stored as a PFFile
    //PFfile class has a url property that contains the url to get the image from parse.com
    PFFile *imageFile = [self.message objectForKey:@"file"];
    // This gets the url and stores it in NSURL
    NSURL *imageFileUrl = [[NSURL alloc]initWithString:imageFile.url];
    // This will get the image file from the interet
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    
    // So now you get the image from the data using imageWithData and set it on the UIImageView
    self.imageView.image = [UIImage imageWithData:imageData];
    
    // We wnat to make the navigation title the name of the person who sent the message
    // This lets you change the title in the navigation
    NSString *senderName = [self.message objectForKey:@"senderName"];
    self.navigationItem.title = senderName;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
