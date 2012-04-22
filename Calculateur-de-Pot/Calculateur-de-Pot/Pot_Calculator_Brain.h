//
//  Pot_Calculator_Brain.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Carte.h"

typedef enum {
    RIEN = 0,
    UNE_PAIRE = 1,
    DEUX_PAIRE = 2,
    BRELAN = 3,
    SUITE = 4,
    COULEUR = 5,
    FULL = 6,
    CARRE = 7,
    QUINTEFLUSH = 8
} NomCoups;

typedef enum { PREFLOP, FLOP, TURN, RIVER } etatPartie;

@interface Pot_Calculator_Brain : NSObject
{
    float coteAmelioration;
}
@property (nonatomic, assign) float taillePot;
@property (nonatomic, assign) float mise;
@property (nonatomic, readonly) float cotePot;
@property (nonatomic, readonly) float coteAmelioration;
@property (nonatomic, assign) int etat;

- (void)setPremiereCarteJoueur:(Carte *)carte;
- (void)setDeuxiemeCarteJoueur:(Carte *)carte;
- (void)setPremiereCarteAdversaire:(Carte *)carte;
- (void)setDeuxiemeCarteAdversaire:(Carte *)carte;
- (void)setCarteDuTapis:(Carte *)carte numero:(int)unNumero;
- (Carte *)premiereCarteJoueur;
- (Carte *)deuxiemeCarteJoueur;
- (Carte *)premiereCarteAdversaire;
- (Carte *)deuxiemeCarteAdversaire;
- (Carte *)carteDuTapis:(int)numero;

- (void)calculerCote:(float)laTailleDuPot mise:(float)laMise;
- (void)detecterMain;
- (NSString *)codify:(Carte *)c;

@end
