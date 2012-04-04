//
//  Pot-CalculatorSecondPageViewController.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 03/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pot_Calculator_Brain.h"

@interface Pot_CalculatorSecondPageViewController : UIViewController

@property (nonatomic, assign) Pot_Calculator_Brain *brain;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain;

@end
