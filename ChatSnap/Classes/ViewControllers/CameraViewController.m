//
//  CameraViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/17/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup UIImagePicker =======
    // allocate and initialize a ui image picker controller and put it in our property
    self.imagePicker = [[UIImagePickerController alloc] init];
    // tells the image picker to use CameraViewController as it's delegate
    self.imagePicker.delegate = self;
    // We don't want the user editiing
    self.imagePicker.allowsEditing = NO;
    // Setup a conditional, so this works on simulator. Because simulator doesn't have a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // sets the type to be a camera
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        // photo library lets the user choose from all their albums, so can choose from things like the instagram album
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // saved photo album is limited to photos in the camera roll, but not photos in an album like the instagram album
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    // this sets the media types. This will set all the media type that our source type above takes;
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    
    // show the image picker, Don't use animation because we don't want our camera view table to show
    [self presentViewController:self.imagePicker animated:NO completion:nil];
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

@end
