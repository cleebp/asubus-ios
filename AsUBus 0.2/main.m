//
//  main.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/17/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BPCAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([BPCAppDelegate class]));
    }
    
    #ifdef ANDROID
        [UIScreen mainScreen].currentMode =
            [UIScreenMode emulatedMode:UIScreenIPhone3GEmulationMode];
    #endif
}
