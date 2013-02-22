//
//  YPAppDelegate.h
//  YayPlayer
//
//  Created by Nik Nyby on 2/20/13.
//  Copyright (c) 2013 Nik Nyby. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>

#import "unistd.h"

@interface YPAppDelegate : NSObject <NSApplicationDelegate> {
	@private

	/* displays[] Quartz display ID's */
    CGDirectDisplayID *displays;

	CGImageRef image;
	NSImage *nsImage;
}

//@property (assign) IBOutlet NSWindow *window;

- (void) getDisplay;
- (IBAction)run:(id)sender;

@end
