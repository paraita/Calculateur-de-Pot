//
//  Pot_Calculator_Brain.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 04/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pot_Calculator_Brain : NSObject

@property (nonatomic, assign) float taillePot;
@property (nonatomic, assign) float mise;
@property (nonatomic, readonly) float cote;

- (void)calculerCote:(float)laTailleDuPot mise:(float)laMise;

@end
