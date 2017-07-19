//
//  AppDelegate.m
//  Jamstash
//
//  Created by Nick Dowell on 19/07/2017.
//  Copyright © 2017 Nick Dowell. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)hasVisibleWindows {
	[sender.windows.firstObject makeKeyAndOrderFront:sender];
	return NO;
}

@end
