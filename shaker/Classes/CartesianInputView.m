//
//  2DInputView.m
//  shaker
//
//  Created by Ben Cunningham on 8/24/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import "CartesianInputView.h"


@implementation CartesianInputView

@synthesize numXQuantizations, numYQuantizations, delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		numYQuantizations = 1;
		numXQuantizations = 1;
		lastNotifiedX = 0;
		lastNotifiedY = 0;
		hasReceivedTouch = NO;
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

- (int) currentXSection
{
	float sectionLength = self.frame.size.width/self.numXQuantizations;
	return floor(lastTouch.x/sectionLength);
}
- (int) currentYSection
{
	float sectionLength = self.frame.size.height/self.numYQuantizations;
	return floor(lastTouch.y/sectionLength);
}
- (float) currentXPercent
{
	return lastTouch.x/self.frame.size.width;
}
- (float) currentYPercent
{
	return lastTouch.y/self.frame.size.height;
}

- (void) setNumXQuantizations:(int)xQuantizations
{
	numXQuantizations = xQuantizations;
}

- (void) setNumYQuantizations:(int)yQuantizations
{
	numYQuantizations = yQuantizations;
}

- (void) respondToTouches:(NSSet*)touches
{
	hasReceivedTouch = YES;
	
	if([touches count] > 0)
	{
		NSArray * allTouches = [touches allObjects];
		UITouch * firstTouch = [allTouches objectAtIndex:0];
		lastTouch = [firstTouch locationInView:self];
		
		if([delegate respondsToSelector:@selector(inputView: movedToXSection: ySection:)])
		{
			BOOL shouldUpdate = lastNotifiedX != [self currentXSection] || lastNotifiedY != [self currentYSection];
			
			if(shouldUpdate)
			{
				lastNotifiedX = [self currentXSection];
				lastNotifiedY = [self currentYSection];
				[delegate inputView:self movedToXSection:lastNotifiedX ySection:lastNotifiedY];
				[self setNeedsDisplay];
			}
		}
			
		if([delegate respondsToSelector:@selector(inputView: movedToXPercent: yPercent:)])
		{
			[delegate inputView:self movedToXPercent:[self currentXPercent] yPercent:[self currentYPercent]];
		}
		
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self respondToTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self respondToTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self respondToTouches:touches];
}

- (void) drawSelectedRect
{
	CGPoint begin = CGPointMake([self currentXSection]*(self.frame.size.width/self.numXQuantizations), [self currentYSection]*(self.frame.size.height/self.numYQuantizations));
	CGPoint end = CGPointMake(begin.x + (self.frame.size.width/self.numXQuantizations), begin.y + (self.frame.size.height/self.numYQuantizations));
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	CGContextBeginPath (context); 
	CGContextMoveToPoint (context, begin.x, begin.y); 
	CGContextAddLineToPoint (context, begin.x, end.y); 
	CGContextAddLineToPoint (context, end.x, end.y); 
	CGContextAddLineToPoint (context, end.x, begin.y); 
	CGContextAddLineToPoint (context, begin.x, begin.y); 
	CGContextClosePath (context);
	
	[[UIColor redColor] setFill];
	[[UIColor blackColor] setStroke]; 
	
	CGContextDrawPath (context, kCGPathFillStroke); 
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
		[self drawSelectedRect];
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
