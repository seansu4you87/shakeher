//
//  2DInputView.h
//  shaker
//
//  Created by Ben Cunningham on 8/24/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartesianInputView, ActiveZone;

@protocol CartesianInputViewDelegate<NSObject>
@optional
- (int) numXQuantizationsForInputView:(CartesianInputView*)inputView;
- (int) numYQuantizationsForInputView:(CartesianInputView*)inputView;

- (void) drawRect:(CGRect)rect;

@end


@interface CartesianInputView : UIView {
	id<CartesianInputViewDelegate> delegate;
	
	int numXQuantizations;
	int numYQuantizations;
	
	NSMutableArray * zones;
	ActiveZone * selectedZone;
	
	BOOL hasReceivedTouch;
	BOOL touchHasMoved;
	BOOL touchAdded;
}

@property(nonatomic, assign) int numYQuantizations, numXQuantizations;
@property(nonatomic, assign) id<CartesianInputViewDelegate> delegate;

@end
