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
@synthesize lblCotePot, lblCoteAmelioration;
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



-(void)setCarteWithButtonSelected:(UIButton*)myButton carte:(Carte*)maCarte{
    NSLog(@"la carte que je veux setter: %@", [maCarte description]);
    if([[myButton currentTitle] isEqualToString:@"Macarte1"]){
        [brain setPremiereCarteJoueur:maCarte];
        NSLog(@"la carte dans le brain: %@", [brain.premiereCarteJoueur description]);
    }else{
        if([[myButton currentTitle] isEqualToString:@"Macarte2"]){
            [brain setDeuxiemeCarteJoueur:maCarte];
            NSLog(@"la carte dans le brain: %@", [brain.deuxiemeCarteJoueur description]);
        }else{
            if([[myButton currentTitle] isEqualToString:@"Advcarte1"]){
                [brain setPremiereCarteAdversaire:maCarte];
                NSLog(@"la carte dans le brain: %@", [brain.premiereCarteAdversaire description]);
            }else{
                if([[myButton currentTitle] isEqualToString:@"Advcarte2"]){
                    [brain setDeuxiemeCarteAdversaire:maCarte];
                    NSLog(@"la carte dans le brain: %@", [brain.deuxiemeCarteAdversaire description]);
                }else{
                    if([[myButton currentTitle] isEqualToString:@"flop1"]){
                        [brain setCarteDuTapis:maCarte numero:1];
                        NSLog(@"la carte dans le brain: %@", [[brain carteDuTapis:1] description]);
                    }else{
                        if([[myButton currentTitle] isEqualToString:@"flop2"]){
                            [brain setCarteDuTapis:maCarte numero:2];
                            NSLog(@"la carte dans le brain: %@", [[brain carteDuTapis:2] description]);
                        }else{
                            if([[myButton currentTitle] isEqualToString:@"flop3"]){
                                [brain setCarteDuTapis:maCarte numero:3];
                                NSLog(@"la carte dans le brain: %@", [[brain carteDuTapis:3] description]);
                            }else{
                                if([[myButton currentTitle] isEqualToString:@"turn"]){
                                    [brain setCarteDuTapis:maCarte numero:4];
                                    NSLog(@"la carte dans le brain: %@", [[brain carteDuTapis:4] description]);
                                }else{
                                    if([[myButton currentTitle] isEqualToString:@"river"]){
                                        [brain setCarteDuTapis:maCarte numero:5];
                                        NSLog(@"la carte dans le brain: %@", [[brain carteDuTapis:5] description]);
                                    }}}}}}}}}
    
}

-(IBAction)doneMethod:(id)sender
{
    //Partie brain
    
    //On crée la carte grace a la selection du PickerView
    Carte *c = [self.brain getFromPaquet:[tab_Hauteur objectAtIndex:[myPickerView selectedRowInComponent:0]] couleur:[tab_Couleur objectAtIndex:[myPickerView selectedRowInComponent:1]]];
    
    //On envoie la carte au brain
    [self setCarteWithButtonSelected:currentButton carte:c];
    
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
    // jamais atteint
    return 0.0;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)resetTapis
{
    self.lblCotePot.text = @"";
    self.lblCoteAmelioration.text = @"";
    [self.maCarteUn setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.maCarteDeux setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.adversaireCarteUn setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.adversaireCarteDeux setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.flopUn setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.flopDeux setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.flopTrois setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.turn setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.river setImage:[UIImage imageNamed:@"dos.png"] forState:UIControlStateNormal];
    [self.brain resetBrain];
}

// informe que la cote a été mise à jour, il faut raffraichir la valeur du label
- (void)refreshCoteLbl:(NSNotification *)notification
{
    [self.lblCotePot setText:[NSString stringWithFormat:@"%.2f : 1", brain.cotePot]];
    [self.lblCoteAmelioration setText:[NSString stringWithFormat:@"%.2f : 1", brain.coteAmelioration]];
    [self.view setNeedsDisplay];
    [self.viewDeckController showCenterView:YES];
    NSLog(@"je viens d'etre informé que la cote a changé ! (vue1)");
    
}

@end
