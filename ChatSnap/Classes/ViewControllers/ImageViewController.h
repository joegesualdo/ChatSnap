//
//  ImageViewController.h
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/17/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property(nonatomic,strong)PFObject *message;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
