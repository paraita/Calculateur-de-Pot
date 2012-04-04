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


@interface Pot_CalculatorAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Pot_CalculatorViewController *vue1;
@property (strong, nonatomic) Pot_CalculatorSecondPageViewController *vue2;
@property (strong, nonatomic) Pot_CalculatorThirdPageViewController *vue3;
@end
