//
//  ActiveZone.m
//  shaker
//
//  Created by Ben Cunningham on 8/25/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import "ActiveZone.h"

@implementation ActiveZone

@synthesize xIndex, yIndex, isActive;

+ (ActiveZone*) zoneWithX:(int)x Y:(int)y
{
	ActiveZone * result = [[ActiveZone alloc] init];
	
	result.xIndex = x;
	result.yIndex = y;
	result.isActive = YES;
	
	return [result autorelease];
}

@end
