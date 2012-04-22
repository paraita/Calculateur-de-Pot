//
//  PokerOddsCalculator.h
//
/*
 Copyright (c) 2010 Lynn Pye
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "Pot_Calculator_Brain.h"

////
// something to hold state information for the cards in play
/*
 typedef enum
 {
 kHearts,
 kClubs,
 kDiamonds,
 kSpades,
 kUnknown
 } CardSuit;
 
 typedef enum
 {
 kHighCard,
 kPair,
 kTwoPair,
 kThreeOfAKind,
 kStraight,
 kFlush,
 kFullHouse,
 kFourOfAKind,
 kStraightFlush
 } PokerHand;
 */

@interface PokerOddsCalculator : NSObject {
	NSArray* cards;
	NSArray* rankslist;
	NSArray* suitslist;
    
}

@property(nonatomic,retain) NSArray* cards;
@property(nonatomic,retain) NSArray* rankslist;
@property(nonatomic,retain) NSArray* suitslist;

-(NSArray*)ranksList;
-(NSArray*)suitsList;

//- (CardSuit)suit;
//- (bool)turned;
//- (NSString*)rankAsString;
//- (NSString*)suitAsString;
//-(int)rankAsInt:(NSArray*)ranks;
//- (CardSuit)suit;
- (NSString*)rankAsString:(NSString*)c;
- (NSString*)suitAsString:(NSString*)c;
-(int)rankAsInt:(NSString*)c;

-(double)handsRemaining;
-(double)deckCardsLeft;
-(double)cardsTurned;
-(double)cardsUnturned;
-(double)cardsOfRank:(NSString*)rank;
-(double)cardsLeftOfRank:(NSString*)rank;
-(double)cardsNotOfRank:(NSString*)rank;
-(double)cardsOfSuit:(NSString*)suit;
-(double)cardsLeftOfSuit:(NSString*)suit;
-(double)cardsLeftNotOfSuit:(NSString*)suit;
-(double)cardsNotOfSuit:(NSString*)suit;
-(double)ranksInPlay;
-(double)suitsInPlay;
-(double)straightFlushesRemaining:(NSString*)suit;
-(double)straightsRemaining;

// methods to check for a hand
-(bool)haveBetterHand:(NomCoups)pokerHand;
-(bool)haveStraightFlush;
-(bool)haveFourOfAKind;
-(bool)haveFullHouse;
-(bool)haveFlush;
-(bool)haveStraight;
-(bool)haveThreeOfAKind;
-(bool)haveTwoPair;
-(bool)havePair;

// methods to calc chances
-(double)chanceOfStraightFlush;
-(double)chanceOfFourOfAKind;
-(double)chanceOfFullHouse;
-(double)chanceOfFlush;
-(double)chanceOfStraight;
-(double)chanceOfThreeOfAKind;
-(double)chanceOfTwoPair;
-(double)chanceOfPair;

// methods to calc hand counts
-(double)handsOfStraightFlush;
-(double)handsOfFourOfAKind;
-(double)handsOfFullHouse;
-(double)handsOfFlush;
-(double)handsOfStraight;
-(double)handsOfThreeOfAKind;
-(double)handsOfTwoPair;
-(double)handsOfPair;

@end


double factorial(double n);
double combination(double n, double r);
double permutation(double n, double r);
double power(double n, int p);
