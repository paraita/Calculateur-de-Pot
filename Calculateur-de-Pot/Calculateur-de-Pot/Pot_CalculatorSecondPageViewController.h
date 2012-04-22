//
//  Pot-CalculatorSecondPageViewController.h
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 03/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pot_Calculator_Brain.h"

@interface Pot_CalculatorSecondPageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) Pot_Calculator_Brain *brain;
@property (nonatomic, assign) IBOutlet UITableView *tv;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
