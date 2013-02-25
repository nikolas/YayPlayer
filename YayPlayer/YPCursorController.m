//
//  YPCursorController.m
//  YayPlayer
//
//  Created by Nik Nyby on 2/24/13.
//  Copyright (c) 2013 Nik Nyby. All rights reserved.
//

#import "YPCursorController.h"

@implementation YPCursorController

- (id) init {
	self = [super init];
	if (self) {
		[self setScreenHeight];
	}
	return self;
}

- (void) setScreenHeight {
	
    NSRect screenRect;
    NSArray *screenArray = [NSScreen screens];
    unsigned long screenCount = [screenArray count];
    unsigned long index = 0;
	
    for (; index < screenCount; index++) {
        NSScreen *screen = [screenArray objectAtIndex: index];
        screenRect = [screen frame];
    }

	screenHeight = screenRect.size.height;
}

- (void) updateMouseLoc {
	NSPoint mouseLoc;
	mouseLoc = [NSEvent mouseLocation];
	p.x = mouseLoc.x;
	p.y = screenHeight - mouseLoc.y;
}

- (void) moveRight {
    CGEventRef move = CGEventCreateMouseEvent(
											   NULL, kCGEventMouseMoved,
											   CGPointMake(p.x+GRID_SIZE, p.y),
											   kCGMouseButtonLeft // ignored
											   );
	CGEventPost(kCGHIDEventTap, move);
	CFRelease(move);

	[self updateMouseLoc];
}

- (void) moveDown {
    CGEventRef move = CGEventCreateMouseEvent(
											  NULL, kCGEventMouseMoved,
											  CGPointMake(p.x, p.y+GRID_SIZE),
											  kCGMouseButtonLeft // ignored
											  );
	CGEventPost(kCGHIDEventTap, move);
	CFRelease(move);
	
	[self updateMouseLoc];
}

- (void) click {
	[self updateMouseLoc];

	CGEventRef click_down = CGEventCreateMouseEvent(
													 NULL, kCGEventLeftMouseDown,
													 CGPointMake(p.x, p.y),
													 kCGMouseButtonLeft
													 );
	usleep(5000);

	CGEventRef click_up = CGEventCreateMouseEvent(
												   NULL, kCGEventLeftMouseUp,
												   CGPointMake(p.x, p.y),
												   kCGMouseButtonLeft
												   );

	CGEventPost(kCGHIDEventTap, click_down);
	CGEventPost(kCGHIDEventTap, click_up);

	CFRelease(click_up);
	CFRelease(click_down);
}

- (void) run {
	[self updateMouseLoc];

	NSPoint mouseLoc;
	mouseLoc = [NSEvent mouseLocation];
	startx = mouseLoc.x;

    // Now, execute these events with an interval to make them noticeable
	for (int i=0; i<GRID_LENGTH; i++) {
		for (int j=0; j<GRID_LENGTH; j++) {
			[self click];
			usleep(WAIT_TIME);
			[self moveRight];
			usleep(WAIT_TIME);
		}
		NSLog(@"%f", startx);
		p.x = startx;
		[self moveDown];
		usleep(WAIT_TIME);
	}
	
    //CGEventPost(kCGHIDEventTap, click1_down);
    //CGEventPost(kCGHIDEventTap, click1_up);
	
    // Release the events
    /*CFRelease(click1_up);
    CFRelease(click1_down);
    CFRelease(move2);
    CFRelease(move1);*/
}

@end
