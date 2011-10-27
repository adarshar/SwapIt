//
//  SplashViewController.m
//  SwapIt
//
//  Created by Student on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"
#import "MenuViewController.h"


@implementation SplashViewController

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSSet *allTouches = [event allTouches];
    //UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    [self.navigationController popViewControllerAnimated:NO];
    MenuViewController *mvc = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:NO];
	[mvc release];
}

@end
