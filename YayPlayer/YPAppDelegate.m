//
//  YPAppDelegate.m
//  YayPlayer
//
//  Created by Nik Nyby on 2/20/13.
//  Copyright (c) 2013 Nik Nyby. All rights reserved.
//

#import "YPAppDelegate.h"

@implementation YPAppDelegate

+ (NSArray *)getRGBAsFromImage:(CGImageRef)imageRef atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
	
    // First get the image into your data buffer
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
	
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    unsigned long int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0; ii < count; ++ii){
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
		
        NSColor *acolor = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
	
	free(rawData);
	
	return result;
}

+ (BOOL) pixelIsRed:(NSColor *)color
{
	if ([color redComponent] > [color greenComponent]
		&& [color redComponent] > [color blueComponent]) {
		return YES;
	}

	return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self getDisplay];
	image = CGDisplayCreateImage(displays[0]);
	//NSSize imSize = NSMakeSize(CGImageGetWidth(image), CGImageGetHeight(image));
	//nsImage = [[NSImage alloc] initWithCGImage:image size:imSize];

	/*NSArray *array = [YPAppDelegate getRGBAsFromImage:image atX:0 andY:0 count:1000];
	NSEnumerator *e = [array objectEnumerator];
	id object;
	while (object = [e nextObject]) {
		NSLog(@"hey:P %@\n", object);
	}*/
}

/* Writes the contents of the document to a file or file package located by a URL, formatted to a specified type. */
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL status = NO;
    CGImageDestinationRef dest = nil;
    
    /* Create a new CFStringRef containing a uniform type identifier (UTI) that is the equivalent
     of the passed file extension. */
    CFStringRef utiRef = UTTypeCreatePreferredIdentifierForTag(
                                                               kUTTagClassFilenameExtension,
                                                               (__bridge CFStringRef) typeName,
                                                               kUTTypeData
                                                               );
    if (utiRef == nil) {
        goto bail;
    }
	
    /* Create an image destination writing to absoluteURL. */
    dest = CGImageDestinationCreateWithURL((__bridge CFURLRef)absoluteURL, utiRef, 1, nil);
    CFRelease(utiRef);
    
    if (dest == nil) {
        goto bail;
    }
	
    if (image == nil) {
        goto bail;
    }
	
    /* Set the image in the image destination to be our document image snapshot. */
    CGImageDestinationAddImage(dest, image, NULL);
	
    /* Writes image data to the URL associated with the image destination. */
    status = CGImageDestinationFinalize(dest);
    
bail:
    if (dest) {
        CFRelease(dest);
    }
    return status;
}

/* Populate the Capture menu with a list of displays by iterating over all of the displays. */
- (void)getDisplay {
    CGError             err = CGDisplayNoErr;
    CGDisplayCount      dspCount = 0;
    
    /* How many active displays do we have? */
    err = CGGetActiveDisplayList(0, NULL, &dspCount);
    
    /* If we are getting an error here then their won't be much to display. */
    if (err != CGDisplayNoErr) {
        return;
    }
    
    /* Maybe this isn't the first time though this function. */
    if (displays != nil) {
        free(displays);
    }
    
    /* Allocate enough memory to hold all the display IDs we have. */
    displays = calloc((size_t)dspCount, sizeof(CGDirectDisplayID));
    
    // Get the list of active displays
    err = CGGetActiveDisplayList(dspCount, displays, &dspCount);
    
    /* More error-checking here. */
    if(err != CGDisplayNoErr)
    {
        NSLog(@"Could not get active display list (%d)\n", err);
        return;
    }
}

- (IBAction)run:(id)sender {	
	// Move to 200x200
    CGEventRef move1 = CGEventCreateMouseEvent(
											   NULL, kCGEventMouseMoved,
											   CGPointMake(200, 200),
											   kCGMouseButtonLeft // ignored
											   );
    // Move to 250x250
    CGEventRef move2 = CGEventCreateMouseEvent(
											   NULL, kCGEventMouseMoved,
											   CGPointMake(250, 250),
											   kCGMouseButtonLeft // ignored
											   );
    // Left button down at 250x250
    CGEventRef click1_down = CGEventCreateMouseEvent(
													 NULL, kCGEventLeftMouseDown,
													 CGPointMake(250, 250),
													 kCGMouseButtonLeft
													 );
    // Left button up at 250x250
    CGEventRef click1_up = CGEventCreateMouseEvent(
												   NULL, kCGEventLeftMouseUp,
												   CGPointMake(250, 250),
												   kCGMouseButtonLeft
												   );
	
    // Now, execute these events with an interval to make them noticeable
	for (int i=0; i<10; i++) {
		NSLog(@"Iteration: %d", i);
		CGEventPost(kCGHIDEventTap, move1);
		usleep(100000);
		CGEventPost(kCGHIDEventTap, move2);
		usleep(100000);
	}

    //CGEventPost(kCGHIDEventTap, click1_down);
    //CGEventPost(kCGHIDEventTap, click1_up);
	
    // Release the events
    CFRelease(click1_up);
    CFRelease(click1_down);
    CFRelease(move2);
    CFRelease(move1);
}
@end
