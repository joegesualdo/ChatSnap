//
//  CameraViewController.h
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/17/14.
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import <UIKit/UIKit.h>

// Why does this inherit from UITableViewController and not UIImagePickerController?
// Because we want to put the camera on top of (modally) a ui table view controller (our images table view)
// Must to conform to both UIImagePickerControllerDelegate and UINavigationControllerDelegate protocol to use UIImagePickerController. these delegate methods are called when the uiimage picker does things, like takes a picture, chooses a photo etc
// UIImagePciker controller actually inherits from UINavigationController
@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// We make this so we can reference this UIImagePickerController from all withing our camera view controller
// Since UIImagePickerController will be a modal it will entirely exist within the contruct of this camera view controler
@property(strong, nonatomic)UIImagePickerController *imagePicker;

@end
