//
//  Shaker.h
//  shaker
//
//  Created by Ben Cunningham on 8/24/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShakerDelegate

- (void) didShakeWithMagnitude:(float)magnitude;

@end


@interface Shaker : NSObject<UIAccelerometerDelegate> {
	id<ShakerDelegate> delegate;
	UIAcceleration * lastAcceleration;
}

@property(nonatomic, assign) id<ShakerDelegate> delegate;
@property(nonatomic, retain) UIAcceleration * lastAcceleration;

- (void) start;
- (void) stop;

- (BOOL) accelerationIsShake:(UIAcceleration*)acceleration;

+ (float) magnitudeOfAcceleration:(UIAcceleration*)acceleration;
+ (float) differenceFromAcceleration:(UIAcceleration*)first toAcceleration:(UIAcceleration*)second;

@end
