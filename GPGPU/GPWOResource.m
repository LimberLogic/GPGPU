//
//  GPWOResource.m
//  GPGPU
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import "GPWOResource.h"

@implementation GPWOResource

/*!
 * Merely overrides GPResource's init method to use write combining
 * @return GPWOResource*
 * @see GPResource init
 */
- (id) init {
    if(self = [super init]) {
        self->CPUCacheMode = MTLResourceCPUCacheModeWriteCombined;
    }
    
    return self;
}

@end
