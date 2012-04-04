//
//  MyCentralView.m
//  Calculateur-de-Pot
//
//  Created by mishanet on 04/04/12.
//  Copyright 2012 UNSA. All rights reserved.
//

#import "MyCentralView.h"

@implementation MyCentralView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundcartes.jpg"]];
    [self addSubview:background];
    NSLog(NSStringFromCGRect(self.bounds));
    [background release];
    
}


@end
