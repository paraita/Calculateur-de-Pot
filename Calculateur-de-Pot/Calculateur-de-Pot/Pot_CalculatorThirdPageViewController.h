//
//  Pot_CalculatorThirdViewController.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pot_Calculator_Brain.h"

@interface Pot_CalculatorThirdPageViewController : UIViewController

@property (nonatomic, assign) Pot_Calculator_Brain *brain;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain;

@end
