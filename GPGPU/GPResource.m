//
//  GPResource.m
//  GPGPU
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import "GPResource.h"

@implementation GPResource

/*!
 * Creates GPGPU general purpose memory resource, optimized for concurrent CPU usage
 * @return GPResource*
 */
- (id) init {
    if(self = [super init]) {
        _metal = MTLCreateSystemDefaultDevice();
        
        /**
         * On some older Macs (2010-2011 depending on model), Metal refuses to 
         * intitialize. This is presumed to be because of low-end GPU specifications
         * and Metal's lower limits on buffer sizes, threading etc. Not documented.
         */
        if(!_metal) {
            NSLog(@"Unsupported hardware, unable to allocate GPGPU Resources");
            return NULL;
        }
        
        /**
         * By default, GPResource assumes you want to tie it in with CPU-running code.
         * @see GPWOResource (General Purpose Write-Only Resource)
         */
        self->CPUCacheMode = MTLResourceCPUCacheModeDefaultCache;
    }
    
    return self;
}

#pragma mark - Convenience and factory methods

/*!
 * Quickest way to put something in GPU RAM and return a (CPU-) usable reference to it
 * @param NSData* contents is what you want to put in the buffer when it is created
 * @return GPResource* instance containing initialized GPU memory buffer with contents*
 */
+ (id) createBufferWithContents:(NSData*)contents {
    GPResource *resource = [[GPResource alloc] init];
    [resource setContents:contents];
    return resource;
}

#pragma mark - Direct buffer allocation/manipulation methods

/*!
 * Creates a GPU memory buffer (video RAM) of a given size.
 * Mostly pointless since buffers are immutable.
 * @see createBufferWithContents for a more efficient means of getting a buffer
 * @param size The size of the allocated buffer
 * @return BOOL indicating success or failure
 * @see error property in case of NO return value
 */
- (id) gpalloc:(NSUInteger)size {
    return (_buffer = [_metal newBufferWithLength:size options:MTLResourceOptionCPUCacheModeDefault]);
}

/*!
 * @param contents The contents to initialize the (new) GPU memory buffer with
 * @return BOOL indicating success or failure
 * @see error property in case of NO return value
 */
- (BOOL) setContents:(NSData*)contents {
    _buffer = [_metal newBufferWithBytes:[contents bytes] length:[contents length] options:MTLResourceOptionCPUCacheModeDefault];
    
#if !__has_feature(objc_arc)
    [contents dealloc];
#endif
    contents = NULL;
    return YES;
}

/*!
 * Retrieve the contents of the GPU memory buffer as NSData*
 * @return NSData* containing the GPU buffer's contents for use by a CPU
 */
- (NSData*) getContents {
    return [[NSData alloc] initWithData:[_buffer contents]];
}

#pragma mark - GPU Switching functions

/**
 * Note: the following methods *might* allow concurrent execution on more than one 
 * available GPU for Macintosh models that have more than one GPU available
 * (e.g. Macbook Pros with a low power GPU available). This is, however, very
 * experimental and has not been tested. Likely will not work due to the way 
 * OS X switches context from one GPU to the next according to system preferences
 * and power events/states.
 */

/*!
 * Attempt to switch to a lower-power GPU, if available
 * Generally applies to portables with a power-conservative GPU available
 * @return BOOL indicator of whether we successfully switched to *a* low-power GPU
 */
- (BOOL) switchToLowPowerMode {
    NSArray *GPUs = MTLCopyAllDevices();
    
    for(id<MTLDevice>GPU in GPUs) {
        if(!GPU.lowPower)
            continue;
        
        _metal = GPU;
        NSLog(@"Successfully switched to lower-power GPU (%@)", GPU.name);
        return YES;
    }
    
    return NO;
}

/*!
 * Attempt to switch to a headless GPU, if available
 * Generally applies to servers and/or systems with a GPU that has no display connected
 * @return BOOL indicator of whether we successfully switched to *a* headless GPU
 */
- (BOOL) switchToHeadlessMode {
    NSArray *GPUs = MTLCopyAllDevices();
    
    for(id<MTLDevice>GPU in GPUs) {
        if(!GPU.headless)
            continue;
        
        _metal = GPU;
        NSLog(@"Successfully switched to headless GPU (%@)", GPU.name);
        return YES;
    }
    
    return NO;
}

@end
