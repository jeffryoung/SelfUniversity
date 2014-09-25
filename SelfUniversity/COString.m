// =================================================================================================================
//
//  COString.m
//  iLearn University
//
//  Created by Jeffrey Young on 9/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COString.h"

@implementation COString : NSString

// =================================================================================================================
#pragma mark - Misc string methods
// =================================================================================================================

- (BOOL) isEqualToStringIgnoringCase:(NSString*) string
{
    return [self.lowercaseString isEqualToString:string.lowercaseString];
}

// -----------------------------------------------------------------------------------------------------------------

- (NSString*) firstFiveCharacter
{
    if (self.length <= 5) return self;
    return [NSString stringWithFormat:@"%@...", [self substringWithRange:NSMakeRange(0, 5)]];
}

// -----------------------------------------------------------------------------------------------------------------

- (NSString*) firstTenCharacter
{
    if (self.length <= 10) return self;
    return [NSString stringWithFormat:@"%@...", [self substringWithRange:NSMakeRange(0, 10)]];
}
// =================================================================================================================
#pragma mark - MD5
// =================================================================================================================

+ (NSString*) md5HashFromString:(NSString*) string
{
    const char *source = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(source, strlen(source), result);
    NSString *returnString = [[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                              result[0], result[1], result[2], result[3],
                              result[4], result[5], result[6], result[7],
                              result[8], result[9], result[10], result[11],
                              result[12], result[13], result[14], result[15]
                              ];
    return returnString;
}

// -----------------------------------------------------------------------------------------------------------------

- (NSString*) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call.
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// -----------------------------------------------------------------------------------------------------------------

+ (NSString*) uniqueIDFromString:(NSString*) source
{
    return [COString md5HashFromString:source];
}

// =================================================================================================================
#pragma mark - URL Encoding
// =================================================================================================================

- (NSString*) urlEncode
{
    NSString *result = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    return result;
}

// -----------------------------------------------------------------------------------------------------------------

- (NSString*) urlDecode
{
    return (__bridge NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                       (CFStringRef) self,
                                                                                       CFSTR(""),
                                                                                kCFStringEncodingUTF8);
}

// =================================================================================================================
#pragma mark - Date Detector
// =================================================================================================================

- (NSDate *) dateValue
{
    __block NSDate *detectedDate;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:nil];
    [detector enumerateMatchesInString:self
                               options:kNilOptions
                                 range:NSMakeRange(0, [self length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
    { detectedDate = result.date; }];
    return detectedDate;
}

// =================================================================================================================
#pragma mark - (NSStringDrawing) compatibility
// =================================================================================================================

- (CGSize) _sizeWithFont:(UIFont*) font
{
    // Checks.
    if (font == nil) return CGSizeZero;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    return [self sizeWithAttributes:@{ NSFontAttributeName : font}];
#else
    return [self sizeWithFont:font];
#endif
}

// =================================================================================================================
#pragma mark - (UIStringDrawing) compatibility
// =================================================================================================================

- (void) _drawAtPoint:(CGPoint) point withFont:(UIFont*) font foregroundColor:(UIColor*) color
{
    // Checks.
    if (font == nil) return;
    if (color == nil) color = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    [self drawAtPoint:point withAttributes:@{
                                             NSFontAttributeName : font,
                                             NSForegroundColorAttributeName : color
                                             }];
#else
    [color setFill];
    [self drawAtPoint:point withFont:font];
#endif
}

// -----------------------------------------------------------------------------------------------------------------

-(void)_drawInRect:(CGRect) frame withFont:(UIFont*) font foregroundColor:(UIColor*) color
{
    // Checks.
    if (font == nil) return;
    if (color == nil) color = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    NSMutableParagraphStyle *truncate = [NSMutableParagraphStyle new];
    [truncate setLineBreakMode:NSLineBreakByTruncatingTail];
    [self drawInRect:frame withAttributes:@{
                                            NSFontAttributeName : font,
                                            NSForegroundColorAttributeName : color,
                                            NSParagraphStyleAttributeName : truncate
                                            }];
#else
    [color setFill];
    [self drawInRect:frame withFont:font lineBreakMode:NSLineBreakByTruncatingTail];
#endif
}

@end
