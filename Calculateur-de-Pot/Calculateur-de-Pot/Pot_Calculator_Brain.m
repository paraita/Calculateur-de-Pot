//
//  Pot_Calculator_Brain.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_Calculator_Brain.h"

@implementation Pot_Calculator_Brain
@synthesize taillePot;
@synthesize mise;
@synthesize cote;

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"initialisation du brain OK");
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)calculerCote:(float)laTailleDuPot mise:(float)laMise
{
    NSLog(@"calcul de la cote dans le brain");
    cote = laTailleDuPot / laMise;
}

@end
