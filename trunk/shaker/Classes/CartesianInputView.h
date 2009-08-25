//
//  2DInputView.h
//  shaker
//
//  Created by Ben Cunningham on 8/24/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartesianInputView;

@protocol CartesianInputViewDelegate<NSObject>
@optional
- (int) numXQuantizationsForInputView:(CartesianInputView*)inputView;
- (int) numYQuantizationsForInputView:(CartesianInputView*)inputView;

- (void) inputView:(CartesianInputView*)inputView movedToXSection:(int)xSection ySection:(int)ySection;
- (void) inputView:(CartesianInputView*)inputView movedToXPercent:(float)xPercent yPercent:(float)yPercent;
- (void) drawRect:(CGRect)rect;

@end


@interface CartesianInputView : UIView {
	id<CartesianInputViewDelegate> delegate;
	
	int numXQuantizations;
	int numYQuantizations;
	
	int lastNotifiedX;
	int lastNotifiedY;
	
	CGPoint lastTouch;
	BOOL hasReceivedTouch;
}

@property(nonatomic, assign) int numYQuantizations, numXQuantizations;
@property(nonatomic, assign) id<CartesianInputViewDelegate> delegate;

- (int) currentXSection;
- (int) currentYSection;
- (float) currentXPercent;
- (float) currentYPercent;

@end
