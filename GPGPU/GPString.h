//
//  GPString.h
//  GPGPU
//
//  Class for storing NSString-like strings in GPU memory
//  Note: NOT designed to be an exhaustive NSString replacement
//  Use a CPU's stack to manipulate the NSString to be stored in
//  the GPU's RAM
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#include "GPResource.h"

#define DEFAULT_ENCODING NSUTF16StringEncoding

@interface GPString : GPResource

- (id) initWithString:(NSString*)string encoding:(NSStringEncoding)encoding;
- (id) initWithString:(NSString*)string;
- (NSString*) getString;
- (BOOL) setString:(NSString*)string;

@property (retain) id<MTLResource> strlen;
@property (atomic) NSUInteger length;

@end
