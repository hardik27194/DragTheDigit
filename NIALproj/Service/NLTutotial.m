//
//  NLTutotial.m
//  NIALproj
//
//  Created by Nikita Popov on 11.08.12.
//  Copyright (c) 2012 Alexey Goncharov. All rights reserved.
//
#define kScrollWidth 800
#define kScrollHeight 600
#define kFingerWidth 84
#define kFingerHeight 120


#import "NLTutotial.h"
#import "NLElementView.h"
#import "NLProgress.h"
#import <QuartzCore/QuartzCore.h>

@implementation NLTutotial

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
  self = [super initWithFrame:CGRectMake(200, 50, kScrollWidth, kScrollHeight)];
  if (self) {
    [self setAlpha:0];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScrollWidth, kScrollHeight)];
    [scrollView setPagingEnabled:YES];
    [scrollView setContentSize:CGSizeMake(kScrollWidth*4, kScrollHeight)];
    [scrollView setDelegate:self];
    [self addSubview:scrollView];
    pageControl = [[UIPageControl alloc] init];
    [pageControl setNumberOfPages:4];
    [pageControl setFrame:CGRectMake(0, 0, kScrollWidth, 50)];
    [pageControl setUserInteractionEnabled:NO];
    [self addSubview:pageControl];
    fingers = [[NSMutableArray alloc] init];
    pages = [[NSMutableArray alloc] init];
    for (int i=0;i<4;++i) {
      UIImageView* finger = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Finger"]];
      [finger setFrame:CGRectMake(100, 100, /*finger.frame.size.width/5*/kFingerWidth, /*finger.frame.size.height/5*/kFingerHeight)];
      [finger setCenter:CGPointMake(240, 150)];
      [fingers addObject:finger];
      UIView* temp = [[UIView alloc] initWithFrame:CGRectMake(kScrollWidth*i, 0, kScrollWidth, kScrollHeight)];
      [pages addObject:temp];
    }
    
    [self initFirstPage];
    [self initSecondPage];
    [self initThirdPage];
    [self initFourthPage];
    for (UIView* temp in pages) [scrollView addSubview:temp];
  }
  [UIView animateWithDuration:0.5 animations:^{
    [self setAlpha:1];
  } completion:^(BOOL finished){
    [self performSelector:@selector(showAction) withObject:nil afterDelay:2];
  }];
  return self;
}

-(void)showAction
{
  switch ([pageControl currentPage]) {
    case 0:{
      [self reloadFirstPage];
      [self performSelector:@selector(actionOnFirstPage) withObject:nil afterDelay:0.9];//actionOnFirstPage];
      break;
    }
    case 1: {
      [self reloadSecondPage];
      [self performSelector:@selector(actionOnSecondPage) withObject:nil afterDelay:0.9];
      break;
    }
    case 2: {
      [self reloadThirdPage];
      [self performSelector:@selector(actionOnThirdPage) withObject:nil afterDelay:0.9];
      break;
    }
    case 3: {
      [self reloadFourthPage];
      [self performSelector:@selector(actionOnFourthPage)];
      break;
    }
      
    default:
      break;
  }
}
-(void)cancelAction
{
  //[NSObject cancelPreviousPerformRequestsWithTarget:scrollView selector:@selector(actionOnFirstPage) object:nil];//canPerformAction:@selector(showAction) withSender:self];
  [self reloadFirstPage];
  [self reloadSecondPage];
  //[[fingers objectAtIndex:0] setCenter:CGPointMake(kScrollWidth*[pageControl currentPage] + 250, 150)];
  
}

-(void)initFirstPage
{
  [[pages objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
  firstPageObjects = [[NSMutableArray alloc] init];
  NLElementView* number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"2" andOrigin:CGPointMake(100, 200)];
  [firstPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"+" andOrigin:CGPointMake(225, 225)];
  [firstPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"" andOrigin:CGPointMake(300, 200) andEditable:YES];
  [firstPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"=" andOrigin:CGPointMake(425, 225)];
  [firstPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"4" andOrigin:CGPointMake(500, 200)];
  [firstPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"2" andOrigin:CGPointMake(200, 450) andEditable:YES];
  [firstPageObjects addObject:number];
  for(NLElementView* temp in firstPageObjects)
  {
    [[pages objectAtIndex:0] addSubview:temp];
  }
  [[pages objectAtIndex:0] addSubview:[fingers objectAtIndex:0]];
  UITextView* label = [[UITextView alloc] initWithFrame:CGRectMake(400, 50, 400, 120)];
  [label setTextAlignment:UITextAlignmentCenter];
  [label setFont:[UIFont fontWithName:kAppTutorialFontName size:20]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setUserInteractionEnabled:NO];
  [label setText:NSLocalizedString(@"TUTORIAL_TITLE_1", @"drag")];
  //[label sizeToFit];
  [[pages objectAtIndex:0] addSubview:label];

}

-(void)actionOnFirstPage
{
  UIImageView* finger = [fingers objectAtIndex:0];
  [UIView animateWithDuration:0.9
                        delay:0
                      options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
    [finger setCenter:CGPointMake(240, 450)]; //сдвиг пальца на перетягиваемую кнопку
  } completion:^(BOOL finished){
    if (finished)[UIView animateWithDuration:0.5
                                       delay:0.5
                                     options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                  animations:^{
      [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width/1.2, finger.frame.size.height/1.2)]; //уменьшение(выделение)
    }completion:^(BOOL finished){
      if (finished) [UIView animateWithDuration:0.9
                                          delay:0.5
                                        options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                     animations:^{
        NLElementView* temp = [firstPageObjects objectAtIndex:5];
        [temp setCenter:CGPointMake(350, 250)]; //перенос цифры пальцем на нужное место
        [finger setCenter:CGPointMake(332, 200)];
      }completion:^(BOOL finished){
        if (finished) [UIView animateWithDuration:0.5
                                            delay:0.2
                                          options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                       animations:^{
          [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width*1.2, finger.frame.size.height*1.2)]; //увеличение пальца
          [[firstPageObjects objectAtIndex:2] setTextTo:@"2" animation:NO];
          [[firstPageObjects objectAtIndex:5] setCenter:CGPointMake(250, 500)];
        }completion:^(BOOL finished){
          if (finished) [UIView animateWithDuration:0.5
                                              delay:0
                                            options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                         animations:^{
            [finger setCenter:CGPointMake(250, 150)]; //сдвиг куда-нибудь
          } completion:^(BOOL finished){
            //[self performSelector:@selector(reloadPage) withObject:nil afterDelay:2]; //сброс на исходное положение
            if (finished) [self performSelector:@selector(showAction) withObject:nil afterDelay:3]; //рекурсивный вызов
          }];
        }];
      }];
    }];
  }];
}

-(void)reloadFirstPage
{
  [[firstPageObjects objectAtIndex:2] setTextTo:@"" animation:YES];
  [[firstPageObjects objectAtIndex:0] setCenter:CGPointMake(150, 250)];
    [[firstPageObjects objectAtIndex:1] setCenter:CGPointMake(250, 250)];
    [[firstPageObjects objectAtIndex:2] setCenter:CGPointMake(350, 250)];
    [[firstPageObjects objectAtIndex:3] setCenter:CGPointMake(450, 250)];
    [[firstPageObjects objectAtIndex:4] setCenter:CGPointMake(550, 250)];
    [[firstPageObjects objectAtIndex:5] setCenter:CGPointMake(250, 500)];
}

-(void)initSecondPage
{
  [[pages objectAtIndex:1] setBackgroundColor:[UIColor clearColor]];
  secondPageObjects = [[NSMutableArray alloc] init];
  NLElementView* number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"38" andOrigin:CGPointMake(100, 200)];
  [secondPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"+" andOrigin:CGPointMake(225, 225)];
  [secondPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"" andOrigin:CGPointMake(300, 200) andEditable:YES];
  [secondPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"=" andOrigin:CGPointMake(425, 225)];
  [secondPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"83" andOrigin:CGPointMake(500, 200)];
  [secondPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"4" andOrigin:CGPointMake(200, 450) andEditable:YES];
  [secondPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"5" andOrigin:CGPointMake(310, 450) andEditable:YES];
  [secondPageObjects addObject:number];
  for(NLElementView* temp in secondPageObjects)
  {
    [[pages objectAtIndex:1] addSubview:temp];
  }
  [[pages objectAtIndex:1] addSubview:[fingers objectAtIndex:1]];
  UITextView* label = [[UITextView alloc] initWithFrame:CGRectMake(400, 50, 400, 120)];
  [label setTextAlignment:UITextAlignmentCenter];
  [label setFont:[UIFont fontWithName:kAppTutorialFontName size:20]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setUserInteractionEnabled:NO];
  [label setText:NSLocalizedString(@"TUTORIAL_TITLE_2", @"2digit")];
  [[pages objectAtIndex:1] addSubview:label];
  
}

-(void)actionOnSecondPage
{
  UIImageView* finger = [fingers objectAtIndex:1];
  [UIView animateWithDuration:0.9
                        delay:0
                      options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
    [finger setCenter:CGPointMake(240, 450)]; //сдвиг пальца на перетягиваемую кнопку
  } completion:^(BOOL finished){
    if (finished) [UIView animateWithDuration:0.5
                                        delay:0.5
                                      options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                   animations:^{
      [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width/1.2, finger.frame.size.height/1.2)]; //уменьшение(выделение)
    }completion:^(BOOL finished){
      if (finished) [UIView animateWithDuration:0.9
                                          delay:0.5
                                        options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                     animations:^{
        NLElementView* temp = [secondPageObjects objectAtIndex:5];
        [temp setCenter:CGPointMake(350, 250)]; //перенос цифры пальцем на нужное место
        [finger setCenter:CGPointMake(332, 200)];
      }completion:^(BOOL finished){
        if (finished) [UIView animateWithDuration:0.5
                                            delay:0.2
                                          options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                       animations:^{
          [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width*1.2, finger.frame.size.height*1.2)]; //увеличение пальца
          [[secondPageObjects objectAtIndex:2] setTextTo:@"4" animation:YES];
          [[secondPageObjects objectAtIndex:5] setCenter:CGPointMake(250, 500)];
        }completion:^(BOOL finished){
          if (finished) [UIView animateWithDuration:0.5
                                              delay:0.2
                                            options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                         animations:^{
            [finger setCenter:CGPointMake(350, 450)];
          }completion:^(BOOL finished){
            if (finished) [UIView animateWithDuration:0.5
                                                delay:0.5
                                              options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                           animations:^{
              [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width/1.2, finger.frame.size.height/1.2)]; //уменьшение(выделение)
            }completion:^(BOOL finished){
              if (finished) [UIView animateWithDuration:0.9
                                                  delay:0.5
                                                options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                             animations:^{
                NLElementView* temp = [secondPageObjects objectAtIndex:6];
                [temp setCenter:CGPointMake(350, 250)]; //перенос цифры пальцем на нужное место
                [finger setCenter:CGPointMake(332, 200)];
              } completion:^(BOOL finished){
                if (finished) [UIView animateWithDuration:0.5
                                                    delay:0.2
                                                  options:UIViewAnimationCurveEaseInOut
                                               animations:^{
                  [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width*1.2, finger.frame.size.height*1.2)]; //увеличение пальца
                  [[secondPageObjects objectAtIndex:2] setTextTo:@"45" animation:YES];
                  [[secondPageObjects objectAtIndex:6] setCenter:CGPointMake(360, 500)];
                }completion:^(BOOL finished){
                  if (finished) [UIView animateWithDuration:0.5
                                                      delay:0
                                                    options:UIViewAnimationCurveEaseInOut
                                                 animations:^{
                    [finger setCenter:CGPointMake(250, 150)]; //сдвиг куда-нибудь
                  } completion:^(BOOL finished){
                    //[self performSelector:@selector(reloadPage) withObject:nil afterDelay:2]; //сброс на исходное положение
                    if (finished) [self performSelector:@selector(showAction) withObject:nil afterDelay:3]; //рекурсивный вызов
                  }];
                }];
              }];
            }];
          }];
        }];
      }];
    }];
  }];
}

-(void)reloadSecondPage
{
  [[secondPageObjects objectAtIndex:2] setTextTo:@"" animation:YES];
  [[secondPageObjects objectAtIndex:0] setCenter:CGPointMake(150, 250)];
  [[secondPageObjects objectAtIndex:1] setCenter:CGPointMake(250, 250)];
  [[secondPageObjects objectAtIndex:2] setCenter:CGPointMake(350, 250)];
  [[secondPageObjects objectAtIndex:3] setCenter:CGPointMake(450, 250)];
  [[secondPageObjects objectAtIndex:4] setCenter:CGPointMake(550, 250)];
  [[secondPageObjects objectAtIndex:5] setCenter:CGPointMake(250, 500)];
  [[secondPageObjects objectAtIndex:6] setCenter:CGPointMake(360, 500)];
}

-(void)initThirdPage
{
  [[pages objectAtIndex:2] setBackgroundColor:[UIColor clearColor]];
  thirdPageObjects = [[NSMutableArray alloc] init];
  NLElementView* number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"3" andOrigin:CGPointMake(100, 200)];
  [thirdPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"+" andOrigin:CGPointMake(225, 225)];
  [thirdPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"" andOrigin:CGPointMake(300, 200) andEditable:YES];
  [thirdPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"=" andOrigin:CGPointMake(425, 225)];
  [thirdPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"8" andOrigin:CGPointMake(500, 200)];
  [thirdPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"4" andOrigin:CGPointMake(200, 450) andEditable:YES];
  [thirdPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeNumber andText:@"5" andOrigin:CGPointMake(310, 450) andEditable:YES];
  [thirdPageObjects addObject:number];
  number = [[NLElementView alloc] initWithType:ElementTypeEraser andText:@"" andOrigin:CGPointMake(420, 490)];
  [thirdPageObjects addObject:number];
  for(NLElementView* temp in thirdPageObjects)
  {
    [[pages objectAtIndex:2] addSubview:temp];
  }
  [[pages objectAtIndex:2] addSubview:[fingers objectAtIndex:2]];
  UITextView* label = [[UITextView alloc] initWithFrame:CGRectMake(400, 50, 400, 120)];
  [label setTextAlignment:UITextAlignmentCenter];
  [label setFont:[UIFont fontWithName:kAppTutorialFontName size:20]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setUserInteractionEnabled:NO];
  [label setText:NSLocalizedString(@"TUTORIAL_TITLE_3", @"erase")];
  [[pages objectAtIndex:2] addSubview:label];
}

-(void)actionOnThirdPage
{
  UIImageView* finger = [fingers objectAtIndex:2];
  [UIView animateWithDuration:0.9
                        delay:0
                      options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
    [finger setCenter:CGPointMake(240, 450)]; //сдвиг пальца на перетягиваемую кнопку
  } completion:^(BOOL finished){
    if (finished) [UIView animateWithDuration:0.5
                                        delay:0.5
                                      options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                   animations:^{
      [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width/1.2, finger.frame.size.height/1.2)]; //уменьшение(выделение)
    }completion:^(BOOL finished){
      if (finished) [UIView animateWithDuration:0.9
                                          delay:0.5
                                        options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                     animations:^{
        NLElementView* temp = [thirdPageObjects objectAtIndex:5];
        [temp setCenter:CGPointMake(350, 250)]; //перенос цифры пальцем на нужное место
        [finger setCenter:CGPointMake(332, 200)];
      }completion:^(BOOL finished){
        if (finished) [UIView animateWithDuration:0.5
                                            delay:0.2
                                          options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                       animations:^{
          [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width*1.2, finger.frame.size.height*1.2)]; //увеличение пальца
          [[thirdPageObjects objectAtIndex:2] setTextTo:@"4" animation:YES];
          [[thirdPageObjects objectAtIndex:5] setCenter:CGPointMake(250, 500)];
        }completion:^(BOOL finished){
          if (finished) [UIView animateWithDuration:0.9
                                              delay:0.2
                                            options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                         animations:^{
            [finger setCenter:CGPointMake(465, 485)];
          }completion:^(BOOL finished){
            if (finished) [UIView animateWithDuration:0.5
                                                delay:0.2
                                              options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                           animations:^{
              [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width/1.2, finger.frame.size.height/1.2)];
              [[thirdPageObjects objectAtIndex:2] performSelector:@selector(setTextTo:animation:) withObject:@"" afterDelay:1.8];
            }completion:^(BOOL finished){
              if (finished) [UIView animateWithDuration:0.9
                                                  delay:0.2
                                                options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                             animations:^{
                [finger setCenter:CGPointMake(332, 200)];
                [[thirdPageObjects objectAtIndex:7] setCenter:CGPointMake(350, 250)];
              }completion:^(BOOL finished){
                if(finished) [UIView animateWithDuration:0.5
                                                   delay:0.2
                                                 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                  [finger setFrame:CGRectMake(finger.frame.origin.x, finger.frame.origin.y, finger.frame.size.width*1.2, finger.frame.size.height*1.2)]; //увеличение пальца
                  [[thirdPageObjects objectAtIndex:7] setCenter:CGPointMake(470, 513)];
                }completion:^(BOOL finished){
                  if (finished) [UIView animateWithDuration:0.5
                                                      delay:0.2
                                                    options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                                                 animations:^{
                    [finger setCenter:CGPointMake(250, 150)];
                  }completion:^(BOOL finished){
                    if (finished) [self performSelector:@selector(showAction) withObject:nil afterDelay:3];
                  }];
                }];
              }];
            }];
          }];
        }];
      }];
    }];
  }];
}


-(void)reloadThirdPage
{
  [[thirdPageObjects objectAtIndex:2] setTextTo:@"" animation:YES];
  [[thirdPageObjects objectAtIndex:0] setCenter:CGPointMake(150, 250)];
  [[thirdPageObjects objectAtIndex:1] setCenter:CGPointMake(250, 250)];
  [[thirdPageObjects objectAtIndex:2] setCenter:CGPointMake(350, 250)];
  [[thirdPageObjects objectAtIndex:3] setCenter:CGPointMake(450, 250)];
  [[thirdPageObjects objectAtIndex:4] setCenter:CGPointMake(550, 250)];
  [[thirdPageObjects objectAtIndex:5] setCenter:CGPointMake(250, 500)];
  [[thirdPageObjects objectAtIndex:6] setCenter:CGPointMake(360, 500)];
  [[thirdPageObjects objectAtIndex:7] setCenter:CGPointMake(470, 513)];
}

-(void)initFourthPage
{
  NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
  [param setObject:[NSNumber numberWithInt:1] forKey:@"currentLevel"];
  NSMutableArray* array = [[NSMutableArray alloc] init];
  for (int i=0; i<3; i++) {
    [array addObject:[NSNumber numberWithInt:5]];
  }
  [param setObject:array forKey:@"levels"];
  NLProgress* progress = [[NLProgress alloc] initWithParam:param];
  [progress setCenter:CGPointMake(300, 80)];
  [[pages objectAtIndex:3] addSubview:progress];
  UIImageView* star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedStar"]];
  [star setCenter:CGPointMake(600, 80)];
  [[pages objectAtIndex:3] addSubview:star];
  star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedStar"]];
  [star setCenter:CGPointMake(660, 80)];
  [[pages objectAtIndex:3] addSubview:star];
  star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedStar"]];
  [star setCenter:CGPointMake(720, 80)];
  [[pages objectAtIndex:3] addSubview:star];
  star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeButton"]];
  [star setCenter:CGPointMake(70, 300)];
  [[pages objectAtIndex:3] addSubview:star];
  star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NextButton"]];
  [star setCenter:CGPointMake(650, 500)];
  [[pages objectAtIndex:3] addSubview:star];
  
  UITextView* label = [[UITextView alloc] init];
  [label setText:NSLocalizedString(@"TUTORIAL_INFO_PROGRESS", @"progressbar info")];
  [label setTextAlignment:UITextAlignmentCenter];
  [label setFont:[UIFont fontWithName:kAppTutorialFontName size:20]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setFrame:CGRectMake(20, 120,290,120)];
  [label setUserInteractionEnabled:NO];
  [[pages objectAtIndex:3] addSubview:label];
  
  label = [[UITextView alloc] init];
  [label setText:NSLocalizedString(@"TUTORIAL_INFO_LIFES", @"lifes info")];
  [label setTextAlignment:UITextAlignmentCenter];
  [label setFont:[UIFont fontWithName:kAppTutorialFontName size:20]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setFrame:CGRectMake(570, 120,180,250)];
  [label setUserInteractionEnabled:NO];
  [[pages objectAtIndex:3] addSubview:label];
  
  label = [[UITextView alloc] init];
  [label setText:NSLocalizedString(@"TUTORIAL_INFO_HOME", @"homebutton info")];
  [label setTextAlignment:UITextAlignmentLeft];
  [label setFont:[UIFont fontWithName:kAppTutorialFontName size:20]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setFrame:CGRectMake(140, 250,390,120)];
  [label setUserInteractionEnabled:NO];
  [[pages objectAtIndex:3] addSubview:label];
  
  label = [[UITextView alloc] init];
  [label setText:NSLocalizedString(@"TUTORIAL_INFO_NEXT", @"nextbutton info")];
  [label setTextAlignment:UITextAlignmentRight];
  [label setFont:[UIFont fontWithName:kAppTutorialFontName size:20]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setFrame:CGRectMake(20, 450, 570,110)];
  [label setUserInteractionEnabled:NO];
  [[pages objectAtIndex:3] addSubview:label];
}

-(void)actionOnFourthPage
{
  
}

-(void)reloadFourthPage
{
  
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollViewLocal withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  if (CGPointEqualToPoint(velocity, CGPointZero)) {
    [self scrollViewDidEndDecelerating:scrollViewLocal];
  }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewLocal
{
  CGFloat pageWidth = scrollViewLocal.frame.size.width;
  float fractionalPage = scrollViewLocal.contentOffset.x / pageWidth;
  NSInteger page = lround(fractionalPage);
  
  if (page!=pageControl.currentPage&&page>=0&&page<=3) {
    
    //[[pages objectAtIndex:pageControl.currentPage] removeFromSuperview];
    switch (pageControl.currentPage) {
      case 0: {
        for (UIView* temp in firstPageObjects) {
          //[temp removeFromSuperview];
          [temp.layer removeAllAnimations];
        }
        [[[fingers objectAtIndex:0] layer] removeAllAnimations];
        [self reloadFirstPage];
        break;
      }
        
      case 1: {
        for (UIView* temp in secondPageObjects) {
          //[temp removeFromSuperview];
          [temp.layer removeAllAnimations];
        }
        [[[fingers objectAtIndex:1] layer] removeAllAnimations];
        [self reloadSecondPage];
        break;
      }
      case 2: {
        for (UIView* temp in thirdPageObjects) {
          //[temp removeFromSuperview];
          [temp.layer removeAllAnimations];
        }
        [[[fingers objectAtIndex:2] layer] removeAllAnimations];
        [self reloadThirdPage];
        break;
      }
      case 3: {
        
        break;
      }
        
      default:
        break;
    }
    //[scrollView addSubview:[pages objectAtIndex:pageControl.currentPage]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showAction) object:nil];
    [[fingers objectAtIndex:pageControl.currentPage] setFrame:CGRectMake(100, 100, kFingerWidth, kFingerHeight)];
    [[fingers objectAtIndex:pageControl.currentPage] setCenter:CGPointMake(250, 150)];
    pageControl.currentPage = page;
    [self performSelector:@selector(showAction) withObject:nil afterDelay:3];

  }
  //[self cancelAction];
  //[self showAction];
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
