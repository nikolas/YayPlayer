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

#import "YPCursorController.h"

@interface YPAppDelegate : NSObject <NSApplicationDelegate> {
}

@property CGDirectDisplayID *displays;
@property CGImageRef image;
@property NSImage *nsImage;
@property (nonatomic, nonatomic) YPCursorController *cursorController;


//@property (assign) IBOutlet NSWindow *window;


//- (void) getDisplay;
- (IBAction)run:(id)sender;

@end
