// -------------------------------------------------------
// LoginItemController.h
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#import <Cocoa/Cocoa.h>

@interface ATLoginItemController : NSObject {}

+ (ATLoginItemController *)sharedController;

@property BOOL loginItemEnabled;

@end
