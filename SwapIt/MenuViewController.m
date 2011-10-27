//
//  MenuViewController.m
//  SwapIt
//
//  Created by Student on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingsViewController.h"
#import "InstructionsViewController.h"
#import "HighScoresViewController.h"
#import "AboutViewController.h"
#import "NewGameController.h"
#import "GamePlayController.h"


@implementation MenuViewController

@synthesize btnAbout, btnHighScores, btnInstructions, btnNewGame, btnSettings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.btnAbout = nil;
    self.btnHighScores = nil;
    self.btnInstructions = nil;
    self.btnNewGame = nil;
    self.btnSettings = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)buttonPressed:(id)sender {
    if(sender == btnAbout) {
        AboutViewController *avc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:avc animated:NO];
        [avc release];
    }
    else
    if(sender == btnHighScores) {
        HighScoresViewController *hvc = [[HighScoresViewController alloc] init];
        [self.navigationController pushViewController:hvc animated:NO];
        [hvc release];
    }
    else
    if(sender == btnInstructions) {
        InstructionsViewController *ivc = [[InstructionsViewController alloc] init];
        [self.navigationController pushViewController:ivc animated:NO];
        [ivc release];
    }
    else
    if(sender == btnNewGame) {
        //NewGameController *nvc = [[NewGameController alloc] init];
        GamePlayController *nvc = [[GamePlayController alloc] init];
        [self.navigationController pushViewController:nvc animated:NO];
        [nvc release];
    }
    else
    if(sender == btnSettings) {
        SettingsViewController *svc = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:svc animated:NO];
        [svc release];
    }
}

@end
