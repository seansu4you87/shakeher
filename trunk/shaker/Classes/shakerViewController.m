//
//  shakerViewController.m
//  shaker
//
//  Created by Ben Cunningham on 8/13/09.
//  Copyright Stanford University 2009. All rights reserved.
//

#import "CartesianInputView.h"
#import "shakerViewController.h"
#import "Shaker.h"

@implementation shakerViewController
/*
- (id) init
{
	if(self = [super init])
	{
		NSLog(@"trying init");
	}
	
	return self;
}
 */

// The designated initializer. Override to perform setup that is required before the view is loaded.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSLog(@"initing");
    }
    return self;
}*/

- (void) didShakeWithMagnitude:(float)magnitude
{
	//NSLog(@"Shook u! with magnitude:%f", magnitude);
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView {
	CartesianInputView * inputView = [[CartesianInputView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
	inputView.backgroundColor = [UIColor greenColor];
	inputView.delegate = self;
	self.view = [inputView autorelease];
	
	shaker = [[Shaker alloc] init];
	shaker.delegate = self;
	[shaker start];
	
	//NSLog(@"Loaded shaker view");
}

- (int) numXQuantizationsForInputView:(CartesianInputView*)inputView
{
	return 3;
}

- (int) numYQuantizationsForInputView:(CartesianInputView*)inputView
{
	return 7;
}

- (void) inputView:(CartesianInputView*)inputView movedToXSection:(int)xSection ySection:(int)ySection
{
	NSLog(@"changed to x:%d y:%d", xSection, ySection);
}
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
}
*/



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[shaker stop];
	[shaker release];
	
    [super dealloc];
}

@end
