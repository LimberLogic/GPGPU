//
//  GPObject.m
//  GPGPU
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import "GPObject.h"

@implementation GPObject

/*!
 * Mostly a wrapper for setObject while initializing us in one fell swoop
 * @return GPObject
 * @see setObject:
 */
- (id) initWithObject:(NSObject<NSCoding>*)object {
    if(self = [super init])
        [self setObject:object];
    
    return self;
}

/*!
 * Gets an object from GPU RAM. Same thing set via initWithObject: or setObject:
 * @return id - usually NSObject<NSCoding>* but really can be cast down to do a "strong pop"
 */
- (id) getObject {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self getContents]];
}

/*!
 * Sets a copy of the object onto the GPU in memory
 * Note: Any object can be used here but it has to conform to the NSCoding protocol
 * @return BOOL indicating error or success
 */
- (BOOL) setObject:(NSObject<NSCoding>*)object {
    return [self setContents:[NSKeyedArchiver archivedDataWithRootObject:object]];
}

@end
