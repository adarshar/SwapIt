//
//  InGameView.m
//  SwapIt
//
//  Created by Student on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InGameView.h"



@implementation InGameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setupGame];
        gs = GS_LOADING;
        [self startThread];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (painting) return;
    painting = YES;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 255, 0, 1);
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
    CGContextFillRect(context, self.bounds);
    
    switch(gs) {
        case GS_LOADING: {
            //UILabel *loading;
            //[loading setText:@"LOADING"];
        }
        break;    
        case GS_SHOW_ORIG: {
            [imgOriginal drawAtPoint:CGPointMake(0, 0)];
        }
        break;
        case GS_PLAY: {
            
            for(int i=0; i<[imgTiles count]; ++i) {
                UIImage *image = [imgTiles objectAtIndex:[[scrambledTiles objectAtIndex:i] intValue]];
                [image drawAtPoint:CGPointMake((iTileWidth * (i%iDifficultyLvl)), (iTileHeight * (i/iDifficultyLvl)))];
            }
            
            for(int i=0; i<(iDifficultyLvl); ++i) {
                for (int j = 0; j < (iDifficultyLvl); ++j) {
                    CGContextStrokeRect(context, CGRectMake(j*iTileWidth, i*iTileHeight, iTileWidth, iTileHeight));
                }
            }
            
            if(isSelected) {
                CGContextSetRGBStrokeColor(context, 255, 255, 0, 1);
                if((GC%6) >= 2)
                    CGContextStrokeRect(context, CGRectMake(iSelectedX, iSelectedY, iTileWidth, iTileHeight));
            }
            
            for(int i=0; i<[imgTiles count]; ++i) {
                 if(i==[[scrambledTiles objectAtIndex:i] intValue]) {
                    [imgTransTile drawAtPoint:CGPointMake(iTileWidth * (i%iDifficultyLvl), iTileHeight * (i/iDifficultyLvl))];
                }
            }
            
        }
        break;
    }
    
    painting = NO;
}


-(void) updateScreen {
    [self updatePointerEvent];
    
    GC++;
    if(GC>=1000) {
        GC = 0;
    }
    
    switch(gs) {
        case GS_LOADING: {
            [self setupGame];
            gs = GS_PLAY;
        }
        break;    
        case GS_SHOW_ORIG: {
    
            
        }
        break;
        case GS_PLAY: {
            [self checkSolved];
            
            if(isSelected) {
                if([self checkPointerPressX:0 y:0 w:WIDTH h:HEIGHT]) {
                    
                    int iTempSwapX = iTileWidth * ((int)pointerPress.x/iTileWidth);
                    int iTempSwapY = iTileHeight * ((int)pointerPress.y/iTileHeight);
                    int iTempTileNo = [self getSwapTileNoX:iTempSwapX andY:iTempSwapY];
                    
                    if(iTempTileNo != [[scrambledTiles objectAtIndex:iTempTileNo] intValue]) {
                        
                        iSwapX = iTempSwapX;
                        iSwapY = iTempSwapY;
                        
                        if((iSwapX != iSelectedX) || (iSwapY != iSelectedY)) {
                            [self swapTiles];
                        }
                        
                        isSelected = NO;
                    }
                }
            }
            else {
                if([self checkPointerPressX:0 y:0 w:WIDTH h:HEIGHT]) {
                                        
                    int iTempSelX = iTileWidth * ((int)pointerPress.x/iTileWidth);
                    int iTempSelY = iTileHeight * ((int)pointerPress.y/iTileHeight);
                    NSLog(@"temp x:%i  temp y:%i",iTempSelX,iTempSelY);
                    int iTempTileNo = [self getSelTileNoX:iTempSelX andY:iTempSelY];
                    NSLog(@"Tile No %i",iTempTileNo);
                    
                    if(iTempTileNo!=[[scrambledTiles objectAtIndex:iTempTileNo] intValue]) {
                        
                        iSelectedX = iTempSelX;
                        iSelectedY = iTempSelY;
                        isSelected = YES;
                    }
                }
            }
        }
        break;
    }
}

- (void)dealloc
{
    [imgOriginal release];
    [imgTiles release];
    [imgTransTile release];
    [scrambledTiles release];
    [super dealloc];
}

- (void) startThread {
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread start];
}


- (void) run {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    while(thread == [NSThread currentThread]) {
        @try {
            long time1 = [[NSDate date] timeIntervalSince1970];
            [self updateScreen];
            [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:self waitUntilDone:YES];
            long time2 = [[NSDate date] timeIntervalSince1970];
            
            long td = 0.06 - (time2 - time1);
            if (td < 0) td = 0;
            
            //[NSThread sleepForTimeInterval:td];
            [NSThread sleepForTimeInterval:0.1];
        } @catch(NSException *e) {
            NSLog(@"error in thread");
        }
    }
    
    [pool release];
} 


-(void)loadImage {
    UIImage *imgTemp = [UIImage imageNamed:@"test.jpg"];
    
    CGSize size = CGSizeMake(300, 456);
    UIGraphicsBeginImageContext(size);
    [imgTemp drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    imgOriginal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)createTransTile {
    
    unsigned char *argb = (unsigned char *)malloc(sizeof(unsigned char) * iTileWidth * iTileHeight * 4);
    
    for(int i=0 ; i<(iTileWidth*iTileHeight) ; ++i) {
        argb[i*4 + 0] = 115; 
        if(i%2 == 0) {
            argb[i*4 + 1] = 0; 
            argb[i*4 + 2] = 0; 
            argb[i*4 + 3] = 0; 
        }
        else {
            argb[i*4 + 1] = 255; 
            argb[i*4 + 2] = 255; 
            argb[i*4 + 3] = 255; 
        }
    }
       
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext=CGBitmapContextCreate(argb, iTileWidth, iTileHeight, 8, 4*iTileWidth, colorSpace,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    free(argb);
    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    imgTransTile = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {  
    CGImageRef sourceImageRef = [image CGImage];  
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);  
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];  
    CGImageRelease(newImageRef);  
    return newImage;  
}  

-(void)setupGame {
    
    WIDTH = self.bounds.size.width;
    HEIGHT = self.bounds.size.height;
    
    iDifficultyLvl = 3*1; //1,2,4
    
    iTileWidth = /*WIDTH*/300/iDifficultyLvl;
    iTileHeight = /*HEIGHT*/456/iDifficultyLvl;
    NSLog(@"%i %i",iTileWidth,iTileHeight);
    
    [self loadImage];
    [self splitTiles];
    [self shuffle];
    [self createTransTile];
    
    iSelectedX = 0;
    iSelectedY = 0;
    iSwapX = 0;
    iSwapY = 0;

    isSolved = NO;
    isSelected = NO;
    painting = NO;
    
    currentPointerPress = CGPointMake(-1, -1);
    pointerPress = CGPointMake(-1, -1);
}

-(void) splitTiles {
    imgTiles = [[NSMutableArray alloc] initWithCapacity:(iDifficultyLvl*iDifficultyLvl)];                                                         
    
    for(int i=0; i<(iDifficultyLvl*iDifficultyLvl); ++i) {
        UIImage *image = [self imageFromImage:imgOriginal inRect:CGRectMake(iTileWidth * (i%iDifficultyLvl), iTileHeight * (i/iDifficultyLvl), iTileWidth, iTileHeight)];
        //NSLog(@"%@ %i %i",imgOriginal,iTileWidth * (i%iDifficultyLvl),iTileHeight * (i/iDifficultyLvl));
        [imgTiles addObject:image];
    }   
}

-(void) shuffle {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    scrambledTiles = [[NSMutableArray alloc]init];
    for (int i = 0; i < [imgTiles count]; i++) {
        [tempArray addObject:[NSNumber numberWithInt:i]];
    }
    
    //NSLog(@"tile count %i",[imgTiles count]);
    
    for(int i=0; i<[imgTiles count]; ++i) {
        int tempIndex = (arc4random()%[tempArray count]);
        [scrambledTiles addObject:[tempArray objectAtIndex:tempIndex]];
        [tempArray removeObjectAtIndex:tempIndex];      
    }
    
    //for(int i=0; i<[imgTiles count]; ++i) {
    //    NSLog(@"tile no %@",[scrambledTiles objectAtIndex:i]);
    //}
    
    [tempArray release];
}

-(void) swapTiles {
    id temp;
    int iSelTileNo = [self getSelTileNoX:iSelectedX andY:iSelectedY];
    int iSwapTileNo = [self getSwapTileNoX:iSwapX andY:iSwapY];
    
    temp = [scrambledTiles objectAtIndex:iSelTileNo];
    [scrambledTiles replaceObjectAtIndex:iSelTileNo withObject:[scrambledTiles objectAtIndex:iSwapTileNo]];
    [scrambledTiles replaceObjectAtIndex:iSwapTileNo withObject:temp];
}

-(int) getSelTileNoX:(int) x andY:(int) y {
    return ((iDifficultyLvl * (y/iTileHeight)) + (x/iTileWidth));
}

-(int) getSwapTileNoX:(int) x andY:(int) y {
    return ((iDifficultyLvl * (y/iTileHeight)) + (x/iTileWidth));
}

-(void) checkSolved {
    isSolved = YES;
    for(int i=0; i<[imgTiles count]; ++i) {
        if(i!=[[scrambledTiles objectAtIndex:i] intValue]) {
            isSolved = NO;
            break;
        }
    }
}

-(BOOL) collidedX1:(float)x1
                y1:(float)y1 
                w1:(float)w1 
                h1:(float)h1 
                x2:(float)x2 
                y2:(float)y2 
                w2:(float)w2 
                h2:(float)h2 {
    
    BOOL chk = NO;
    if (((x1 + w1) >= x2) && (x1 <= (x2 + w2)) && ((y1 + h1) >= y2) && (y1 <= (y2 + h2))) {
        chk = YES;
    }
    return chk;
}

-(void)updatePointerEvent {
    pointerPress = currentPointerPress;
    currentPointerPress = CGPointMake(-1, -1);
}

-(BOOL) checkPointerPressX:(float)x y:(float)y w:(float)w h:(float)h {
    if([self collidedX1:pointerPress.x y1:pointerPress.y w1:0 h1:0 x2:x y2:y w2:w h2:h]) {
        return YES;
    } else {
        return NO;
    }
}

-(IBAction)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    currentPointerPress = [touch locationInView:self];
    
    NSLog(@"%f %f",currentPointerPress.x,currentPointerPress.y);
}

@end
