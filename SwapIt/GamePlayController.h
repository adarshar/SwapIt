//
//  GamePlayController.h
//  SwapIt
//
//  Created by Student on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InGameView.h"


@interface GamePlayController : UIViewController {
    InGameView *gameView;
    int mytime;
}

@property(nonatomic) int mytime;

@end
