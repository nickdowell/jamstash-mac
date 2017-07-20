//
//  MainWindowController.m
//  Jamstash
//
//  Created by Nick Dowell on 19/07/2017.
//  Copyright © 2017 Nick Dowell. All rights reserved.
//

#import "MainWindowController.h"

#import "SPMediaKeyTap.h"

#import <WebKit/WebKit.h>

@interface WebPreferences (WebPrivate)

- (void)_setLocalStorageDatabasePath:(NSString *)path;

- (void)setLocalStorageEnabled:(BOOL)localStorageEnabled;

@end

@interface MainWindowController () <WebFrameLoadDelegate>

@property (nonatomic, strong) WebView *webView;

@property (nonatomic, strong) SPMediaKeyTap *keyTap;

@end

@implementation MainWindowController

+ (void)load {
	NSString *applicationSupport = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
	NSString *storagePath = [applicationSupport stringByAppendingPathComponent:[NSBundle mainBundle].bundleIdentifier];
	[[WebPreferences standardPreferences] _setLocalStorageDatabasePath:storagePath];
	[[WebPreferences standardPreferences] setLocalStorageEnabled:YES];
}

- (void)windowDidLoad {
    [super windowDidLoad];

	self.webView = [[WebView alloc] initWithFrame:self.window.contentLayoutRect];
	self.webView.frameLoadDelegate = self;
	self.window.contentView = self.webView;

	NSURL *url = [NSURL URLWithString:@"http://jamstash.com"];
	[self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:url]];

	self.keyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
	if ([SPMediaKeyTap usesGlobalMediaKeyTap])
		[self.keyTap startWatchingMediaKeys];
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
	self.window.title = title;
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame {
	NSButton *button = [self.window standardWindowButton:NSWindowDocumentIconButton];
	button.image = image;
}

- (void)mediaKeyTap:(SPMediaKeyTap *)keyTap receivedMediaKeyEvent:(NSEvent *)event {
	NSAssert(event.type == NSEventTypeSystemDefined && event.subtype == SPSystemDefinedEventMediaKeys, @"Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:");

	// here be dragons...
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	BOOL keyIsPressed = (((keyFlags & 0xFF00) >> 8)) == 0xA;

	if (!keyIsPressed)
		return;

	switch (keyCode) {
		case NX_KEYTYPE_PLAY:
			[self simulateKeyDownWithKeyCode:49 character:' '];
			break;

		case NX_KEYTYPE_FAST:
			[self simulateKeyDownWithKeyCode:124 character:NSRightArrowFunctionKey];
			break;

		case NX_KEYTYPE_REWIND:
			[self simulateKeyDownWithKeyCode:123 character:NSLeftArrowFunctionKey];
			break;

		default:
			// More cases defined in hidsystem/ev_keymap.h
			break;
	}
}

- (void)simulateKeyDownWithKeyCode:(unsigned short)keyCode character:(unichar)character {
	NSString *chars = [NSString stringWithCharacters:&character length:1];
	[self.window sendEvent:[NSEvent keyEventWithType:NSEventTypeKeyDown
											location:NSZeroPoint
									   modifierFlags:0
										   timestamp:0
										windowNumber:0
											 context:[NSGraphicsContext currentContext]
										  characters:chars
						 charactersIgnoringModifiers:chars
										   isARepeat:NO
											 keyCode:keyCode]];
}

@end
