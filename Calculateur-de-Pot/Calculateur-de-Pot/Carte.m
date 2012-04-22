//
//  Carte.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 14/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Carte.h"

@implementation Carte

@synthesize couleur;
@synthesize valeur;
@synthesize image;
@synthesize estPrise;

# pragma mark - Vie et mort d'une carte

- (void)dealloc
{
    [image release];
    image = nil;
    [super dealloc];
}

- (id)initWithColor:(Couleur)uneCouleur valeur:(int)uneValeur img:(UIImage *)uneImage
{
    self = [super init];
    if (self) {
        estPrise = NO;
        couleur = uneCouleur;
        valeur = uneValeur;
        image = uneImage;
        [image retain];
    }
    return self;
}

# pragma mark - description (pour le debug)
- (NSString *)description
{
    NSString *couleurString = nil;
    switch (couleur) {
        case COEUR:
            couleurString = @"Coeur";
            break;
        case PIQUE:
            couleurString = @"Pique";
            break;
        case CARREAU:
            couleurString = @"Carreau";
            break;
        default:
            couleurString = @"Trèfle";
            break;
    }
    return [NSString stringWithFormat:@"[%d de %@]", valeur, couleurString];
}


@end
