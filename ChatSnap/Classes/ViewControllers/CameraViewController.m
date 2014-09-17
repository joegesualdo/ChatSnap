//
//  CameraViewController.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/17/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else{
            self.friends = objects;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
    // WHy is this in viewWillAppear and NOT viewDidLoad?
    // Because viewDidLoad will only get called the first time the view loads, so if we dismiss the camera and come back, it wont dispay. BUt viewWillAppear is run everytime this view shows
    // Setup UIImagePicker =======
    // allocate and initialize a ui image picker controller and put it in our property
    self.imagePicker = [[UIImagePickerController alloc] init];
    // tells the image picker to use CameraViewController as it's delegate
    self.imagePicker.delegate = self;
    // We don't want the user editiing
    self.imagePicker.allowsEditing = NO;
    // limits videos to 10 seconds
    self.imagePicker.videoMaximumDuration = 10;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This will store the relation in self.friendsRelatioin
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFUser *user = self.friends[indexPath.row];
    
    cell.textLabel.text = user.username;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - Camera picker delegates

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // This will dismiss the camera
    [self dismissViewControllerAnimated:NO completion:nil];
    // This will bring us the the first tab (inbox) of our tab bar
    [self.tabBarController setSelectedIndex:0];
}

// This gets called when user chooses a photo
// everythign is stored in the 'info' parameter
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // This will the media type that was returned and store it as a string
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // We check if that media is an image
    // kUTTypeImage is a constant from the library we imported above <<MobileCoreServices/UTCoreTypes.h>; It has multiple types
    // then we need to cast the kUTType to an string
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // This will get the original image the user took and store it in our property
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // Only want write that image to the photo album if you took the picture, not if you chose from the photo album. 
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        } else {
            // calling the path method on the url gives us the local ios path as a string
            self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
            if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                // This will save the file to the album
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
                }
            }
        }
    }
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
