//
//  shakerViewController.h
//  shaker
//
//  Created by Ben Cunningham on 8/13/09.
//  Copyright Stanford University 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shaker.h"
#import "CartesianInputView.h"

@interface shakerViewController : UIViewController<ShakerDelegate, CartesianInputViewDelegate> {
	Shaker * shaker;
}

- (void) didShakeWithMagnitude:(float)magnitude;

@end

