//
//  GPObject.h
//  GPGPU
//
//  Simple class for putting any NSCoding-compliant object instance
//  onto the GPU
//
//  Note: We still can't serialize active resources like sockets.
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import "GPResource.h"

@interface GPObject : GPResource

- (id) initWithObject:(NSObject<NSCoding>*)object;
- (id) getObject;
- (BOOL) setObject:(NSObject<NSCoding>*)object;

@end
