//
//  PokerOddsCalculator.m
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

#import "PokerOddsCalculator.h"
#import "Pot_Calculator_Brain.h"

@implementation PokerOddsCalculator

@synthesize cards;
@synthesize rankslist;
@synthesize suitslist;

-(id)init
{
    self = [super init];
    if (self)
	{
		rankslist = [[self ranksList] retain];
		suitslist = [[self suitsList] retain];
    }
    return self;
}

-(NSArray*)ranksList
{
	return [NSArray arrayWithObjects:@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"T",@"J",@"Q",@"K",nil];
}

-(NSArray*)suitsList
{
	return [NSArray arrayWithObjects:@"s",@"h",@"d",@"c",nil];
}

-(Couleur)suit:(NSString*)c
{
	if (nil == c)
	{
		return DUMMY;
	}
	switch ([c characterAtIndex:1])
	{
		case 's':
			return PIQUE;
		case 'h':
			return COEUR;
		case 'd':
			return CARREAU;
		case 'c':
			return TREFLE;
		default:
			return DUMMY;
	}
}

-(NSString*)suitAsString:(NSString*)c
{
	return [c substringWithRange:NSMakeRange(1,1)];
}

-(NSString*)rankAsString:(NSString*)c
{
	return [c substringWithRange:NSMakeRange(0, 1)];
}

-(int)rankAsInt:(NSString*)c
{
	if (nil == c)
	{
		return -1;
	}
	return [rankslist indexOfObject:[c substringWithRange:NSMakeRange(0, 1)]];
}

-(double)handsRemaining
{
	double turned = [self cardsTurned];
	
	if (turned > 6.0)
	{
		return 0.0; // if we have turned 7 or more cards (well, 7 anyway), there are no more hands remaining
	}
	
	return combination(52.0-turned, 7.0-turned);
}

-(double)deckCardsLeft
{
	return 52.0 - [self cardsTurned];
}

-(double)cardsTurned
{
	return [cards count];
}

-(double)cardsUnturned
{
	return 7.0 - [self cardsTurned];
}

-(double)cardsOfRank:(NSString*)rank
{
	if (nil == rank)
	{
		return 0.0;
	}
	
	double num = 0.0;
	
	for (NSString* card in cards)
	{
		if (NSOrderedSame == [rank compare:[self rankAsString:card]])
		{
			num += 1.0;
		}
	}
	
	return num;
}

-(double)cardsLeftOfRank:(NSString*)rank
{
	return 4.0 - [self cardsOfRank:rank];
}

-(double)cardsNotOfRank:(NSString*)rank
{
	return [self cardsTurned] - [self cardsOfRank:rank];
}

-(double)cardsOfSuit:(NSString*)suit
{
	if (nil == suit)
	{
		return 0.0;
	}
	
	double num = 0.0;

	for (NSString* card in cards)
	{
		if (NSOrderedSame == [suit compare:[self suitAsString:card]])
		{
			num += 1.0;
		}
	}
	
	return num;
}

-(double)cardsLeftOfSuit:(NSString*)suit
{
	return 13.0 - [self cardsOfSuit:suit];
}

-(double)cardsLeftNotOfSuit:(NSString*)suit
{
	return 39.0 - [self cardsNotOfSuit:suit];
}

-(double)cardsNotOfSuit:(NSString*)suit
{
	return [self cardsTurned] - [self cardsOfSuit:suit];
}

-(double)ranksInPlay
{
	double r = 0.0;
	for (NSString* rank in rankslist)
	{
		if ([self cardsOfRank:rank] > 0)
		{
			r += 1.0;
		}
	}
	return r;
}

-(double)suitsInPlay
{
	double r = 0.0;
	for (NSString* suit in suitslist)
	{
		if ([self cardsOfSuit:suit] > 0)
		{
			r += 1.0;
		}
	}
	return r;
}

-(bool)haveBetterHand:(NomCoups)unNomDeCoup
{
	bool hasBetter = false;
	switch (unNomDeCoup)
	{
		default:
			hasBetter = [self havePair];
		case UNE_PAIRE:
			hasBetter = hasBetter || [self haveTwoPair];
		case DEUX_PAIRE:
			hasBetter = hasBetter || [self haveThreeOfAKind];
		case BRELAN:
			hasBetter = hasBetter || [self haveStraight];
		case SUITE:
			hasBetter = hasBetter || [self haveFlush];
		case COULEUR:
			hasBetter = hasBetter || [self haveFullHouse];
		case FULL:
			hasBetter = hasBetter || [self haveFourOfAKind];
		case CARRE:
			hasBetter = hasBetter || [self haveStraightFlush];
		case QUINTEFLUSH:
			return hasBetter || false;
	}
	return hasBetter;
}

-(bool)haveStraightFlush
{
	for (NSString* suit in suitslist)
	{
		int cs[14]; // Ace high and low
		for (int jj = 0; jj < 14; ++jj)
		{
			cs[jj] = 0; // zero it out, yeah screw memcpy
		}

		for (NSString* card in cards)
		{
			if (NSOrderedSame != [suit compare:[self suitAsString:card]])
			{
				continue;
			}
			
			cs[[self rankAsInt:card]]++;
		}
		cs[13] = cs[0]; // Ace high is Ace low too
		
		for (int i = 0; i < 10; ++i)
		{
			int c = 0;
			for (int j = 0; j < 5; ++j)
			{
				c += cs[j+i];
			}
			if (c == 5)
			{
				return true; // got one
			}
		}
	}
	return false;
}

-(bool)haveFourOfAKind
{
	for (NSString* rank in rankslist)
	{
		if ([self cardsOfRank:rank] >= 4.0)
		{
			return true;
		}
	}
	return false;
}

-(bool)haveFullHouse
{
	for (int i = 0; i < [rankslist count]-1; ++i)
	{
		for (int j = i+1; j < [rankslist count]; ++j)
		{
			double ci = [self cardsOfRank:[rankslist objectAtIndex:i]];
			double cj = [self cardsOfRank:[rankslist objectAtIndex:j]];
			if ((ci >= 3.0 && cj >= 2.0) || (ci >= 2.0 && cj >= 3.0))
			{
				return true;
			}
		}
	}
	
	return false;
}

-(bool)haveFlush
{
	for (NSString* suit in suitslist)
	{
		if ([self cardsOfSuit:suit] >= 5.0)
		{
			return true;
		}
	}
	return false;
}

-(bool)haveStraight
{
	int cs[14]; // Ace high and low
	for (int jj = 0; jj < 14; ++jj)
	{
		cs[jj] = 0; // zero it out, yeah screw memcpy
	}

	for (NSString* card in cards)
	{
		cs[[self rankAsInt:card]] = 1;
	}
	cs[13] = cs[0]; // Ace high is Ace low too
	
	for (int i = 0; i < 10; ++i)
	{
		int c = 0;
		for (int j = 0; j < 5; ++j)
		{
			c += cs[j+i];
		}
		if (c == 5)
		{
			return true; // got one
		}
	}
	return false;
}

-(bool)haveThreeOfAKind
{
	for (NSString* rank in rankslist)
	{
		if ([self cardsOfRank:rank] >= 3.0)
		{
			return true;
		}
	}
	return false;
}

-(bool)haveTwoPair
{
	int paircount = 0;
	for (NSString* rank in rankslist)
	{
		if ([self cardsOfRank:rank] >= 2.0)
		{
			++paircount;
		}
	}
	return paircount>1;
}

-(bool)havePair
{
	for (NSString* rank in rankslist)
	{
		if ([self cardsOfRank:rank] >= 2.0)
		{
			return true;
		}
	}
	return false;
}

-(double)chanceOfStraightFlush
{
	// check to see that we don't already have a straight flush
	// and that it isn't impossible to get
	// first make an int array
	bool canMakeSF = false;
	for (NSString* suit in suitslist)
	{
		int cs[14]; // Ace high and low
		for (int jj = 0; jj < 14; ++jj)
		{
			cs[jj] = 0; // zero it out, yeah screw memcpy
		}

		for (NSString* card in cards)
		{
			if (NSOrderedSame != [suit compare:[self suitAsString:card]])
			{
				continue;
			}
			cs[[self rankAsInt:card]]++;
		}
		cs[13] = cs[0]; // Ace high is Ace low too
		
		for (int i = 0; i < 10; ++i)
		{
			int c = 0;
			for (int j = 0; j < 5; ++j)
			{
				c += cs[j+i];
			}
			if (c == 5)
			{
				return 1.0; // got one
			}
			if (5-c <= [self cardsUnturned])
			{
				canMakeSF = true;
			}
		}
	}
	
	if (!canMakeSF)
	{
		return 0.0;
	}
	
	return [self handsOfStraightFlush] / [self handsRemaining];
}

-(double)chanceOfFourOfAKind
{
	if ([self haveBetterHand:CARRE])
	{
		return 0.0; // already have better
	}
	bool canMake4 = false;
	for (NSString* rank in rankslist)
	{
		if ([self cardsOfRank:rank] >= 4.0)
		{
			return 1.0;
		}
		if ([self cardsLeftOfRank:rank] <= [self cardsUnturned])
		{
			canMake4 = true;
		}
	}
	if (!canMake4)
	{
		return 0.0; // not enough unturned cards to give a 4of a kind
	}
	return [self handsOfFourOfAKind] / [self handsRemaining];
}

-(double)chanceOfFullHouse
{
	if ([self haveBetterHand:FULL])
	{
		return 0.0;
	}
	if ([self haveFullHouse])
	{
		return 1.0;
	}
	
	int numranks = 0;
	for (NSString* rank in rankslist)
	{
		double cor = [self cardsOfRank:rank];
		if (cor > 0)
		{
			++numranks;
		}
	}
	if (numranks > 4)
	{
		return 0.0;
	}
	
	// we have fewer than 4 ranks so we can't have a straight
	// we don't have a better hand, so we don't have a 4K
	// which means we can run our calcs
	
	return [self handsOfFullHouse] / [self handsRemaining];
}

- (double) chanceOfFlush
{
	if ([self haveBetterHand:COULEUR])
	{
		return 0.0;
	}
	bool canMakeFlush = false;
	for (NSString* suit in suitslist)
	{
		if ([self cardsOfSuit:suit] >= 5.0)
		{
			return 1.0;
		}
		else if (5.0 - [self cardsOfSuit:suit] <= [self cardsUnturned])
		{
			canMakeFlush = true;
		}
	}
	
	if (!canMakeFlush)
	{
		return 0.0;
	}
	
	return [self handsOfFlush] / [self handsRemaining];
}

-(double)chanceOfStraight
{
	if ([self haveBetterHand:SUITE])
	{
		return 0.0;
	}
	bool canMakeS = false;
	int cs[14]; // Ace high and low
	for (int jj = 0; jj < 14; ++jj)
	{
		cs[jj] = 0; // zero it out, yeah screw memcpy
	}

	for (NSString* card in cards)
	{
		cs[[self rankAsInt:card]] = 1;
	}
	cs[13] = cs[0]; // Ace high is Ace low too
	
	for (int i = 0; i < 10; ++i)
	{
		int c = 0;
		for (int j = 0; j < 5; ++j)
		{
			c += cs[j+i];
		}
		if (c == 5)
		{
			return 1.0; // got one
		}
		if (5-c <= [self cardsUnturned])
		{
			canMakeS = true;
		}
	}
	
	if (!canMakeS)
	{
		return 0.0;
	}
	
	return [self handsOfStraight] / [self handsRemaining];
}

-(double)chanceOfThreeOfAKind
{
	if ([self haveBetterHand:BRELAN])
	{
		return 0.0;
	}
	if ([self haveThreeOfAKind])
	{
		return 1.0;
	}
	if ([self ranksInPlay]>5)
	{
		return 0.0;
	}
	if ([self haveTwoPair])
	{
		// we can't make a 3 of a Kind in this case, instead we'll end up with a FH, so return 0
		return 0.0;
	}
	
	// otherwise return the calculation
	return [self handsOfThreeOfAKind] / [self handsRemaining];
}

-(double)chanceOfTwoPair
{
	if ([self haveBetterHand:DEUX_PAIRE])
	{
		return 0.0;
	}
	if ([self haveTwoPair])
	{
		return 1.0;
	}
	return [self handsOfTwoPair] / [self handsRemaining];
}

-(double)chanceOfPair
{
	if ([self haveBetterHand:UNE_PAIRE])
	{
		return 0.0;
	}
	if ([self havePair])
	{
		return 1.0;
	}
	if ([self ranksInPlay] > 6)
	{
		return 0.0;
	}
	
	// otherwise return the calculation
	return [self handsOfPair] / [self handsRemaining];
}


// calculations of possible hands remaining to be played per type
// perhaps assume that the hand isn't already obtained? would need to do that
// check in the chanceOf... method
-(double)straightFlushesRemaining:(NSString*)suit
{
	// first make an int array
	int cs[14]; // Ace high and low
	for (int jj = 0; jj < 14; ++jj)
	{
		cs[jj] = 0; // zero it out, yeah screw memcpy
	}

	for (NSString* card in cards)
	{
		if (NSOrderedSame != [suit compare:[self suitAsString:card]])
		{
			continue;
		}
		cs[[self rankAsInt:card]]++;
	}
	cs[13] = cs[0]; // Ace high is Ace low too
	
	double tothands = 0.0;
	
	for (int sLen = 5; sLen <= 7; ++sLen)
	{
		for (int left = 0; left <= 14-sLen; ++left)
		{
			int right = left + sLen;
			
			// make sure we aren't part of a larger straightFlush
			if (sLen < 7 && ((left > 0 && cs[left-1]>0) || (right < 13-sLen && cs[right+1]>0)))
			{
				continue; // skip to the next
			}
			
			double gapsInSpan = 0;
			for (int i = left; i < right; ++i)
			{
				if (cs[i] == 0)
				{
					gapsInSpan += 1.0;
				}
			}
			if (gapsInSpan > [self cardsUnturned])
			{
				continue;
			}
			
			double r = [self cardsUnturned] - gapsInSpan;
			double n = [self deckCardsLeft] - gapsInSpan - 1.0;
			
			if (left > 0 && left < 14-sLen)
			{
				n -= 1.0; // strip extra Ace
			}
			
			tothands += combination(n,r);
		}
	}
	
	return tothands;
}

-(double)straightsRemaining
{
	// first make an int array
	int cs[14]; // Ace high and low
	for (int jj = 0; jj < 14; ++jj)
	{
		cs[jj] = 0; // zero it out, yeah screw memcpy
	}
	
	for (NSString* card in cards)
	{
		/*
		 * don't go by suit
		 if (nil != suit && NSOrderedSame != [suit compare:[cps suitAsString]])
		 {
		 continue;
		 }
		 */
		cs[[self rankAsInt:card]]++;
	}
	cs[13] = cs[0]; // Ace high is Ace low too
	
	double tothands = 0.0;
	
	for (int sLen = 5; sLen <= 7; ++sLen)
	{
		for (int left = 0; left <= 14-sLen; ++left)
		{
			int right = left + sLen;
			
			// make sure we aren't part of a larger straight
			if (sLen < 7 && ((left > 0 && cs[left-1]>0) || (right < 13-sLen && cs[right+1]>0)))
			{
				continue; // skip to the next
			}
			
			double gapsInSpan = 0;
			for (int i = left; i < right; ++i)
			{
				if (cs[i] == 0)
				{
					gapsInSpan += 1.0;
				}
			}
			if (gapsInSpan > [self cardsUnturned])
			{
				continue;
			}
			
			double r = [self cardsUnturned] - gapsInSpan;
			double n = [self deckCardsLeft] - gapsInSpan - 4.0;
			
			if (left > 0 && left < 14-sLen)
			{
				n -= 4.0; // strip extra Ace
			}
			
			tothands += combination(n,r) * power(4.0,(int)gapsInSpan);
		}
	}
	
	// now to remove flushes
	double flushesToRemove = 0.0;
	
	for (NSString* suit in suitslist)
	{
		int scs[14]; // Ace high and low
		for (int jj = 0; jj < 14; ++jj)
		{
			scs[jj] = 0; // zero it out, yeah screw memcpy
		}

		for (NSString* card in cards)
		{
			if (NSOrderedSame != [suit compare:[self suitAsString:card]])
			{
				continue;
			}
			scs[[self rankAsInt:card]]++;
		}
		scs[13] = scs[0]; // Ace high is Ace low too
		for (int sLen = 5; sLen <= 7; ++sLen)
		{
			if ([self cardsNotOfSuit:suit] > 7 - sLen)
			{
				continue; // can't make a flush with this suit given current cards
			}
			
			for (int left = 0; left <= 14 - sLen; ++left)
			{
				int right = left + sLen;
				
				// make sure we aren't part of a larger straightFlush
				if (sLen < 7 && ((left > 0 && scs[left-1]>0) || (right < 13-sLen && scs[right+1]>0)))
				{
					continue; // skip to the next
				}
				
				double gapsInSpan = 0;
				for (int i = left; i < right; ++i)
				{
					if (scs[i] == 0)
					{
						gapsInSpan += 1.0;
					}
				}
				if (gapsInSpan > [self cardsUnturned])
				{
					continue;
				}
				
				double r = [self cardsUnturned] - gapsInSpan;
				double n = [self deckCardsLeft] - gapsInSpan - 1.0;
				
				if (left > 0 && left < 14-sLen)
				{
					n -= 1.0; // strip extra Ace
				}
				
				flushesToRemove += combination(n,r)*power(3.0,7-sLen);
			}
		}
	}
	
	return tothands - flushesToRemove;
}

-(double)handsOfStraightFlush
{
	double result = [self straightFlushesRemaining:@"s"] + [self straightFlushesRemaining:@"h"] + [self straightFlushesRemaining:@"c"] + [self straightFlushesRemaining:@"d"];
	return result;
}

-(double)handsOfFourOfAKind
{
	double tothands = 0.0;
	
	for (NSString* rank in rankslist)
	{
		if ([self cardsUnturned] >= [self cardsLeftOfRank:rank])
		{
			// accumulate possibilities
			tothands += combination([self deckCardsLeft] - [self cardsLeftOfRank:rank], [self cardsUnturned] - [self cardsLeftOfRank:rank]);
		}
	}
	
	return tothands;
}

-(double)handsOfFullHouse
{
	double tothands = 0.0;
	
	int numranks = 0;
	int ranksOver2 = 0;
	int ranksOver1 = 0;
	int rank0 = 0;
	int rank1 = 0;
	int rank2 = 0;
	int rank3 = 0;
	double cardsOfRank[13];
	int idx = 0;
	for (NSString* rank in rankslist)
	{
		double cor = [self cardsOfRank:rank];
		cardsOfRank[idx++] = cor;
		if (cor > 0)
		{
			++numranks;
		}
		if (cor > 1)
		{
			++ranksOver1;
		}
		if (cor > 2)
		{
			++ranksOver2;
		}
		if (cor == 1.0)
		{
			rank1++;
		}
		if (cor == 2.0)
		{
			rank2++;
		}
		if (cor == 3.0)
		{
			rank3++;
		}
	}
	rank0 = 3 - rank3 - rank2 - rank1;
	// how many 3x3x1
	// 3 ranks (any more dq's)
	// only 2 ranks can exceed 1
	if (numranks <= 3 && ranksOver1 <= 2)
	{
		// a) C(13,2) triplets
		// b) C(4,3) triplets per rank
		// c) 44 (52-8) cards for singleton
		// C(13,2) * C(4,3) * C(4,3) * 44
		
		/*
		 for a) you are choosing among all ranks that are not already over 1 and choosing r spots where r is 2 - the number of ranks already over 1
		 for b) each 3rank chooses from remaining cards of that rank for 3-numberofcardsofthatrankinplay
		 for c) just multiply by the number of cards in the deck - cards in the deck of either 3rank
		 */
		double a = combination(13.0-ranksOver1,2.0-ranksOver1);
		double c = 1.0;
		if (numranks < 3)
		{
			c *= power(combination(4.0,3.0),rank0-1) * power(combination(3.0,2.0),rank1) * power(combination(2.0,1.0),rank2) * 44.0;
		}
		if (rank1 == 1)
		{
			c *= power(combination(2.0,1.0),rank2) * power(combination(3.0,2.0),rank1-1) * power(combination(4.0,3.0),rank0);
		}
		tothands += a * c;
	}
	
	// how many 3x2x2
	// 3 ranks (any more dq's)
	// only 1 rank can exceed 2
	if (numranks <= 3 && ranksOver2 <= 1)
	{
		double subtotal = 0.0;
		
		if (rank0 > 1 || rank3 > 0)
		{
			subtotal += 
			power((13.0-numranks),1.0-rank3)
			*combination(4.0-(rank3*3.0), 3.0-(rank3*1.0))
			*combination(13.0-numranks-1.0+rank3, 2.0-numranks)
			*power(combination(4.0,2.0),rank0-1)
			*power(combination(3.0,1.0),rank1);
		}
		if (rank1 > 1 && rank3 < 1)
		{
			subtotal +=
			combination(3.0, 2.0)
			*combination(13.0-numranks, 3.0-numranks)
			*power(combination(4.0,2.0),rank0)
			*power(combination(3.0,1.0),rank1);
		}
		if (rank2 > 1 && rank3 < 1)
		{
			subtotal +=
			combination(2.0, 1.0)
			*combination(13.0-numranks, 3.0-numranks)
			*power(combination(4.0, 2.0), rank0)
			*power(combination(3.0, 1.0), rank1);
		}
		
		tothands += subtotal;
	}
	
	// how many 3x2x1x1
	// 4 ranks (any more or less dq's)
	// only 1 rank over 2 and only 3 ranks over 1
	if (numranks <= 4 && ranksOver1 <= 3 && ranksOver2 <= 1)
	{
		/*
		 Case 3:  1 set of triples, 1 pair, 2 blanks (don't match either the
		 triple, the pair, or each other).  There are 13 ways to pick the rank
		 of the triples.  There are 12 ways to pick the rank of the pair.  And
		 there are C(11,2) ways to pick the ranks of the blanks.  There are
		 C(4,3) ways of picking the suits of the triples.  There are C(4,2)
		 ways of picking the suits of the pair.  And for each blank, there are
		 4 suits available.  So, there's a total of
		 13*12*C(11,2)*C(4,3)*C(4,2)*4*4 = 3,294,720 ways of getting this type
		 of full house.
		 
		 13 * C(4,3) * 12 * C(4,2) * C(11,2) * 4 * 4
		 
		 r1 2 3 4
		 
		 0 0 0 0		  13 c(4,3) 12 c(4,2) c(11,2) c(4,1) c(4,1)	
		 0 0 0 1		  12 c(4,3) 11 c(4,2) c(10,1) c(4,1) c(3,0)		+ 12 c(4,3) c(3,1) c(11,2) c(4,1) c(4,1)		+ c(3,2) 11 c(4,2) c(11,2) c(4,1) c(4,1)
		 0 0 1 1		  11 c(4,3) 10 c(4,2) c(9,0) c(3,0) c(3,0)		+ 11 c(4,3) c(3,1) c(10,1) c(4,1) c(3,0)		+ c(3,2) c(3,1) c(11,2) c(4,1) c(4,1)
		 + c(3,2) 11 c(4,2) c(10,1) c(4,1) c(3,0)
		 0 0 1 2														  c(2,1) 11 c(4,2) c(10,1) c(4,1) c(3,0)		+ c(2,1) c(3,1) c(11,2) c(4,1) c(4,1)
		 + 11 c(4,3) c(2,0) c(10,1) c(4,1) c(3,0)		+ c(3,2) c(2,0) c(11,2) c(4,1) c(4,1)
		 0 0 1 3		  c(1,0) c(3,1) c(11,2) c(4,1) c(4,1)			+ c(1,0) 11 c(4,2) c(10,1) c(4,1) c(3,0)
		 0 0 2 2		  c(2,1) c(2,0) c(11,2) c(4,1) c(4,1)
		 0 0 2 3		  c(1,0) c(2,0) c(11,2) c(4,1) c(4,1)
		 0 1 1 1		  10 c(4,3) c(3,1) c(9,0) c(3,0) c(3,0)			+ c(3,2) c(3,1) c(10,1) c(4,1) c(3,0)
		 + c(3,2) 10 c(4,2) c(9,0) c(3,0) c(3,0)
		 0 1 1 2														  c(3,2) c(2,1) c(10,1) c(4,1) c(3,0)			+ c(2,1) c(3,1) c(10,1) c(4,1) c(3,0)
		 + 10 c(4,3) c(2,1) c(9,0) c(4,1) c(3,0)			+ c(2,1) 10 c(4,2) c(9,0) c(3,0) c(3,0)
		 0 1 1 3														  c(1,0) 10 c(4,2) c(9,0) c(3,0) c(3,0)			+ c(1,0) c(3,1) c(10,1) c(4,1) c(3,0)
		 0 1 2 2		  c(2,1) c(2,0) c(10,1) c(4,1) c(3,0)
		 0 1 2 3		  c(1,0) c(2,0) c(10,1) c(4,1) c(3,0)
		 1 1 1 1		  c(3,2) c(2,1) c(9,0) c(3,0) c(3,0)
		 1 1 1 2		  c(2,1) c(3,1) c(9,0) c(3,0) c(3,0)			+ c(3,2) c(2,0) c(9,0) c(3,0) c(3,0)
		 1 1 1 3		  c(1,0) c(3,1) c(9,0) c(3,0) c(3,0)
		 1 1 2 2		  c(2,1) c(2,0) c(9,0) c(3,0) c(3,0)
		 1 1 2 3		  winner winner chicken dinner
		 
		 */
		double subtotal = 0.0;
		
		rank0 = 4 - rank3 - rank2 - rank1; // readjust rank0
		
		if (rank3)
		{
			if (rank2)
			{
				subtotal += 
				combination(13.0-numranks, 2.0-numranks)
				*power(4.0, rank0);
			}
			else
			{
				if (rank0)
				{
					subtotal +=
					(13.0-numranks)
					*combination(4.0, 2.0)
					*combination(13.0-numranks-1.0, 3.0-numranks)
					*power(4.0, rank0-1);
				}
				if (rank1)
				{
					subtotal +=
					combination(3.0, 1.0)
					*combination(3.0-rank0, 2.0-rank0)
					*combination(13.0-numranks, 4.0-numranks)
					*power(4.0, rank0);
				}
			}
			
		}
		else if (rank2)
		{
			if (rank2 > 1)
			{
				subtotal +=
				2.0
				*combination(9.0+rank0, rank0)
				*power(4.0,rank0)
				;
			}
			else if (rank0 == 0 || rank1 == 0)
			{
				double m = rank1?1.0:0.0;
				subtotal +=
				power(12.0, 1-rank1)
				*combination(2.0, 1.0)
				*combination(4.0-m, 2.0-m)
				*combination(11.0-2*m, 2.0-2*m)
				*power(4.0, rank0-1)
				;
				
				subtotal +=
				power(12.0, 1-rank1)
				*combination(4.0-m, 3.0-m)
				*combination(11.0-2*m, 2.0-2*m)
				*power(4.0, rank0-1)
				;
			}
			else
			{
				// T is 0 (P has to be 2, B is 01 or 00)
				// T is 1 (P has to be 2, B is 01 or 00)
				// T is 2 (P/B is 1/00|01 or 0/11|01)
				subtotal +=
				(13.0-numranks)
				*combination(4.0, 3.0)
				*combination(8.0+rank0, rank0)
				*power(4.0, rank0);
				
				subtotal +=
				combination(3.0, 2.0)
				*combination(9.0+rank0, rank0)
				*power(4.0, rank0);
				
				subtotal +=
				(13.0-numranks)
				*combination(2.0, 1.0)
				*combination(4.0, 2.0)
				*combination(12.0-numranks, 3.0-numranks)
				*power(4.0, rank0-1);
				
				subtotal +=
				6.0
				*combination(9.0+rank0, rank0)
				*power(4.0, rank0);
			}
		}
		else if (rank1 && rank0)
		{
			subtotal +=
			combination(3.0, 2.0)
			*(13.0-numranks)
			*combination(4.0, 2.0)
			*combination(9.0+rank0-1, rank0-1)
			*power(4.0, rank0-1);
			
			subtotal +=
			(13.0-numranks)
			*combination(4.0, 3.0)
			*combination(3.0, 1.0)
			*combination(8.0+rank0, rank0-1)
			*power(4.0, rank0-1);
			
			if (rank1 > 1)
			{
				subtotal +=
				combination(3.0, 2.0)
				*combination(3.0, 1.0)
				*combination(9.0+rank0, rank0)
				*power(4.0, rank0);
			}
			if (rank0 > 1)
			{
				subtotal +=
				(13.0-numranks)
				*combination(4.0, 3.0)
				*(12.0-numranks)
				*combination(4.0, 2.0)
				*combination(11.0-rank1, 2.0-rank1)
				*power(4.0, rank0-2);
			}
		}
		else // all zeroes or all ones, special cases, ugh
		{
			double m = rank1?1.0:0.0;
			subtotal += 
				power(13.0,(4-rank1)/4)
				* combination(4.0-m, 3.0-m)
				* power(12.0,(4-rank1)/4)
				* combination(4.0-m, 2.0-m)
				* combination(11.0-2.0*m, 2.0-2.0*m)
				* power(4.0,rank0-2);
		}
		
		tothands += subtotal;
	}
	
	return tothands;
}

-(double)handsOfFlush
{
	double tothands = 0.0;
	
	for (NSString* suit in suitslist)
	{
		int cs[14];
		for (int z = 0; z < 14; z++) cs[z] = 0;
		for (NSString* card in cards)
		{
			if (NSOrderedSame != [suit compare:[self suitAsString:card]])
			{
				continue;
			}
			cs[[self rankAsInt:card]]++;
		}
		cs[13] = cs[0];
		double fs[3];
		for (int z = 0; z<3;z++) fs[z] = 0.0;
		double remainingCurrentFlushes = 0.0; // will use this
		for (int fLen = 5; fLen <= 7; ++fLen)
		{
			if ([self cardsNotOfSuit:suit] > 7-fLen)
			{
				continue; // too many off suit cards to flush this suit
			}
			if ([self cardsOfSuit:suit] > fLen)
			{
				continue; // too many suited cards for this small a flush
			}
			double possibleStraights = 0.0;
			double unsuitedSpotsLeft =  7 - fLen - [self cardsNotOfSuit:suit];
			double blankCombos = combination([self cardsLeftNotOfSuit:suit], unsuitedSpotsLeft); // use this
			remainingCurrentFlushes += combination([self cardsLeftOfSuit:suit],fLen - [self cardsOfSuit:suit]);
			for (int sLen = 5; sLen <= 7; ++sLen)
			{
				if (sLen > fLen)
				{
					continue; // heh...can't happen :)
				}
				for (int left = 0; left <= 14-sLen; ++left)
				{
					int right = left + sLen;
					// make sure we aren't part of a larger straight
					if (sLen < 7 && ((left > 0 && cs[left-1]>0) || (right < 13-sLen && cs[right+1]>0)))
					{
						continue; // skip to the next
					}
					
					double gapsInSpan = 0;
					for (int i = left; i < right; ++i)
					{
						if (cs[i] == 0)
						{
							gapsInSpan += 1.0;
						}
					}
					if (gapsInSpan > [self cardsUnturned])
					{
						continue;
					}
					
					double suitedCardsOutsideOfStraight = [self cardsOfSuit:suit] - (sLen - gapsInSpan);
					double cardsToConsider = [self cardsLeftOfSuit:suit] - gapsInSpan;
					cardsToConsider -= 1.0;
					if (left > 0 && left < 14-sLen)
					{
						cardsToConsider -= 1.0;
					}
					possibleStraights += combination(
													 cardsToConsider,
													 fLen - sLen - suitedCardsOutsideOfStraight
													 );
					
				}
			}
			fs[fLen-5] += (combination([self cardsLeftOfSuit:suit],fLen - [self cardsOfSuit:suit]) - possibleStraights) * blankCombos;
		}
		
		tothands += fs[0] + fs[1] + fs[2];
	}
	return tothands;
}

-(double)handsOfStraight
{
	double result = [self straightsRemaining];
	return result;
}

-(double)handsOfThreeOfAKind
{
	// we only get here if
	// a) there is no better hand
	// b) there aren't more than 5 ranks in play
	// c) we don't already have a 3K
	// d) we don't already have 2P (meaning we would go up to a FH if we trip)
	
	//
	// Interesting thing... C(4,3) term below was C(5,4) in the original notes, but I think that's wrong
	//
	// (C(13,5)-10)   -- 13 ranks distributed out to 5 spots, removing 10 possible straights (remember, we do NOT have a straight already)
	//  * 5			  -- any of the 5 ranks for our trips
	//  * C(4,3)	  -- ways to drop 3 out of 4 suits into our trips
	//  * 253		  -- 4^4 ways to distribute suits to remaining singletons - 3 possible flush completions
	double tothands = 0.0;
	
	double tripcount = 0.0;
	for (NSString* rank in rankslist)
	{
		if ([self cardsOfRank:rank]>tripcount)
		{
			tripcount = [self cardsOfRank:rank];
		}
	}
	
	double singles = [self cardsTurned] - (tripcount>1.0?1.0:0.0);
	//double empties = 7.0 - singles - tripcount;
	double numranks = [self ranksInPlay];
	
	double rankdist = combination(13.0-numranks, 5.0-numranks);
	double rmstraights = 0.0;
	double triprank = (tripcount>1.0)?1.0:5.0;
	double tripsuits = combination(4.0-tripcount, 3.0-tripcount);
	double singlesuits = power(4.0, (int)singles);
	double rmflushes = (tripcount>1.0)?:-9999999;
	
	tothands = (rankdist - rmstraights) * triprank * tripsuits * (singlesuits - rmflushes);
	
	if (tripcount > 1.0)
	{
		// one is clearly the trip
		tothands += combination(13.0-numranks, 5.0-numranks)
		*1.0
		*combination(4.0-tripcount,3.0-tripcount)
		*(power(4.0, (int)singles) - 1)
		;
	}
	
	return tothands;
}

-(double)handsOfTwoPair
{
	return 0.0;
}

-(double)handsOfPair
{
	// IF we have any cards that are already paired on the board, we should probably ignore them
	// otherwise, for any card already in play, we accumulate the hands where they (and only they) are paired
	// for any card NOT in play, IF there are still 2 plays remaining, we accumulate possible pairings for those
	// remember that when multiplying by the non-paired results we have to only combine against cards not already in play
	
	// realistically we have no meaningful results to return if we already have a pair... the chanceOf.. method should
	// return 1.0 already
	// so how many cards are already in play? well, if the chanceOf.. method is responsible for checking for existing pairs
	// then no card can already be paired... that means we have the same number of unique cards already in play as cards played	
	double tothands = 0.0;
	double c = [self cardsTurned];
	
	if (c == 0.0)
	{
		tothands = combination(13.0-c, 6.0-c)*6.0*combination(4.0, 2.0)*power(4.0, 5);
	}
	else
	{
		tothands = combination(13.0-c, 6.0-c)*6.0*combination(4.0, 2.0)*power(4.0, [self cardsUnturned]-2)
		+ combination(13.0-c, 6.0-c)*6.0*combination(3.0, 1.0)*power(4.0, [self cardsUnturned]-1);
	}
	
	return tothands;
}


@end

// n!
double factorial(double n)
{
	double x = n>0?n:0;
	return tgamma(x+1.0);
}

//    n!
// ----------
//  r!(n-r)!
double combination(double n, double r)
{
	double x = r>0?r:0;
	return factorial(n) / (factorial(x)*factorial(n-x));
}

//    n!
// --------
//  (n-r)!
double permutation(double n, double r)
{
	double x = r>0?r:0;
	return factorial(n) / factorial(n-x);
}

// n^p
double power(double n, int p)
{
	double r = 1.0;
	for (int i = 0; i < p; ++i)
	{
		r *= n;
	}
	return r;
}


