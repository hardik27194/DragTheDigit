//
//  NLProgress.m
//  NLProject
//
//  Created by Nikita Popov on 01.08.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "NLProgress.h"
#import <QuartzCore/QuartzCore.h>
#define kLevelSize 40
#define kSublevelSize 20

@implementation NLProgress

@synthesize levelViews, sublevelViews, currentLevel, currentSublevel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    NSMutableArray* levels = [[NSMutableArray alloc] init];
    NSNumber* tempNumber = [NSNumber numberWithInt:5];
    for (int i=0; i<5; ++i) {
        [levels addObject:tempNumber];
    }
    [param setObject:levels forKey:@"levels"];
    [param setObject:[NSNumber numberWithInt:1] forKey:@"currentLevel"];
    self= [self initWithParam:param];
    if (self) {
                
    }
    return self;
}


-(id)initWithParam:(NSDictionary *)param
{
    self = [super init];
    if (self) {
      self.delegate = self;
			self.showsHorizontalScrollIndicator = NO;
        NSArray* array = [param objectForKey:@"levels"];
        currentLevel = [[param objectForKey:@"currentLevel"] intValue];
        currentSublevel = 0;
        [self setBackgroundColor:[UIColor clearColor]];
        levelViews = [[NSMutableArray alloc] init];
        sublevelViews = [[NSMutableArray alloc] init];
        
        
        for (int i=0; i<[array count]; ++i) {
            UIImageView* square = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLevelSize, kLevelSize)];
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLevelSize, kLevelSize)];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setText:[NSString stringWithFormat:@"%d",i+1]];
						[label setBackgroundColor:[UIColor clearColor]];
            [label setTag:1];
            [square addSubview:label];
            [levelViews addObject:square];
        }
        for (int i=0; i<[array count]; ++i) {
            [sublevelViews addObject:[[NSMutableArray alloc] init]];
            for(int j=0; j<[[array objectAtIndex:i] intValue]; ++j) {
                UIImageView* square = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSublevelSize, kSublevelSize)];
                /*UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSublevelSize, kSublevelSize)];
                [label setTextAlignment:UITextAlignmentCenter];
                //[label setText:[NSString stringWithFormat:@"%d",j+1]];
                [label setTag:1];
                [square addSubview:label];*/
                [[sublevelViews objectAtIndex:i] addObject:square];
            }
        }
        int offset = -kLevelSize-10+10;
        for (int i=0; i<=currentLevel; ++i) {
            offset += kLevelSize+10;
            [[levelViews objectAtIndex:i] setFrame:CGRectMake(offset, 10, kLevelSize, kLevelSize)];
            [[levelViews objectAtIndex:i] setImage:[UIImage imageNamed:@"GreenRoundBig"]];
            [self addSubview:[levelViews objectAtIndex:i]];
        }
        offset += +kLevelSize + 10 -kSublevelSize-10;
        for (int i=0; i<[[array objectAtIndex:currentLevel] intValue]; ++i) {
            offset += kSublevelSize + 10;
            [[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:i] setFrame:CGRectMake(offset, 20, kSublevelSize, kSublevelSize)];
            [[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:i] setImage:[UIImage imageNamed:@"MetalRound"]];
            [self addSubview:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:i]];
        }
        offset += kSublevelSize - kLevelSize - 10 + 10;
        for (int i=currentLevel+1; i<[array count]; ++i) {
            offset += kLevelSize + 10;
            [[levelViews objectAtIndex:i] setFrame:CGRectMake(offset, 10, kLevelSize, kLevelSize)];
          [[levelViews objectAtIndex:i] setImage:[UIImage imageNamed:@"MetalRoundBig"]];
            [self addSubview:[levelViews objectAtIndex:i]];
        }
        [self setFrame:CGRectMake(87, 8, 586, kLevelSize + 10*2)];
        [self setContentSize:CGSizeMake(offset+kLevelSize+10, kLevelSize +10*2)];
        //[[[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel] viewWithTag:1] setBackgroundColor:[UIColor orangeColor]];
        //[[[levelViews objectAtIndex:currentLevel] viewWithTag:1] setBackgroundColor:[UIColor orangeColor]];
        [self makeChoosenOne:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel] withTime:0 isBig:NO];
        [self makeChoosenOne:[levelViews objectAtIndex:currentLevel] withTime:0 isBig:YES];
      [self scrollViewDidEndDecelerating:nil];
    }
    return self;
}

-(void)nextSublevelWithAnswer:(BOOL)answer
{
    /*if (currentSublevel == [[sublevelViews objectAtIndex:currentLevel] count]-1) {
        [self nextLevelWithAnswer:answer];
				[self scrollViewDidEndDecelerating:nil];
        return;
    }*/
  if (answer) {
      [self makeTrue:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel] withTime:0.5 isBig:NO];
  }
  else {
      [self makeFalse:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel] withTime:0.5 isBig:NO];
  }
  if (currentSublevel == [[sublevelViews objectAtIndex:currentLevel] count]-1) {
    //[self nextLevelWithAnswer:answer];
    //[self scrollViewDidEndDecelerating:nil];
    return;
  }
  else {
    [self makeChoosenOne:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel+1] withTime:0.5 isBig:NO];
    [self scrollViewDidEndDecelerating:nil];
    ++currentSublevel;
  }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if (scrollView) {
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:nil afterDelay:3];
    return;
  }
  if(self.contentSize.width>self.frame.size.width) {
    if([[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel] center].x +kSublevelSize +10> self.frame.size.width/2) {
      [self setContentOffset:CGPointMake([[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel] center].x - self.frame.size.width/2 + kSublevelSize +10, 0) animated:YES];
    }
    else {
      [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
  }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  if (CGPointEqualToPoint(velocity, CGPointZero)) {
    [self scrollViewDidEndDecelerating:self];
  }
}

-(void)nextLevelWithAnswer:(BOOL)answer
{
    if (currentLevel ==[levelViews count]-1 && answer) {
        [self makeTrue:[levelViews objectAtIndex:currentLevel] withTime:0.5 isBig:YES];
        [self makeTrue:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:currentSublevel] withTime:0.5 isBig:NO];
        return;
    }
    else if (answer) {
        [self makeTrue:[levelViews objectAtIndex:currentLevel] withTime:0.5 isBig:YES];
    }
    else {
        [self restart];
        return;
    }
    for (int i=0; i<[[sublevelViews objectAtIndex:currentLevel+1] count]; ++i) {
        [[[sublevelViews objectAtIndex:currentLevel+1] objectAtIndex:i] setFrame:CGRectMake(10+(currentLevel+2)*(kLevelSize+10) + i*(kSublevelSize+10), 20, kSublevelSize, kSublevelSize)];
        int div = [[sublevelViews objectAtIndex:currentLevel+1] count];
        [self hideView:[[sublevelViews objectAtIndex:currentLevel+1] objectAtIndex:i] withTime:0];
        [self showView:[[sublevelViews objectAtIndex:currentLevel+1] objectAtIndex:i] withTime:0.8*(div-i)/div];
        if(i!=0) [self makeUnchosed:[[sublevelViews objectAtIndex:currentLevel+1] objectAtIndex:i] withTime:0.8*(div-i)/div isBig:NO];
        else [self makeChoosenOne:[[sublevelViews objectAtIndex:currentLevel+1] objectAtIndex:i] withTime:0.8*(div-i)/div isBig:NO];
    }
    [self hideView:[levelViews objectAtIndex:currentLevel+1] withTime:0];
    [self showView:[levelViews objectAtIndex:currentLevel+1] withTime:0];
    [self makeChoosenOne:[levelViews objectAtIndex:currentLevel+1] withTime:0.5 isBig:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [[levelViews objectAtIndex:currentLevel+1] setFrame:CGRectMake(10+(currentLevel+1)*(kLevelSize+10), 10, kLevelSize, kLevelSize)];
        [self setContentSize:CGSizeMake(10 + [levelViews count]*(kLevelSize+10) + [[sublevelViews objectAtIndex:currentLevel+1] count]*(kSublevelSize+10)-10, 50)];
    }];
    for (int i=0; i<[[sublevelViews objectAtIndex:currentLevel] count]; ++i) {
        int div = [[sublevelViews objectAtIndex:currentLevel] count];
        [self hideView:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:i] withTime:0.5*(div-i)/div];
    }
   
    for (int i=currentLevel+2; i<[levelViews count]; ++i)  {
        [UIView animateWithDuration:0.5 animations:^{
            [[levelViews objectAtIndex:i] setFrame:CGRectMake(10 + i*(kLevelSize+10) + [[sublevelViews objectAtIndex:currentLevel+1] count]*(kSublevelSize+10), 10, kLevelSize, kLevelSize)];
        }];
    }
    currentLevel++;
    currentSublevel=0;
  [self scrollViewDidEndDecelerating:nil];
}

-(void) restart
{
    for (int i=0; i<[[sublevelViews objectAtIndex:currentLevel] count]; ++i) {
        if (i!=0) {
            [self makeUnchosed:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:i] withTime:0.5 isBig:NO];
        }
        else [self makeChoosenOne:[[sublevelViews objectAtIndex:currentLevel] objectAtIndex:i] withTime:0.5 isBig:NO];

    }
	currentSublevel = 0;
	[self scrollViewDidEndDecelerating:nil];
}
//депрекатед
/*
-(void)makeTrue:(UIView*)object withTime:(NSTimeInterval)time
{
    UIView* object2 = [object viewWithTag:1];
    if (time==0) {
        object2.backgroundColor = [UIColor greenColor];
        return;
    }
    UIColor* color = object2.backgroundColor;
    object2.backgroundColor = [UIColor clearColor];
    object2.layer.backgroundColor = [color CGColor];
    [UIView animateWithDuration:time animations:^{
        object2.layer.backgroundColor = [[UIColor greenColor] CGColor];
    } completion:^(BOOL finished){
        object2.layer.backgroundColor = [[UIColor clearColor] CGColor];
        object2.backgroundColor = [UIColor greenColor];
    }];
  //[self setColorFromImage:[UIImage imageNamed:@"GreenRoundBig"] toBig:YES view:object withTime:0.6];
}

-(void)makeUnchosed:(UIView*)object withTime:(NSTimeInterval)time
{
    UIView* object2 = [object viewWithTag:1];
    if (time==0) {
        object2.backgroundColor = [UIColor grayColor];
        return;
    }
    UIColor* color = object2.backgroundColor;
    object2.backgroundColor = [UIColor clearColor];
    object2.layer.backgroundColor = [color CGColor];
    [UIView animateWithDuration:time animations:^{
        object2.layer.backgroundColor = [[UIColor grayColor] CGColor];
    } completion:^(BOOL finished){
        object2.layer.backgroundColor = [[UIColor clearColor] CGColor];
        object2.backgroundColor = [UIColor grayColor];
    }];
  //[self setColorFromImage:[UIImage imageNamed:@"MetalRoundBig"] toBig:YES view:object withTime:0.6];
}

-(void)makeFalse:(UIView*)object withTime:(NSTimeInterval)time
{
    UIView* object2 = [object viewWithTag:1];
    if (time==0) {
        object2.backgroundColor = [UIColor redColor];
        return;
    }
    UIColor* color = object2.backgroundColor;
    object2.backgroundColor = [UIColor clearColor];
    object2.layer.backgroundColor = [color CGColor];
    [UIView animateWithDuration:time animations:^{
        object2.layer.backgroundColor = [[UIColor redColor] CGColor];
    } completion:^(BOOL finished){
        object2.layer.backgroundColor = [[UIColor clearColor] CGColor];
        object2.backgroundColor = [UIColor redColor];
    }];
}

-(void)makeChoosenOne:(UIView*)object withTime:(NSTimeInterval)time
{
    UIView* object2 = [object viewWithTag:1];
    if (time==0) {
        object2.backgroundColor = [UIColor yellowColor];
        return;
    }
    UIColor* color = object2.backgroundColor;
    object2.backgroundColor = [UIColor clearColor];
    object2.layer.backgroundColor = [color CGColor];
    [UIView animateWithDuration:time animations:^{
        object2.layer.backgroundColor = [[UIColor yellowColor] CGColor];
    } completion:^(BOOL finished){
        object2.layer.backgroundColor = [[UIColor clearColor] CGColor];
        object2.backgroundColor = [UIColor yellowColor];
    }];
}*/

-(void)setColorFromImage:(UIImage*)image toView:(UIImageView*)view withTime:(NSTimeInterval)time
{
  if (time==0) {
    [view setImage:image];
    return;
  }
  UIImageView* cover1 = [[UIImageView alloc] initWithImage:image];
  //cover1 = [view copy];
  //[cover1 setImage:image];
  //UIImageView* cover2 = [[UIImageView alloc] initWithImage:[view image]];
  if ([levelViews containsObject:view]) {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [label setText:[(UILabel*)[view viewWithTag:1] text]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [cover1 addSubview:label];
  }
  [cover1 setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
  [cover1 setAlpha:0];
  //[cover2 setFrame:[cover1 frame]];
  [view addSubview:cover1];
  //[view addSubview:cover2];
  [UIView animateWithDuration:time animations:^{
    //[cover2 setAlpha:0];
    [cover1 setAlpha:1];
  } completion:^(BOOL finished){
    [cover1 removeFromSuperview];
    //[cover2 removeFromSuperview];
    [view setImage:image];
  }];

}
-(void)makeTrue:(UIImageView*)object withTime:(NSTimeInterval)time isBig:(BOOL)big
{
  UIImage* image;
  if (big) image = [UIImage imageNamed:@"GreenRoundBig"];
  else image = [UIImage imageNamed:@"GreenRound"];
  [self setColorFromImage:image toView:object withTime:time];
}

-(void)makeUnchosed:(UIImageView*)object withTime:(NSTimeInterval)time isBig:(BOOL)big
{
  UIImage* image;
  if (big) image = [UIImage imageNamed:@"MetalRoundBig"];
  else image = [UIImage imageNamed:@"MetalRound"];
  [self setColorFromImage:image toView:object withTime:time];
}

-(void)makeFalse:(UIImageView*)object withTime:(NSTimeInterval)time isBig:(BOOL)big
{
  UIImage* image;
  if (big) image = [UIImage imageNamed:@"RedRoundBig"];
  else image = [UIImage imageNamed:@"RedRound"];
  [self setColorFromImage:image toView:object withTime:time];
}

-(void)makeChoosenOne:(UIImageView*)object withTime:(NSTimeInterval)time isBig:(BOOL)big
{
  UIImage* image;
  if (big) image = [UIImage imageNamed:@"YellowRoundBig"];
  else image = [UIImage imageNamed:@"YellowRound"];
  [self setColorFromImage:image toView:object withTime:time];
}

-(void)hideView:(UIView*)object withTime:(NSTimeInterval)time
{
    if (time==0) {
        [object setAlpha:0];
        [object removeFromSuperview];
    }
    else [UIView animateWithDuration:time animations:^{
        [object setAlpha:0];
    } completion:^(BOOL finished){
        [object removeFromSuperview];
    }];
}

-(void)showView:(UIView*)object withTime:(NSTimeInterval)time
{
    if (time==0) {
        [self addSubview:object];
        [object setAlpha:1];
    }
    else {
        [object setAlpha:0];
        [self addSubview:object];
        [UIView animateWithDuration:time animations:^{
            [object setAlpha:1];
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
 
}
*/

@end
