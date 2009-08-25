//
//  2DInputView.m
//  shaker
//
//  Created by Ben Cunningham on 8/24/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import "CartesianInputView.h"
#import "ActiveZone.h"

@implementation CartesianInputView

@synthesize numXQuantizations, numYQuantizations, delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		numYQuantizations = 1;
		numXQuantizations = 1;
		hasReceivedTouch = NO;
		zones = [[NSMutableArray array] retain];
    }
    return self;
}

- (int) numXQuantizations
{
	if(delegate != nil)
	{
		if([delegate respondsToSelector:@selector(numXQuantizationsForInputView:)])
		{
			return [delegate numXQuantizationsForInputView:self];
		}
	}
	
	return numXQuantizations;
}

- (int) numYQuantizations
{
	if(delegate != nil)
	{
		if([delegate respondsToSelector:@selector(numYQuantizationsForInputView:)])
		{
			return [delegate numYQuantizationsForInputView:self];
		}
	}
	
	return numYQuantizations;
}

- (int) xSectionForX:(float)xCoord
{
	float sectionLength = self.frame.size.width/self.numXQuantizations;
	return floor(xCoord/sectionLength);
}
- (int) ySectionForY:(float)yCoord
{
	float sectionLength = self.frame.size.height/self.numYQuantizations;
	return floor(yCoord/sectionLength);
}

- (void) setNumXQuantizations:(int)xQuantizations
{
	numXQuantizations = xQuantizations;
}

- (void) setNumYQuantizations:(int)yQuantizations
{
	numYQuantizations = yQuantizations;
}


- (ActiveZone*) zoneForTouchPoint:(CGPoint)viewCoords
{
	int ySection = [self ySectionForY:viewCoords.y];
	int xSection = [self xSectionForX:viewCoords.x];
	
	for(int i = [zones count]-1; i >=0; i--)
	{
		ActiveZone * zone = [zones objectAtIndex:i];
		if(zone.xIndex == xSection && zone.yIndex == ySection)
		{
			return zone;
		}
	}
	
	return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	hasReceivedTouch = YES;
	
	NSArray * allTouches = [touches allObjects];
	UITouch * firstTouch = [allTouches objectAtIndex:0];
	
	CGPoint touchPoint = [firstTouch locationInView:self];
	ActiveZone * tappedZone = [self zoneForTouchPoint:touchPoint];
	
	if(tappedZone != nil)
	{
		selectedZone = tappedZone;
	}else
	{
		ActiveZone * newZone = [ActiveZone zoneWithX:[self xSectionForX:touchPoint.x] Y:[self ySectionForY:touchPoint.y]];
		[zones addObject:newZone];
		selectedZone = newZone;
		[self setNeedsDisplay];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(selectedZone != nil)
	{
		NSArray * allTouches = [touches allObjects];
		UITouch * firstTouch = [allTouches objectAtIndex:0];
		CGPoint touchPoint = [firstTouch locationInView:self];
		int xSection = [self xSectionForX:touchPoint.x];
		int ySection = [self ySectionForY:touchPoint.y];
		if(selectedZone.xIndex != xSection || selectedZone.yIndex != ySection)
		{
			selectedZone.xIndex = xSection;
			selectedZone.yIndex = ySection;
			[self setNeedsDisplay];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	selectedZone = nil;
}

- (UIColor*) colorForZone:(ActiveZone*)theZone
{
	int index = [zones indexOfObject:theZone];
	int numColors = 5;
	switch(index%numColors)
	{
		case 0:
			return [UIColor redColor];
		case 1:
			return [UIColor blueColor];
		case 2:
			return [UIColor orangeColor];
		case 3:
			return [UIColor purpleColor];
		case 4:
			return [UIColor yellowColor];
	}
	
	return [UIColor redColor];
}

- (NSArray*) zonesWithZone:(ActiveZone*)theZone
{
	NSMutableArray * result = [NSMutableArray array];
	
	for(int i = 0; i < [zones count]; i++)
	{
		ActiveZone * current = [zones objectAtIndex:i];
		if(current.xIndex == theZone.xIndex && current.yIndex == theZone.yIndex)
		{
			[result addObject:current];
		}
	}
	
	return result;
}

- (int) indexOfZone:(ActiveZone*)theZone
{
	NSArray * neighbors = [self zonesWithZone:theZone];
	return [neighbors indexOfObject:theZone];
}

- (void) drawZone:(ActiveZone*)theZone
{
	UIColor * theColor = [self colorForZone:theZone];
	int index = [self indexOfZone:theZone];
	float xSectionLength = self.frame.size.width/self.numXQuantizations;
	float ySectionLength = self.frame.size.height/self.numYQuantizations;
	
	CGPoint begin = CGPointMake(theZone.xIndex*xSectionLength, theZone.yIndex*ySectionLength);
	CGPoint end = CGPointMake(begin.x + xSectionLength, begin.y + ySectionLength);
	
	float insetPercent = 0.1;
	float xInset = index*insetPercent*xSectionLength/2.0;
	float yInset = index*insetPercent*ySectionLength/2.0;
	
	begin = CGPointMake(begin.x+xInset, begin.y+yInset);
	end = CGPointMake(end.x - xInset, end.y - yInset);
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	CGContextBeginPath (context); 
	CGContextMoveToPoint (context, begin.x, begin.y); 
	CGContextAddLineToPoint (context, begin.x, end.y); 
	CGContextAddLineToPoint (context, end.x, end.y); 
	CGContextAddLineToPoint (context, end.x, begin.y); 
	CGContextAddLineToPoint (context, begin.x, begin.y); 
	CGContextClosePath (context);
	
	[theColor setFill];
	[[UIColor blackColor] setStroke]; 
	
	CGContextDrawPath (context, kCGPathFillStroke); 
}

- (void) drawSelectedRects
{
	for(int i = 0; i < [zones count]; i++)
	{
		ActiveZone * zone = [zones objectAtIndex:i];
		[self drawZone:zone];
	}
}

- (void)drawRect:(CGRect)rect {
	//NSLog(@"drawing");
	if([delegate respondsToSelector:@selector(drawRect:)])
	{
		[delegate drawRect:rect];
		return;
	}
	
	CGPoint begin = CGPointZero;
	CGPoint end = CGPointMake(self.frame.size.width, self.frame.size.height);
	
	[[UIColor blackColor] set]; 
	
	for(int x = 0; x < self.numXQuantizations; x++)
	{
		float xCoord = x*(self.frame.size.width/self.numXQuantizations);
		
		CGContextRef context = UIGraphicsGetCurrentContext(); 
		CGContextBeginPath (context); 
		CGContextMoveToPoint (context, xCoord, begin.y); 
		CGContextAddLineToPoint (context, xCoord, end.y); 
		CGContextClosePath (context);
		
		[[UIColor blackColor] setStroke]; 
		
		CGContextDrawPath (context, kCGPathFillStroke); 
	}
	
	for(int y = 0; y < self.numYQuantizations; y++)
	{
		float yCoord = y*(self.frame.size.height/self.numYQuantizations);
		
		CGContextRef context = UIGraphicsGetCurrentContext(); 
		CGContextBeginPath (context); 
		CGContextMoveToPoint (context, begin.x, yCoord); 
		CGContextAddLineToPoint (context, end.x, yCoord); 
		CGContextClosePath (context);
		
		[[UIColor blackColor] setStroke]; 
		
		CGContextDrawPath (context, kCGPathFillStroke); 
	}
	
	if(hasReceivedTouch)
	{
		[self drawSelectedRects];
	}
}


- (void)dealloc {
	[zones release];
	
    [super dealloc];
}


@end
