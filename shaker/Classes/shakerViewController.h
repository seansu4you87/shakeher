//
//  shakerViewController.h
//  shaker
//
//  Created by Ben Cunningham on 8/13/09.
//  Copyright Stanford University 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shaker.h"

@interface shakerViewController : UIViewController<ShakerDelegate> {
	Shaker * shaker;
	IBOutlet UISlider * slider;
}

- (void) didShakeWithMagnitude:(float)magnitude;

@end

