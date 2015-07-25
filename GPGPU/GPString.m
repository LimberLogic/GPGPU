//
//  GPString.m
//  GPGPU
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import "GPString.h"

@implementation GPString

/*!
 * Forwards string initialization to initWithString:encoding:
 * Uses DEFAULT_ENCODING preprocessor definition to set encoding (default: UTF-16)
 * @see initWithString:encoding:
 */
- (id) initWithString:(NSString*)string {
    return [self initWithString:string encoding:DEFAULT_ENCODING];
}

/*!
 * Initializes the class instance, keeping everything on the RAM side low 
 * Ideally we want to be a near-transparent proxy/pointer to GPU resources
 * @return GPString
 */
- (id) initWithString:(NSString*)string encoding:(NSStringEncoding)encoding {
    self = [super init];
    
    if(self) {
        [self setString:string encoding:encoding];
    }
    
    return self;
}

#pragma mark - NSString-friendly getters and setters

/*!
 * Forwards call to getStringWithEncoding: using default encoding (cpp definition)
 * @return NSString*
 */
- (NSString*) getString {
    return [self getStringWithEncoding:DEFAULT_ENCODING];
}

/*!
 * Fetch buffer contents as NSString* for easy CPU stack manipulation of GPU RAM
 * @param encoding used to decode the NSString from raw (NS)Data bytes (default: UTF16)
 * @return NSString*
 */
- (NSString*) getStringWithEncoding:(NSStringEncoding)encoding {
    return [[NSString alloc] initWithData:[self getContents] encoding:encoding];
}

/*!
 * Forwards call to setString:encoding: using default encoding (cpp definition)
 * @return NSString*
 */
- (BOOL) setString:(NSString*)string {
    _length = [string length];    
    return [self setContents:[string dataUsingEncoding:DEFAULT_ENCODING]];
}

/*!
 * Set the string back, ideally after doing something to it on the stack
 * @param encoding to use when decoding the NSString to raw bytes
 * @return BOOL indicating if an error occurred during the operation
 */
- (BOOL) setString:(NSString*)string encoding:(NSStringEncoding)encoding {
    BOOL ret = [self setContents:[string dataUsingEncoding:encoding]];
    
#if !__has_feature(objc_arc)
    [string dealloc];
#endif
    
    return ret;
}

@end
