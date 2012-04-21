//
//  Pot_Calculator_Brain.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Carte.h"

@interface Pot_Calculator_Brain : NSObject

@property (nonatomic, assign) float taillePot;
@property (nonatomic, assign) float mise;
@property (nonatomic, readonly) float cote;

- (void)calculerCote:(float)laTailleDuPot mise:(float)laMise;
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

@end
