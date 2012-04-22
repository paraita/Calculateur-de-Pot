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
@synthesize maCarteUn, maCarteDeux, adversaireCarteUn, adversaireCarteDeux, flopUn, flopDeux, flopTrois, turn, river, currentImageString;

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
    /*
    tab_Hauteur=[[NSMutableArray alloc]initWithObjects:@"As",@"2",@"3",@"4",@"5",
                @"6",@"7",@"8",@"9",@"10",@"Valet",@"Dame",@"Roi",nil];
    tab_Couleur=[[NSMutableArray alloc]initWithObjects:@"Coeur",@"Carreau",@"Trefle",@"Pique",nil]; 
    */
    tab_Hauteur=[[NSMutableArray alloc]initWithObjects:@"as",@"2",@"3",@"4",@"5",
                 @"6",@"7",@"8",@"9",@"10",@"valet",@"dame",@"roi",nil];
    tab_Couleur=[[NSMutableArray alloc]initWithObjects:@"Coeur",@"Carreau",@"Trefle",@"Pique",nil]; 
    [self setCurrentImageString:[NSMutableString stringWithString:@""]];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*
- (IBAction)buttonPressed1:(id)sender{
    
    NSLog(@"%@", [sender currentTitle]);
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [self.view addSubview:myPickerView];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton addTarget:self
                   action:@selector(aMethod:)
         forControlEvents:UIControlEventTouchDown];
    doneButton.frame = CGRectMake(265.0,202.0,  52.0, 30.0);
    
    [self.view addSubview:doneButton];
}
*/

- (IBAction)buttonPressed1:(id)sender{
    
    //Creation de la pickerView
    NSLog(@"%@", [sender currentTitle]);
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [self.view addSubview:myPickerView];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    //Creation du bouton Done
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton addTarget:self
                   action:@selector(doneMethod:)
         forControlEvents:UIControlEventTouchDown];
    doneButton.frame = CGRectMake(265.0,202.0,  52.0, 30.0);
    UIImage *doneImage = [UIImage imageNamed:@"done.png"];
    [doneButton setImage:doneImage forState:UIControlStateNormal];
    [doneImage release];
    
    
    //Creation du bouton Cancel
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton addTarget:self
                     action:@selector(cancelMethod:)
           forControlEvents:UIControlEventTouchDown];
    cancelButton.frame = CGRectMake(2.0,202.0,  52.0, 30.0);
    UIImage *cancelImage = [UIImage imageNamed:@"cancel.png"];
    [cancelButton setImage:cancelImage forState:UIControlStateNormal];
    [cancelImage release];
    
    currentButton = sender;
    [self.view addSubview:doneButton];
    [self.view addSubview:cancelButton];
    
    
    
}



-(IBAction)doneMethod:(id)sender
{
    //Partie brain
    
    //Partie vue
    
    [currentImageString appendString:[tab_Hauteur objectAtIndex:[myPickerView selectedRowInComponent:0]]];
    [currentImageString appendString:[tab_Couleur objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    [currentImageString appendString:@".png"];
    
    //Les logs pour quelques checks
    
    NSLog(@"%@,%@",[tab_Hauteur objectAtIndex:[myPickerView selectedRowInComponent:0]],[tab_Couleur objectAtIndex:[myPickerView selectedRowInComponent:1]]);
    NSLog(@"%@", currentImageString);
    
    //Constructions de l'image carte
    currentImage = [UIImage imageNamed:currentImageString];
    [currentButton setImage:currentImage forState:UIControlStateNormal];
    [currentImageString setString:@""];
    [currentImage release];
    
    //On fait disparaitre la PickerView
    [cancelButton removeFromSuperview];
    [myPickerView removeFromSuperview];    
    
    [doneButton removeFromSuperview];
    
}

-(IBAction)cancelMethod:(id)sender{
    //Partie Brain
    
    //Partie Vue
    UIImage *img = [UIImage imageNamed:@"dos.png"];
    [currentButton setImage:img forState:UIControlStateNormal];    
    
    [cancelButton removeFromSuperview];
    [myPickerView removeFromSuperview];    
    [doneButton removeFromSuperview];
    [img release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component==0)
    {
		return [tab_Hauteur count];
	}
	
	else
    {
		return[tab_Couleur count];
	}
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component) 
    {
        case 0:
            return [tab_Hauteur objectAtIndex:row];
            break;
        case 1:
            return [tab_Couleur objectAtIndex:row];
            break;
    }
    return nil;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
    switch (component) {
        case 0:
            componentWidth = 90.0;
            return componentWidth;
            break;
        case 1:
            componentWidth = 110.0;
            return componentWidth;
            break;
        default:
            break;
    }
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
