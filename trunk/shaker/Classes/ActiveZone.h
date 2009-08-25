//
//  ActiveZone.h
//  shaker
//
//  Created by Ben Cunningham on 8/25/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActiveZone : NSObject {
	int xIndex;
	int yIndex;
	
	BOOL isActive;
	
	UIColor * color;
}

@property(nonatomic, assign) int xIndex, yIndex;
@property(nonatomic, assign) BOOL isActive;
@property(nonatomic, retain) UIColor * color;

+ (ActiveZone*) zoneWithX:(int)x Y:(int)y;

@end
