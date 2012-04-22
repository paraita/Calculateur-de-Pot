//
//  Pot-CalculatorSecondPageViewController.m
//  Calculateur-de-Pot
//
//  Created by Paraita Wohler on 03/04/12.
//  Copyright (c) 2012 UNSA. All rights reserved.
//

#import "Pot_CalculatorSecondPageViewController.h"
#import "Pot_CalculatorViewController.h"
#import "IIViewDeckController.h"

@interface Pot_CalculatorSecondPageViewController ()

@end

@implementation Pot_CalculatorSecondPageViewController
@synthesize brain;
@synthesize tv;

- (id)initWithBrain:(Pot_Calculator_Brain *)aBrain
{
    self = [super init];
    if (self) {
        self.brain = aBrain;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tv.dataSource = self;
    tv.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Menu";
            break;
        case 1:
            cell.textLabel.text = @"Tapis";
            break;
        case 2:
            cell.textLabel.text = @"Calcul du Pot";
            break;
        case 3:
            cell.textLabel.text = @"Recommencer la partie";
            break;
        case 4:
            cell.textLabel.text = @"A propos";
        default:
            break;
    }
    return [cell autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - Delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nil;
    }
    else return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
            [self.viewDeckController showCenterView];
            break;
        case 2:
            [self.viewDeckController toggleRightViewAnimated:YES];
            break;
        case 3:
            [(Pot_CalculatorViewController *)[self.viewDeckController centerController] resetTapis];
            [self.viewDeckController showCenterView];
            break;
        case 4:
            NSLog(@"//TODO: la vue modale qui donne des infos");
            break;
        default:
            break;
    }
}


@end
