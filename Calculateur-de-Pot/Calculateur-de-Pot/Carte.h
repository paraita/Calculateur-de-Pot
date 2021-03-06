//
//  Carte.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 14/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    COEUR = 1,
    PIQUE = 2,
    CARREAU = 3,
    TREFLE = 4,
    DUMMY = 5
} Couleur;

@interface Carte : NSObject

@property (nonatomic, readonly, assign) Couleur couleur;
@property (nonatomic, readonly, assign) int valeur;
@property (nonatomic, readonly, retain) UIImage *image;
@property (nonatomic, assign) BOOL estPrise;

- (id)initWithColor:(Couleur)uneCouleur valeur:(int)uneValeur img:(UIImage *)uneImage;
- (NSString *)description;
@end
