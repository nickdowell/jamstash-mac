//
//  MainWindowController.m
//  Jamstash
//
//  Created by Nick Dowell on 19/07/2017.
//  Copyright © 2017 Nick Dowell. All rights reserved.
//

#import "MainWindowController.h"

#import <WebKit/WebKit.h>

@interface WebPreferences (WebPrivate)

- (void)_setLocalStorageDatabasePath:(NSString *)path;

- (void)setLocalStorageEnabled:(BOOL)localStorageEnabled;

@end

@interface MainWindowController () <WebFrameLoadDelegate>

@property (nonatomic, strong) WebView *webView;

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
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
	self.window.title = title;
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame {
	NSButton *button = [self.window standardWindowButton:NSWindowDocumentIconButton];
	button.image = image;
}

@end
