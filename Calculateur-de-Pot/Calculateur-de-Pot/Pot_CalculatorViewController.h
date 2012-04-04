//
//  Pot_CalculatorViewController.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 31/03/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pot_Calculator_Brain.h"

@interface Pot_CalculatorViewController : UIViewController


@property (nonatomic, assign) Pot_Calculator_Brain *brain;
@property (nonatomic, assign) IBOutlet UILabel *lblCote;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain;
@end
