//
//  Pot_CalculatorViewController.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 31/03/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_CalculatorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"
#import "Pot_Calculator_Brain.h"

@interface Pot_CalculatorViewController ()

@end

@implementation Pot_CalculatorViewController
@synthesize brain;
@synthesize lblCote;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain
{
    self = [super init];
    if (self) {
        self.brain = aBrain;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshCoteLbl:)
                                                      name:@"refreshCote" object:nil];
    }
    return self;
}

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
	// Do any additional setup after loading the view, typically from a nib.
    //self.view.layer.cornerRadius = 10.0f;
    //self.view.layer.masksToBounds = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// informe que la cote a été mise à jour, il faut raffraichir la valeur du label
- (void)refreshCoteLbl:(NSNotification *)notification
{
    [self.lblCote setText:[NSString stringWithFormat:@"%.2f contre 1", brain.cote]];
    [self.view setNeedsDisplay];
    [self.viewDeckController showCenterView:YES];
    NSLog(@"je viens d'etre informé que la cote a changé ! (vue1)");
    
}

@end
