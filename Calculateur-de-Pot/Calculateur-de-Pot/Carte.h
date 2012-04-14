//
//  Carte.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 14/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { COEUR, PIQUE, CARREAU, TREFLE } Couleur;

@interface Carte : NSObject

@property (nonatomic, readonly, assign) Couleur couleur;
@property (nonatomic, readonly, assign) int valeur;
@property (nonatomic, readonly, retain) UIImage *image;

@end
