//
//  Shaker.m
//  shaker
//
//  Created by Ben Cunningham on 8/24/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import "Shaker.h"

@implementation Shaker

@synthesize delegate, lastAcceleration;

- (id) init
{
	if(self = [super init])
	{
		
	}
	
	return self;
}

- (void) dealloc
{
	[lastAcceleration release];
	
	[super dealloc];
}

- (void) start
{
	[UIAccelerometer sharedAccelerometer].delegate = self;
	[UIAccelerometer sharedAccelerometer].updateInterval = 0.0001;
}

- (void) stop
{
	[UIAccelerometer sharedAccelerometer].delegate = nil;
	delegate = nil;
}

- (BOOL) accelerationIsShake:(UIAcceleration*)acceleration
{
	return YES;
}

+ (float) differenceFromAcceleration:(UIAcceleration*)first toAcceleration:(UIAcceleration*)second
{
	return pow(pow(first.x - second.x,2)+pow(first.y - second.y,2)+pow(first.z - second.z,2), 0.5);
}

+ (float) magnitudeOfAcceleration:(UIAcceleration*)acceleration
{
	return pow(pow(acceleration.x,2)+pow(acceleration.y,2)+pow(acceleration.z,2), 0.5);
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if(lastAcceleration == nil)
	{
		self.lastAcceleration = acceleration;
	}
	
	if([self accelerationIsShake:acceleration])
	{
		[delegate didShakeWithMagnitude:[Shaker magnitudeOfAcceleration:acceleration]];
	}
	
	self.lastAcceleration = acceleration;
	
	NSLog(@"accelerated with x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
}

@end
