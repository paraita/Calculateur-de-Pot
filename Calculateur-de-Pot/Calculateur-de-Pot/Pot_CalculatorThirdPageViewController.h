//
//  Pot_CalculatorThirdViewController.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pot_Calculator_Brain.h"

@interface Pot_CalculatorThirdPageViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, assign) IBOutlet UITextField *champTaillePot;
@property (nonatomic, assign) IBOutlet UITextField *champMise;
@property (nonatomic, assign) Pot_Calculator_Brain *brain;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain;
- (IBAction)calculerCote:(id)sender;
@end
