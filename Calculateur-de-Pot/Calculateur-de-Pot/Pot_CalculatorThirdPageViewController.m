//
//  Pot_CalculatorThirdViewController.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_CalculatorThirdPageViewController.h"

@interface Pot_CalculatorThirdPageViewController ()

@end

@implementation Pot_CalculatorThirdPageViewController
@synthesize brain;
@synthesize champMise;
@synthesize champTaillePot;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain
{
    self = [super init];
    if (self) {
        self.brain = aBrain;
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundcartes.jpg"]];
    // pour pouvoir scroller verticalement
    UIScrollView *v = (id)self.view;
    v.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    v.contentInset = UIEdgeInsetsMake(1, 0, 1, 0);
    
    // je suis délégué de mes zones de texte, pour pouvoir fermer
    // le clavier en temps voulu
    [champMise setDelegate:self];
    [champTaillePot setDelegate:self];
    
    // on set le keyboard numerique
    self.champMise.keyboardType = UIKeyboardTypeDecimalPad;
    self.champTaillePot.keyboardType = UIKeyboardTypeDecimalPad;
    self.champMise.returnKeyType = UIReturnKeyDone;
    self.champTaillePot.returnKeyType = UIReturnKeyDone;
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


- (IBAction)calculerCote:(id)sender
{
    // au cas ou on a pas fermé le clavier
    [self.champMise resignFirstResponder];
    [self.champTaillePot resignFirstResponder];
    
    // on vérifie les valeurs
    float taillePot = 0;
    float mise = 1;
    
    if ([[self.champTaillePot text] length] > 0) {
        taillePot = [[self.champTaillePot text] doubleValue];
    }
    
    if ([[self.champTaillePot text] length] > 0) {
        mise = [[self.champMise text] doubleValue];
    }
    
    [brain calculerCote:taillePot mise:mise];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCote" object:brain];
    NSLog(@"on a calculé la nouvelle cote et prevenu les observeurs");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
