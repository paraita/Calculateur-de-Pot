//
//  Pot_Calculator_Brain.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_Calculator_Brain.h"
#import "PokerOddsCalculator.h"


@interface Pot_Calculator_Brain ()
{
    PokerOddsCalculator *internalBrain;
}
@property (nonatomic, assign) NSMutableArray *cartesEnJeu;
@property (nonatomic, assign) NSArray *paquetCartes;
@property (nonatomic, assign) int *coupsDispo;
@end

@implementation Pot_Calculator_Brain
@synthesize taillePot;
@synthesize mise;
@synthesize cotePot, coteAmelioration;
@synthesize cartesEnJeu;
@synthesize paquetCartes;
@synthesize coupsDispo;
@synthesize etat;

#pragma mark - Constructeur/Destructeur

- (id)init
{
    self = [super init];
    if (self) {
        
        internalBrain = [[PokerOddsCalculator alloc] init];
        
        self.etat = PREFLOP;
        
        // coups dispo
        self.coupsDispo = calloc(9, sizeof(int));
        if (!self.coupsDispo) {
            NSLog(@"oups ! erreur d'allocation des coups dispo !");
        }
        
        // cartes de la partie (les 2 joueurs et le tapis)
        self.cartesEnJeu = [[NSMutableArray alloc] initWithCapacity:9];
        for (int i = 0; i < 9; i++) {
            Carte *dummy = [[Carte alloc] initWithColor:COEUR valeur:0 img:nil];;
            [cartesEnJeu addObject:dummy];
            [dummy release];
        }
        
        // cartes du paquet
        self.paquetCartes = [[NSArray alloc] initWithObjects:
                             [[[Carte alloc] initWithColor:DUMMY
                                                    valeur:0
                                                       img:[UIImage imageNamed:@"dos.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:1
                                                       img:[UIImage imageNamed:@"asCoeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:2
                                                       img:[UIImage imageNamed:@"2Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:3
                                                       img:[UIImage imageNamed:@"3Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:4
                                                       img:[UIImage imageNamed:@"4Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:5
                                                       img:[UIImage imageNamed:@"5Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:6
                                                       img:[UIImage imageNamed:@"6Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:7
                                                       img:[UIImage imageNamed:@"7Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:8
                                                       img:[UIImage imageNamed:@"8Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:9
                                                       img:[UIImage imageNamed:@"9Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:10
                                                       img:[UIImage imageNamed:@"10Coeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:11
                                                       img:[UIImage imageNamed:@"valetCoeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:12
                                                       img:[UIImage imageNamed:@"dameCoeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:COEUR
                                                    valeur:13
                                                       img:[UIImage imageNamed:@"roiCoeur.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:1
                                                       img:[UIImage imageNamed:@"asPique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:2
                                                       img:[UIImage imageNamed:@"2Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:3
                                                       img:[UIImage imageNamed:@"3Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:4
                                                       img:[UIImage imageNamed:@"4Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:5
                                                       img:[UIImage imageNamed:@"5Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:6
                                                       img:[UIImage imageNamed:@"6Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:7
                                                       img:[UIImage imageNamed:@"7Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:8
                                                       img:[UIImage imageNamed:@"8Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:9
                                                       img:[UIImage imageNamed:@"9Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:10
                                                       img:[UIImage imageNamed:@"10Pique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:11
                                                       img:[UIImage imageNamed:@"valetPique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:12
                                                       img:[UIImage imageNamed:@"damePique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:PIQUE
                                                    valeur:13
                                                       img:[UIImage imageNamed:@"roiPique.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:1
                                                       img:[UIImage imageNamed:@"asCarreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:2
                                                       img:[UIImage imageNamed:@"2Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:3
                                                       img:[UIImage imageNamed:@"3Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:4
                                                       img:[UIImage imageNamed:@"4Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:5
                                                       img:[UIImage imageNamed:@"5Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:6
                                                       img:[UIImage imageNamed:@"6Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:7
                                                       img:[UIImage imageNamed:@"7Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:8
                                                       img:[UIImage imageNamed:@"8Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:9
                                                       img:[UIImage imageNamed:@"9Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:10
                                                       img:[UIImage imageNamed:@"10Carreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:11
                                                       img:[UIImage imageNamed:@"valetCarreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:12
                                                       img:[UIImage imageNamed:@"dameCarreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:CARREAU
                                                    valeur:13
                                                       img:[UIImage imageNamed:@"roiCarreau.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:1
                                                       img:[UIImage imageNamed:@"asTrefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:2
                                                       img:[UIImage imageNamed:@"2Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:3
                                                       img:[UIImage imageNamed:@"3Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:4
                                                       img:[UIImage imageNamed:@"4Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:5
                                                       img:[UIImage imageNamed:@"5Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:6
                                                       img:[UIImage imageNamed:@"6Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:7
                                                       img:[UIImage imageNamed:@"7Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:8
                                                       img:[UIImage imageNamed:@"8Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:9
                                                       img:[UIImage imageNamed:@"9Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:10
                                                       img:[UIImage imageNamed:@"10Trefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:11
                                                       img:[UIImage imageNamed:@"valetTrefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:12
                                                       img:[UIImage imageNamed:@"dameTrefle.png"]] autorelease],
                             [[[Carte alloc] initWithColor:TREFLE
                                                    valeur:13
                                                       img:[UIImage imageNamed:@"roiTrefle.png"]] autorelease],
                             nil];
        NSLog(@"initialisation du brain OK");
        //[self detecterMain];
    }
    return self;
}

- (void)dealloc
{
    [internalBrain release];
    internalBrain = nil;
    self.cartesEnJeu = nil;
    self.paquetCartes = nil;
    free(self.coupsDispo);
    self.coupsDispo = nil;
    [super dealloc];
}


#pragma mark - implémentation des setters/getters

- (Carte *)premiereCarteJoueur
{
    return [self.cartesEnJeu objectAtIndex:0];
}

- (Carte *)deuxiemeCarteJoueur
{
    return [self.cartesEnJeu objectAtIndex:1];
}

- (Carte *)premiereCarteAdversaire
{
    return [self.cartesEnJeu objectAtIndex:2];
}

- (Carte *)deuxiemeCarteAdversaire
{
    return [self.cartesEnJeu objectAtIndex:3];
}

- (Carte *)carteDuTapis:(int)numero
{
    if (numero > 0 && numero < 6) {
        return [self.cartesEnJeu objectAtIndex:(numero + 3)];
    }
    else {
        NSLog(@"erreur dans la méthode carteDuTapis: mauvaise position (%d)", numero);
        return nil;
    }
}

- (void)setPremiereCarteJoueur:(Carte *)carte
{
    [self.cartesEnJeu replaceObjectAtIndex:0 withObject:carte];
}

- (void)setDeuxiemeCarteJoueur:(Carte *)carte
{
    [self.cartesEnJeu replaceObjectAtIndex:1 withObject:carte];
}

- (void)setPremiereCarteAdversaire:(Carte *)carte
{
    [self.cartesEnJeu replaceObjectAtIndex:2 withObject:carte];
}

- (void)setDeuxiemeCarteAdversaire:(Carte *)carte
{
    [self.cartesEnJeu replaceObjectAtIndex:3 withObject:carte];
}

- (void)setCarteDuTapis:(Carte *)carte numero:(int)unNumero
{
    if (unNumero > 0 && unNumero < 6) {
        [self.cartesEnJeu replaceObjectAtIndex:(3 + unNumero) withObject:carte];
    }
    else {
        NSLog(@"erreur dans la méthode setCarteDuTapis: mauvaise position: %d", unNumero);
    }
}

# pragma mark - braining

- (void)calculerCote:(float)laTailleDuPot mise:(float)laMise
{
    NSLog(@"calcul de la cote dans le brain");
    cotePot = laTailleDuPot / laMise;
    [self detecterMain];
}

- (void)detecterMain
{
    
    if (etat == PREFLOP) {
        internalBrain.cards = nil;
        internalBrain.cards = [[NSArray alloc] initWithObjects:[self codify:[self premiereCarteJoueur]],
                               [self codify:[self deuxiemeCarteJoueur]],
                               nil];
    }
    else {
        if (etat == FLOP) {
            internalBrain.cards = nil;
            internalBrain.cards = [[NSArray alloc] initWithObjects:[self codify:[self premiereCarteJoueur]],
                                   [self codify:[self deuxiemeCarteJoueur]],
                                   [self codify:[self carteDuTapis:1]],
                                   [self codify:[self carteDuTapis:2]],
                                   [self codify:[self carteDuTapis:3]],
                                   nil];
        }
        else {
            if (etat == TURN) {
                internalBrain.cards = nil;
                internalBrain.cards = [[NSArray alloc] initWithObjects:[self codify:[self premiereCarteJoueur]],
                                       [self codify:[self deuxiemeCarteJoueur]],
                                       [self codify:[self carteDuTapis:1]],
                                       [self codify:[self carteDuTapis:2]],
                                       [self codify:[self carteDuTapis:3]],
                                       [self codify:[self carteDuTapis:4]],
                                       nil];
            }
            // sinon on est a la RIVER
            else {
                internalBrain.cards = nil;
                internalBrain.cards = [[NSArray alloc] initWithObjects:[self codify:[self premiereCarteJoueur]],
                                       [self codify:[self deuxiemeCarteJoueur]],
                                       [self codify:[self carteDuTapis:1]],
                                       [self codify:[self carteDuTapis:2]],
                                       [self codify:[self carteDuTapis:3]],
                                       [self codify:[self carteDuTapis:4]],
                                       [self codify:[self carteDuTapis:5]],
                                       nil];
            }
        }
    }
    
    
    //internalBrain.cards = [[NSArray alloc] initWithObjects:@"3h", @"4h", @"5s", @"6h", @"8h", nil];
    
    double unePaire = [internalBrain chanceOfPair];
    double deuxPaires = [internalBrain chanceOfTwoPair];
    //double brelan = [internalBrain chanceOfThreeOfAKind];
    double carre = [internalBrain chanceOfFourOfAKind];
    double couleur = [internalBrain chanceOfFlush];
    double full = [internalBrain chanceOfFullHouse];
    double suite = [internalBrain chanceOfStraight];
    double quinteflush = [internalBrain chanceOfStraightFlush];
    
    NSDictionary *motifs = [[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:
                                                                  [NSNumber numberWithDouble:unePaire], 
                                                                  [NSNumber numberWithDouble:deuxPaires],
                                                                  //[NSNumber numberWithDouble:brelan],
                                                                  [NSNumber numberWithDouble:carre],
                                                                  [NSNumber numberWithDouble:couleur],
                                                                  [NSNumber numberWithDouble:full],
                                                                  [NSNumber numberWithDouble:suite],
                                                                  [NSNumber numberWithDouble:quinteflush],
                                                                   nil] autorelease]
                                                         forKeys:[[[NSArray alloc] initWithObjects:
                                                                   @"UNE_PAIRE",
                                                                   @"DEUX_PAIRES",
                                                                   //@"BRELAN",
                                                                   @"CARRE",
                                                                   @"COULEUR",
                                                                   @"FULL",
                                                                   @"SUITE",
                                                                   @"QUINTEFLUSH",
                                                                   nil] autorelease]];
    
    // trie dans l'ordre croissant
    NSArray *sorted = [motifs keysSortedByValueUsingSelector:@selector(compare:)];
    
    // DEBUG
    for (int i = 0; i < [sorted count]; i++) {
        NSLog(@"sorted[%d]: %@ (%@)", i, [sorted objectAtIndex:i], [motifs objectForKey:[sorted objectAtIndex:i]]);
    }
    
    // je fais la liste des motifs remarquables (>= 3%) UNE_PAIRE exclus
    NSMutableDictionary *motifsRemarquables = [[NSMutableDictionary alloc] init];
    NSNumber *seuil = [NSNumber numberWithDouble:0.30];
    for (int i = 0; i < [sorted count]; i++) {
        
        if ([[motifs objectForKey:[sorted objectAtIndex:i]] doubleValue] >= [seuil doubleValue] &&
            [(NSString *)[sorted objectAtIndex:i] compare:@"UNE_PAIRE"] != 0 ) {
            [motifsRemarquables setValue:[motifs objectForKey:[sorted objectAtIndex:i]]
                                  forKey:[sorted objectAtIndex:i]];
        }
    }
    
    // DEBUG
    NSLog(@"Motifs remarquables:");
    for (NSString *k in [motifsRemarquables allKeys]) {
        NSLog(@"%@", k);
    }
    
    // si la liste est vide je prend par ordre de priorité parmis ces motifs 
    // sinon je prend le motif qui a la proba la plus importante dans le NSArray sorted
    int motifSelected = RIEN;
    if ([motifsRemarquables count] > 0) {
        
        // QUINTEFLUSH
        if ([motifsRemarquables objectForKey:@"QUINTEFLUSH"]) {
            motifSelected = QUINTEFLUSH;
        }
        
        // CARRE
        if (!motifSelected && [motifsRemarquables objectForKey:@"CARRE"]) {
            motifSelected = CARRE;
        }
        
        // FULL
        if (!motifSelected && [motifsRemarquables objectForKey:@"FULL"]) {
            motifSelected = FULL;
        }
        
        // COULEUR
        if (!motifSelected && [motifsRemarquables objectForKey:@"COULEUR"]) {
            motifSelected = COULEUR;
        }
        
        // SUITE
        if (!motifSelected && [motifsRemarquables objectForKey:@"SUITE"]) {
            motifSelected = SUITE;
        }
        
        // BRELAN
        if (!motifSelected && [motifsRemarquables objectForKey:@"BRELAN"]) {
            motifSelected = BRELAN;
        }
        
        // DEUX_PAIRES
        if (!motifSelected && [motifsRemarquables objectForKey:@"DEUX_PAIRES"]) {
            motifSelected = DEUX_PAIRE;
        }
        
        // UNE_PAIRE peut pas etre ici vu qu'on ne traite pas ce motif
        
    }
    else {
        NSLog(@"aucun motif remarquable detecté");
        
        NSString *tmp = [sorted objectAtIndex:([sorted count] - 1)];
        
        if ([tmp compare:@"UNE_PAIRE"] == 0) {
            motifSelected = UNE_PAIRE;
        }
        if (!motifSelected && [tmp compare:@"DEUX_PAIRES"] == 0) {
            motifSelected = DEUX_PAIRE;
        }
        if (!motifSelected && [tmp compare:@"BRELAN"] == 0) {
            motifSelected = BRELAN;
        }
        if (!motifSelected && [tmp compare:@"CARRE"] == 0) {
            motifSelected = CARRE;
        }
        if (!motifSelected && [tmp compare:@"COULEUR"] == 0) {
            motifSelected = COULEUR;
        }
        if (!motifSelected && [tmp compare:@"FULL"] == 0) {
            motifSelected = FULL;
        }
        if (!motifSelected && [tmp compare:@"SUITE"] == 0) {
            motifSelected = SUITE;
        }
        if (!motifSelected && [tmp compare:@"QUINTEFLUSH"] == 0) {
            motifSelected = QUINTEFLUSH;
        }
    }
    
    double nbOuts = 0;
    
    // connaissant le motif gagnant on retourne le nombre d'OUT correspondant
    switch (motifSelected) {
        case UNE_PAIRE:
            NSLog(@"le mieux c'est une paire");
            nbOuts = 6;
            break;
        case DEUX_PAIRE:
            NSLog(@"le mieux c'est deux paire");
            nbOuts = 5;
            break;
        case BRELAN:
            NSLog(@"le mieux c'est un brelan");
            nbOuts = 2;
            break;
        case CARRE:
            NSLog(@"le mieux c'est un carré");
            nbOuts = 7;
            break;
        case COULEUR:
            NSLog(@"le mieux c'est une couleur");
            nbOuts = 2;
            break;
        case FULL:
            NSLog(@"le mieux c'est un full");
            nbOuts = 7;
            break;
        case SUITE:
            NSLog(@"le mieux c'est une suite");
            nbOuts = 9;
            break;
        case QUINTEFLUSH:
            NSLog(@"le mieux c'est une quinteflush");
            nbOuts = 1;
            break;
        default:
            NSLog(@"erreur à la selection d'outs !");
            break;
    }
    
    coteAmelioration = nbOuts;
}

/*
    prend une carte et retourne sa représentation pour la lib de calcul externe
*/
- (NSString *)codify:(Carte *)c
{
    NSMutableString *res = [[NSMutableString alloc] init];
    
    if ([c valeur] < 2) {
        [res appendString:@"A"];
    }
    else {
        if ([c valeur] < 10) {
            [res appendFormat:@"%d", [c valeur]];
        }
        else {
            switch ([c valeur]) {
                case 10:
                    [res appendString:@"T"];
                    break;
                case 11:
                    [res appendString:@"V"];
                    break;
                case 12:
                    [res appendString:@"Q"];
                    break;
                case 13:
                    [res appendString:@"K"];
                    break;
                default:
                    break;
            }
        }
    }
    
    switch ([c couleur]) {
        case COEUR:
            [res appendString:@"h"];
            break;
        case CARREAU:
            [res appendString:@"d"];
            break;
        case TREFLE:
            [res appendString:@"c"];
            break;
        case PIQUE:
            [res appendString:@"s"];
            break;
        default:
            NSLog(@"oups, c'était pas censé arriver...(codify: carte dummy)");
            break;
    }
    return [[[NSString alloc] initWithString:[res autorelease]] autorelease];
}

@end
















