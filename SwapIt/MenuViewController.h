//
//  MenuViewController.h
//  SwapIt
//
//  Created by Student on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UIButton *btnNewGame;
@property (nonatomic, retain) IBOutlet UIButton *btnSettings;
@property (nonatomic, retain) IBOutlet UIButton *btnInstructions;
@property (nonatomic, retain) IBOutlet UIButton *btnHighScores;
@property (nonatomic, retain) IBOutlet UIButton *btnAbout;

-(IBAction)buttonPressed:(id)sender;

@end
