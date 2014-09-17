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
    
    // Defensive programming to makes sure there is no image and no video file path
    if (self.image == nil && [self.videoFilePath length] == 0) {
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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This will store the relation in self.friendsRelatioin
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    self.recipients = [[NSMutableArray alloc]init];
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
    
    // This prevent checkmarks showing on cell that we didn't check. This happens becuase the table view may have resused a cell that we had a checkmark on
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // We are only going to store objectIds in our recipients array because it will be faster
        [self.recipients addObject:user.objectId];
    } else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        // remove the objectId from recipients array
        [self.recipients removeObject:user.objectId];
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
        }
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
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
  [self reset];
  // Go to inbox tab
  [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(UIBarButtonItem *)sender {
  // This is defensive programming if there is no image or video
  if (self.image == nil && [self.videoFilePath length] == 0) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again" message:@"Please capture or select a photo or video to share!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    [self presentViewController:self.imagePicker animated:NO completion:nil];
  } else{
      
    // Go to inbox tab
    [self.tabBarController setSelectedIndex:0];
    [self uploadMessage];
  }
}

#pragma mark - Helper methods


-(void)uploadMessage
{
  NSData   *fileData;
  NSString *fileName;
  NSString *fileType;
  
    //Check if its an image or video
    if (self.image != nil) {
    // If image, shrink it
      // this will create an image that is teh size of the iphone 320 by 480. If you will be running on other devices you will need to add these
      UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
      // We use png because it can hold the same data as jpeg, but jpeg cant hold same data as png
      // we convert image into NSData (specifically png)
      fileData = UIImagePNGRepresentation(newImage);
      fileName = @"image.png";
      fileType = @"image";
    } else {
      // WE convert the video into NSData
      fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
      fileName = @"video.mov";
      fileType = @"video";
    }
  // Create a PFfile with our move of vido
  PFFile *file = [PFFile fileWithName:fileName data:fileData];
  // Save the file to parse
  [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (error) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:@"Please try sending messge again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
      [alertView show];
    } else {
      // initiate a new PFObject
      PFObject *message = [PFObject objectWithClassName:@"Messages"];
      // can associate PFFile onto a PFObject
      [message setObject:file forKey:@"file"];
      // set file type
      // this will be helpful when we are viewing messages in the inbox
      [message setObject:fileType forKey:@"fileType"];
      // set recipients
      [message setObject:self.recipients forKey:@"recipientIds"];
      [message setObject:[[PFUser currentUser] objectId] forKey: @"senderId"];
      [message setObject:[[PFUser currentUser] username] forKey: @"senderName"];
      
      [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:@"Please try sending messge again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
          [alertView show];
        } else{
            // reset everything when it's successful
            [self reset];
          // everything worked!
        }
      }];
    }
    
  }];
  
}

- (void)reset
{
    // reset image, videoFilePath, and recipients propeties
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
  //CGsize defines the rectangle that will be used as the size of our new image
  // CG stands for core graphics
  CGSize newSize = CGSizeMake(width, height);
  // create an actual rectangel using these specifications
  CGRect newRectangle = CGRectMake(0, 0, width, height);
  //Need to create a context in which to manuipulate our image
  // This created a bitmap graphic context for a specified rectangular area. We can then draw whatever we want in this context, then we capture the resulting image. So we are going to redraw the big iimage from the camera and redraw it as a smaller version of its self. Then we'll capture teh cotext in a new variable
  UIGraphicsBeginImageContext(newSize);
  [self.image drawInRect:newRectangle];
  // so nowthe smaller version of our index exists in the bitmap context we created
  UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  // now we have the new resized image in a variabel
  // Now we need to end the context. This is the opposite method as UIGraphicsBeginImageContext(newSize) above
  // YOU ALWAYS need a beginning and ended paried together
  UIGraphicsEndImageContext();
  
  return resizedImage;
}

@end
