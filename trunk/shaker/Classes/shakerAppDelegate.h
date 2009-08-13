//
//  shakerAppDelegate.h
//  shaker
//
//  Created by Ben Cunningham on 8/13/09.
//  Copyright Stanford University 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class shakerViewController;

@interface shakerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    shakerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet shakerViewController *viewController;

@end

