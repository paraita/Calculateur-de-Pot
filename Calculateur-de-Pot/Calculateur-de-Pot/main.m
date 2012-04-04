//
//  main.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 31/03/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pot_CalculatorAppDelegate.h"
#define MARCHE

int main(int argc, char *argv[])
{
 
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([Pot_CalculatorAppDelegate class]));
    [pool release];
    return retVal;
    
     /*
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([Pot_CalculatorAppDelegate class]));
    }
     */
    
}
