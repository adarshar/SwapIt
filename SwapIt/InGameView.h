//
//  InGameView.h
//  SwapIt
//
//  Created by Student on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GS_LOADING, 
    GS_SHOW_ORIG,
    GS_PLAY
} GAME_SCREEN;

@interface InGameView : UIView {
    NSThread* thread;
    UIImage *imgOriginal;
    UIImage *imgTransTile;
    NSMutableArray *imgTiles;
    NSMutableArray *scrambledTiles;
    
    int GC;
    
    int WIDTH;
    int HEIGHT;
    
    int iTileWidth;
    int iTileHeight;
    int iDifficultyLvl;
    
    int iSelectedX;
    int iSelectedY;
    
    int iSwapX;
    int iSwapY;

    
    BOOL isShowOriginal;
    BOOL isSolved;
    BOOL isSelected;
    BOOL painting;
    
    GAME_SCREEN gs;
    
    CGPoint pointerPress; 
    CGPoint currentPointerPress;
    
    }

-(void)loadImage;
-(void)setupGame;
-(void)splitTiles;
-(void)shuffle;
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
-(void) createTransTile;
- (void) startThread;
-(void) swapTiles;
-(int) getSelTileNoX:(int) x andY:(int) y;
-(int) getSwapTileNoX:(int) x andY:(int) y;
-(void) checkSolved;
-(void) updateScreen;
-(void)updatePointerEvent;
-(BOOL) collidedX1:(float)x1 y1:(float)y1 w1:(float)w1 h1:(float)h1 x2:(float)x2 y2:(float)y2 w2:(float)w2 h2:(float)h2;
-(BOOL) checkPointerPressX:(float)x y:(float)y w:(float)w h:(float)h;

@end
