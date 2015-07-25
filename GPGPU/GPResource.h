//
//  GPResource.h
//  GPGPU
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Metal;

@interface GPResource : NSObject {
    NSUInteger CPUCacheMode;
}

+ (id) createBufferWithContents:(NSData*)contents;

- (BOOL) setContents:(NSData*)contents;
- (NSData*) getContents;
- (id) gpalloc:(NSUInteger)size;
- (BOOL) switchToLowPowerMode;
- (BOOL) switchToHeadlessMode;

@property (retain) id<MTLDevice>metal;
@property (retain) id buffer;
@property (retain) NSError *error;

@end
