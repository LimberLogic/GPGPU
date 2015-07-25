//
//  GPWOResource.h
//  GPGPU
//
//  "Write-Only" resource (with respect to the CPU).
//  Use this instead of GPResource only if you're allocating
//  and initializing memory from a CPU that'll be used
//  exclusively by the GPU until complete.
//
//  https://en.wikipedia.org/wiki/Write-only_memory_(engineering)
//  https://en.wikipedia.org/wiki/Write-only_memory_(joke)
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import "GPResource.h"

@interface GPWOResource : GPResource
@end
