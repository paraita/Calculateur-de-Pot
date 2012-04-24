//
//  Pot_Calculator_Brain.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_Calculator_Brain.h"
#import "PokerOddsCalculator.h"
#define SEUIL 0.25
#define OUT_CARRE 1
#define OUT_QUINTEFLUSH 2
#define OUT_BRELAN 2
#define OUT_UNE_PAIRE 6
#define OUT_DEUX_PAIRE 5
#define OUT_SUITE 8
#define OUT_COULEUR 9


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
        
        
        // cartes de la partie (les 2 joueurs et le tapis)
        self.cartesEnJeu = [[NSMutableArray alloc] initWithCapacity:9];
        for (int i = 0; i < 9; i++) {
            [cartesEnJeu addObject:[self.paquetCartes objectAtIndex:0]];
        }
        
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
    cotePot = ( laTailleDuPot + laMise )/ laMise;
    [self detecterMain];
}

- (void)detecterMain
{
    double nbOuts = 0;
    
    NSLog(@"premiere carte joueur: %@", [self.premiereCarteJoueur description]);
    NSLog(@"deuxieme carte joueur: %@", [self.deuxiemeCarteJoueur description]);
    NSLog(@"flop 1: %@", [[self carteDuTapis:1] description]);
    NSLog(@"flop 2: %@", [[self carteDuTapis:2] description]);
    NSLog(@"flop 3: %@", [[self carteDuTapis:3] description]);
    NSLog(@"turn: %@", [[self carteDuTapis:4] description]);
    NSLog(@"river: %@", [[self carteDuTapis:5] description]);
    
    
    
    // on detecte le tapis pour savoir ou on en est
    int cnt = 0;
    if (self.premiereCarteJoueur.couleur != DUMMY) {
        cnt++;
    }
    if (self.deuxiemeCarteJoueur.couleur != DUMMY) {
        cnt++;
    }
    if ([self carteDuTapis:1].couleur != DUMMY) {
        cnt++;
    }
    if ([self carteDuTapis:2].couleur != DUMMY) {
        cnt++;
    }
    if ([self carteDuTapis:3].couleur != DUMMY) {
        cnt++;
    }
    if ([self carteDuTapis:4].couleur != DUMMY) {
        cnt++;
    }
    if ([self carteDuTapis:5].couleur != DUMMY) {
        cnt++;
    }
    NSLog(@"cnt=%d", cnt);
    if (cnt == 2) {
        self.etat = PREFLOP;
    }
    else {
        if (cnt == 5) {
            self.etat = FLOP;
        }
        else {
            if (cnt == 6) {
                self.etat = TURN;
            }
            else {
                if (cnt == 7) {
                    self.etat = RIVER;
                }
                else {
                    NSLog(@"erreur: vérifier le tapis");
                    coteAmelioration = nbOuts;
                    return;
                }
            }
        }
    }
    
    if (etat == PREFLOP) {
        NSLog(@"on est au PREFLOP");
        internalBrain.cards = nil;
        internalBrain.cards = [[NSArray alloc] initWithObjects:[self codify:[self premiereCarteJoueur]],
                               [self codify:[self deuxiemeCarteJoueur]],
                               nil];
    }
    else {
        if (etat == FLOP) {
            NSLog(@"on est au FLOP");
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
                NSLog(@"on est au TURN");
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
                NSLog(@"on est a la RIVER");
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
    for (int i = 0; i < [sorted count]; i++) {
        
        if ([[motifs objectForKey:[sorted objectAtIndex:i]] doubleValue] >= SEUIL &&
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
        
        /*
         on somme les OUT de tout les motifs remarquables, ca colle plus à la réalité
         */
        
        // QUINTEFLUSH
        if ([motifsRemarquables objectForKey:@"QUINTEFLUSH"]) {
            NSLog(@"possibilité de quinte flush");
            nbOuts += OUT_QUINTEFLUSH;
        }
        
        // CARRE
        if (!motifSelected && [motifsRemarquables objectForKey:@"CARRE"]) {
            NSLog(@"possibilité de carré");
            nbOuts += OUT_CARRE;
        }
        
        // FULL
        if (!motifSelected && [motifsRemarquables objectForKey:@"FULL"]) {
            NSLog(@"possibilité de full");
            nbOuts += OUT_SUITE;
        }
        
        // COULEUR
        if (!motifSelected && [motifsRemarquables objectForKey:@"COULEUR"]) {
            NSLog(@"possibilité de couleur");
            nbOuts += OUT_COULEUR;
        }
        
        // SUITE
        if (!motifSelected && [motifsRemarquables objectForKey:@"SUITE"]) {
            NSLog(@"possibilité de suite");
            nbOuts += OUT_SUITE;
        }
        
        // BRELAN
        if (!motifSelected && [motifsRemarquables objectForKey:@"BRELAN"]) {
            NSLog(@"possibilité de brelan");
            nbOuts += OUT_BRELAN;
        }
        
        // DEUX_PAIRES
        if (!motifSelected && [motifsRemarquables objectForKey:@"DEUX_PAIRES"]) {
            NSLog(@"possibilité de deux paires");
            nbOuts += OUT_DEUX_PAIRE;
        }
        
        // UNE_PAIRE peut pas etre ici vu qu'on ne traite pas ce motif
        
    }
    // si y'a aucun motif remarquable on prend celui qui possède la proba la plus
    // importante de tomber
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
        
        nbOuts = 0;
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
        
    }
    
    
    NSLog(@"nb Outs = %f ", nbOuts);
    coteAmelioration = (46.5 - nbOuts) / nbOuts;
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

-(Carte *)getFromPaquet:(NSString *)uneHauteur couleur:(NSString *)uneCouleur{
    int valHauteur = 0;
    int valCouleur = 0;
    int index = 0;
    
    if([uneHauteur isEqualToString:@"as"]){
        valHauteur = 1;
    }else{
        if([uneHauteur isEqualToString:@"valet"]){
            valHauteur = 11;
        }else{
            if([uneHauteur isEqualToString:@"dame"]){
                valHauteur = 12;
            }else{
                if([uneHauteur isEqualToString:@"roi"]){
                    valHauteur = 13;
                }
                else{
                    valHauteur = [uneHauteur intValue];
                }}}}
    
    if([uneCouleur isEqualToString:@"Coeur"]){
        valCouleur = 0;
    }
    else{
        if([uneCouleur isEqualToString:@"Carreau"]){
            valCouleur = 26;
        }
        else{
            if([uneCouleur isEqualToString:@"Pique"]){
                valCouleur = 13;
            }
            else{
                if([uneCouleur isEqualToString:@"Trefle"]){
                    valCouleur = 39;
                }}}}
    index = valCouleur + valHauteur;
    Carte *c = [self.paquetCartes objectAtIndex:index];
    NSLog(@"%@ et index = %d",c.description, index);
    return c;
}

- (void)resetBrain
{
    coteAmelioration = 0.0;
    self.cartesEnJeu = nil;
    self.cartesEnJeu = [[NSMutableArray alloc] initWithCapacity:9];
    for (int i = 0; i < 9; i++) {
        [cartesEnJeu addObject:[self.paquetCartes objectAtIndex:0]];
    }
}

@end
















