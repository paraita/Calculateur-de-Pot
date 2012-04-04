//
//  Pot_CalculatorAppDelegate.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 31/03/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pot_CalculatorViewController.h"
#import "Pot_CalculatorSecondPageViewController.h"
#import "Pot_CalculatorThirdPageViewController.h"
#import "Pot_Calculator_Brain.h"


@interface Pot_CalculatorAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) Pot_CalculatorViewController *vue1;
@property (retain, nonatomic) Pot_CalculatorSecondPageViewController *vue2;
@property (retain, nonatomic) Pot_CalculatorThirdPageViewController *vue3;
@property (retain, nonatomic) Pot_Calculator_Brain *brain;
@end
