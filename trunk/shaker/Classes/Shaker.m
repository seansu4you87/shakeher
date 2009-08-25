//
//  Shaker.m
//  shaker
//
//  Created by Ben Cunningham on 8/24/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import "Shaker.h"

#define ACCELERATION_THRESHOLD 0.85
#define MIN_TIME 0.15

@implementation Shaker

@synthesize delegate, lastAcceleration, lastShake;

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
	[lastShake release];
	
	[super dealloc];
}

- (void) start
{
	NSLog(@"started shaker fer u");
	[UIAccelerometer sharedAccelerometer].delegate = self;
	[UIAccelerometer sharedAccelerometer].updateInterval = 0;//update as much as possible
}

- (void) stop
{
	[UIAccelerometer sharedAccelerometer].delegate = nil;
	delegate = nil;
}

- (BOOL) accelerationIsShake:(UIAcceleration*)acceleration
{
	BOOL hardEnough = [Shaker differenceFromAcceleration:lastAcceleration toAcceleration:acceleration] > ACCELERATION_THRESHOLD;
	BOOL changedEnough = [Shaker acceleration:acceleration changedDirectionFrom:lastAcceleration];
	BOOL lateEnough = acceleration.timestamp - lastShake.timestamp > MIN_TIME;
	
	return hardEnough && changedEnough && lateEnough;
}

+ (BOOL) acceleration:(UIAcceleration*)first changedDirectionFrom:(UIAcceleration*)second
{	
	return ((first.x < 0 && second.x > 0) || (first.x > 0 && second.x < 0)) 
		|| ((first.y < 0 && second.y > 0) || (first.y > 0 && second.y < 0)) 
		|| ((first.z < 0 && second.z > 0) || (first.z > 0 && second.z < 0));
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
		[delegate didShakeWithMagnitude:[Shaker differenceFromAcceleration:lastAcceleration toAcceleration:acceleration]];
		self.lastShake = acceleration;
	}
	
	self.lastAcceleration = acceleration;
	
	//NSLog(@"accelerated with x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
}

@end
