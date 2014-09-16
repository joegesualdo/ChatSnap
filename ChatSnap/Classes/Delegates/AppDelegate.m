//
//  AppDelegate.m
//  ChatSnap
//
//  Created by Joe Gesualdo on 9/16/14
//  Copyright (c) 2014 joegesualdo. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup Parse
    [Parse setApplicationId:@"1Pxs7jMERolexiVJkT4CcgdygOYYAALOzMcx8TLJ"
                  clientKey:@"aQ6HeJIFd88cFKeDHgwqFeqOkFTkxogNnW926DDN"];
    return YES;
}

@end
