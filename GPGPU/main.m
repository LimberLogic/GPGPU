//
//  main.m
//  GPGPU
//
//  Created by Anthony Cargile on 7/25/15.
//  Copyright © 2015 Limber Logic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPString.h"

/* Create a dummy data file using dd if=/dev/zero of=~/test.txt count=1024 bs=1024 */
#define PATH_TO_TEST_FILE @"/Users/ac/test.txt"

/* Define this for conventional RAM test, undefine for GPU test */
#define CONVENTIONAL_RAM 1
#undef CONVENTIONAL_RAM

#ifndef CONVENTIONAL_RAM
#   define GPGPU_RAM
#endif

/*!
 * Small CLI program to demonstrate conventional memory conservation using GPGPU's offloading
 * @return int 0 (EXIT_SUCCESS as defined in <stdlib.h>)
 */
int main(int argc, const char * argv[]) {
    /// load large dummy data into regular RAM
    NSString *test = [[NSString alloc] initWithContentsOfFile:PATH_TO_TEST_FILE encoding:NSUTF16StringEncoding error:Nil];
    
    /// then make it larger (can't exceed 256MB)
    for(int i = 0; i < 5; i++) {
        test = [test stringByAppendingString:test];
    }
    
#ifdef CONVENTIONAL_RAM
    /// Conventional RAM test:
    /// keep referencing it (and prevent the app from closing since we're running CLI)
    while(1) {
        NSLog(@"Test's size is %ld", [test length]);
        sleep(1000);
    }
#else
    /// GPGPU RAM test
    GPString *string = [[GPString alloc] initWithString:test];
    test = NULL; // kill it
    
    while(1) {
        NSLog(@"Test's size is %ld", [test length]);
        NSLog(@"GPU string size is %ld", [string length]);
        sleep(1000);
    }
#endif
    return 0;
}
