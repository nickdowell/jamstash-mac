//
//  MainWindow.m
//  Jamstash
//
//  Created by Nick Dowell on 21/07/2017.
//  Copyright © 2017 Nick Dowell. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow

- (void)close {
	// Closed window cannot respond to the fake key events we send in response to SPMediaKeyTap
	[NSApp hide:self];
}

@end
