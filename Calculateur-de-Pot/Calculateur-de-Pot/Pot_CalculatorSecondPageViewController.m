//
//  Pot-CalculatorSecondPageViewController.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 03/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_CalculatorSecondPageViewController.h"

@interface Pot_CalculatorSecondPageViewController ()

@end

@implementation Pot_CalculatorSecondPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
