//
//  YPCursorController.m
//  YayPlayer
//
//  Created by Nik Nyby on 2/24/13.
//  Copyright (c) 2013 Nik Nyby. All rights reserved.
//

#import "YPCursorController.h"

@implementation YPCursorController

- (id)init {
	self = [super init];
	if (self) {
		[self setScreenHeight];
	}
	return self;
}

- (void)setScreenHeight {
	
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

/*
 * Call this function before relying on p.x and p.y
 */
- (void)updateMouseLoc {
	NSPoint mouseLoc = [NSEvent mouseLocation];
	p.x = mouseLoc.x;
	p.y = screenHeight - mouseLoc.y;
}

- (void)moveToCoordWithX:(CGFloat)x Y:(CGFloat)y {
    CGEventRef move = CGEventCreateMouseEvent(
											  NULL, kCGEventMouseMoved,
											  CGPointMake(x, y),
											  kCGMouseButtonLeft // ignored
											  );
	CGEventPost(kCGHIDEventTap, move);
	CFRelease(move);

	[self updateMouseLoc];
}

- (void)moveRight {
	[self updateMouseLoc];

    CGEventRef move = CGEventCreateMouseEvent(
											   NULL, kCGEventMouseMoved,
											   CGPointMake(p.x+BLOCK_WIDTH, p.y),
											   kCGMouseButtonLeft // ignored
											   );
	CGEventPost(kCGHIDEventTap, move);
	CFRelease(move);
}

- (void)moveDown {
	[self updateMouseLoc];

    CGEventRef move = CGEventCreateMouseEvent(
											  NULL, kCGEventMouseMoved,
											  CGPointMake(p.x, p.y+BLOCK_WIDTH),
											  kCGMouseButtonLeft // ignored
											  );
	CGEventPost(kCGHIDEventTap, move);
	CFRelease(move);
}

- (void)click {
	// Make sure p.x and p.y are up to date
	[self updateMouseLoc];

	CGEventRef click_down = CGEventCreateMouseEvent(
													 NULL, kCGEventLeftMouseDown,
													 CGPointMake(p.x, p.y),
													 kCGMouseButtonLeft
													 );

	CGEventRef click_up = CGEventCreateMouseEvent(
												   NULL, kCGEventLeftMouseUp,
												   CGPointMake(p.x, p.y),
												   kCGMouseButtonLeft
												   );

	CGEventPost(kCGHIDEventTap, click_down);
	usleep(10000);
	CGEventPost(kCGHIDEventTap, click_up);

	CFRelease(click_up);
	CFRelease(click_down);
}

- (void)run {
	[self updateMouseLoc];
	
	// Click to make window active
	[self click];
	usleep(WAIT_TIME*8);
	
	// Save starting position
	NSPoint mouseLoc;
	mouseLoc = [NSEvent mouseLocation];
	startX = mouseLoc.x;
	startY = screenHeight - mouseLoc.y;

	// Make array of board co-ordinates
	for (int i = 0; i < GRID_LENGTH; i++) {
		CGFloat myX = startX;
		CGFloat myY = startY;

		for (int j = 0; j < GRID_LENGTH; j++) {
			NSPoint myP;
			myP.x = myX;
			myP.y = myY;

			board[i][j] = myP;

			myX += BLOCK_WIDTH;
		}

		myY += BLOCK_WIDTH;
	}


	for (int ii=0; ii<1; ii++) {
		for (int i=0; i<GRID_LENGTH; i++) {
			for (int j=0; j<GRID_LENGTH; j++) {
				[self click];
				usleep(WAIT_TIME);
				[self moveRight];
				usleep(WAIT_TIME);
			}
			[self moveToCoordWithX:board[0][0].x Y:p.y];
			usleep(WAIT_TIME);
			[self moveDown];
			usleep(WAIT_TIME);
		}
		[self moveToCoordWithX:board[0][0].x Y:board[0][0].y];
	}
}

@end
