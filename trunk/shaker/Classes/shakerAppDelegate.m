//
//  shakerAppDelegate.m
//  shaker
//
//  Created by Ben Cunningham on 8/13/09.
//  Copyright Stanford University 2009. All rights reserved.
//

#import "shakerAppDelegate.h"
#import "shakerViewController.h"

@implementation shakerAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
