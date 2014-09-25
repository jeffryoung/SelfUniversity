// =================================================================================================================
//
//  COString.h
//  iLearn University
//
//  Created by Jeffrey Young on 9/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
//  An subclass extention of NSString, this utility class adds additional functionality to help with common string
//  utility methods.
//
// =================================================================================================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CoreFoundation.h>

@interface COString : NSString

// =================================================================================================================
#pragma mark - Misc string methods
// =================================================================================================================

- (BOOL) isEqualToStringIgnoringCase:(NSString*) string;
- (NSString*) firstFiveCharacter;
- (NSString*) firstTenCharacter;

// =================================================================================================================
#pragma mark - MD5
// =================================================================================================================

- (NSString*) md5; // lowercase result
+ (NSString*) md5HashFromString:(NSString*) source; // UPPERCASE result
+ (NSString*) uniqueIDFromString:(NSString*) source; //Alias for the above

// =================================================================================================================
#pragma mark - URL Encoding
// =================================================================================================================

- (NSString*) urlEncode;
- (NSString*) urlDecode;

// =================================================================================================================
#pragma mark - Date detector
// =================================================================================================================

- (NSDate*) dateValue;

// =================================================================================================================
#pragma mark - (NSStringDrawing) compatibility
// =================================================================================================================

- (CGSize) _sizeWithFont:(UIFont*) font;

// =================================================================================================================
#pragma mark - (UIStringDrawing compatibility
// =================================================================================================================

- (void) _drawAtPoint:(CGPoint) point withFont:(UIFont*) font foregroundColor:(UIColor*) color;
- (void) _drawInRect:(CGRect) frame withFont:(UIFont*) font foregroundColor:(UIColor*) color;

@end
