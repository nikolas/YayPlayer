//
//  YPCursorController.h
//  YayPlayer
//
//  Created by Nik Nyby on 2/24/13.
//  Copyright (c) 2013 Nik Nyby. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BLOCK_WIDTH 40
#define GRID_LENGTH 8
#define WAIT_TIME 180000


@interface YPCursorController : NSObject {
	NSPoint p;
	CGFloat screenHeight;
	CGFloat startX;
	CGFloat startY;
	NSPoint board[GRID_LENGTH][GRID_LENGTH];
}

- (void) run;

@end