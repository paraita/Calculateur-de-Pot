//
//  Pot_Calculator_Brain.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_Calculator_Brain.h"

@interface Pot_Calculator_Brain ()
@property (nonatomic, assign) NSMutableArray *cartes;
@end

@implementation Pot_Calculator_Brain
@synthesize taillePot;
@synthesize mise;
@synthesize cote;
@synthesize cartes;

#pragma mark - Constructeur/Destructeur

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"initialisation du brain OK");
        self.cartes = [[NSMutableArray alloc] initWithCapacity:9];
        //TODO insérer des cartes dummy
        
    }
    return self;
}

- (void)dealloc
{
    self.cartes = nil;
    [super dealloc];
}


#pragma mark - implémentation des setters/getters

- (void)calculerCote:(float)laTailleDuPot mise:(float)laMise
{
    NSLog(@"calcul de la cote dans le brain");
    cote = laTailleDuPot / laMise;
}

- (Carte *)premiereCarteJoueur
{
    return [self.cartes objectAtIndex:0];
}

- (Carte *)deuxiemeCarteJoueur
{
    return [self.cartes objectAtIndex:1];
}

- (Carte *)premiereCarteAdversaire
{
    return [self.cartes objectAtIndex:2];
}

- (Carte *)deuxiemeCarteAdversaire
{
    return [self.cartes objectAtIndex:3];
}

- (Carte *)carteDuTapis:(int)numero
{
    if (numero > 0 && numero < 6) {
        return [self.cartes objectAtIndex:(numero + 3)];
    }
    else {
        NSLog(@"erreur dans la méthode carteDuTapis: mauvaise position (%d)", numero);
        return nil;
    }
}

- (void)setPremiereCarteJoueur:(Carte *)carte
{
    [self.cartes replaceObjectAtIndex:0 withObject:carte];
}

- (void)setDeuxiemeCarteJoueur:(Carte *)carte
{
    [self.cartes replaceObjectAtIndex:1 withObject:carte];
}

- (void)setPremiereCarteAdversaire:(Carte *)carte
{
    [self.cartes replaceObjectAtIndex:2 withObject:carte];
}

- (void)setDeuxiemeCarteAdversaire:(Carte *)carte
{
    [self.cartes replaceObjectAtIndex:3 withObject:carte];
}

- (void)setCarteDuTapis:(Carte *)carte numero:(int)unNumero
{
    if (unNumero > 0 && unNumero < 6) {
        [self.cartes replaceObjectAtIndex:(3 + unNumero) withObject:carte];
    }
    else {
        NSLog(@"erreur dans la méthode setCarteDuTapis: mauvaise position: %d", unNumero);
    }
}

@end


















