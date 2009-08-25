//
//  ActiveZone.m
//  shaker
//
//  Created by Ben Cunningham on 8/25/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import "ActiveZone.h"

@implementation ActiveZone

@synthesize xIndex, yIndex, isActive, color, xPercent, yPercent;

+ (ActiveZone*) zoneWithX:(int)x Y:(int)y
{
	ActiveZone * result = [[ActiveZone alloc] init];
	
	result.xIndex = x;
	result.yIndex = y;
	result.isActive = YES;
	result.color = [UIColor redColor];
	
	return [result autorelease];
}

- (void) dealloc
{
	[color release];
	
	[super dealloc];
}

@end
