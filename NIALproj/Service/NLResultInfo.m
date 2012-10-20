//
//  NLResultInfo.m
//  NLProject
//
//  Created by Nikita Popov on 10.08.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "NLResultInfo.h"
#import "GameViewController.h"
#import "NLSound.h"

@implementation NLResultInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)resultInfoAfterGameType:(GameType)gameType withStatistic:(NSDictionary*)info
{
	[Appirater userDidSignificantEvent:YES];
	
  NLResultInfo* result = [[NLResultInfo alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
  if (result) {
    result->darkView = [[UIView alloc] initWithFrame:[result frame]];
    result->darkView.backgroundColor = [UIColor blackColor];
    result->darkView.alpha = 0;
    [result addSubview:result->darkView];
    
    result->infoView = [[UIView alloc] initWithFrame:CGRectMake(512-225, -450, 450, 450)];
    result->infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AccountBoard.jpg"]];
    
    UIButton* continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton setTitle:NSLocalizedString(@"RESULT_CONTINUE_BTN", @"button at the bottom") forState:UIControlStateNormal];
    [continueButton setBackgroundColor:[UIColor clearColor]];
    [continueButton sizeToFit];
		continueButton.frame = CGRectMake(225 - 80, 380 , 160, 40);
		[continueButton setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal ];
		[continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [continueButton addTarget:result action:@selector(continueButton:) forControlEvents:UIControlEventTouchUpInside];
    [result->infoView addSubview:continueButton];
    
    result->gameTypePlayed = gameType;
    
    UITextView* caption = [[UITextView alloc] init];
    [caption setFrame:CGRectMake(25, 25, 400, 80)];
    [caption setBackgroundColor:[UIColor clearColor]];
    [caption setTextAlignment:UITextAlignmentCenter];
		[caption setFont:[UIFont fontWithName:kAppProfileFontName size:40]];
    [caption setText:NSLocalizedString(@"RESULT_CONGS_MSG", nil)];
    [caption setEditable:NO];
    [caption setUserInteractionEnabled:NO];
    [result->infoView addSubview:caption];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:NSLocalizedString(@"RESULT_EXIT_BTN", @"button at the bottom") forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
    [backButton setCenter:CGPointMake(result->infoView.frame.size.width/2-100, result->infoView.frame.size.height - 60)];
    [backButton addTarget:result action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (gameType) {
      case GameTypeControl: {
        UITextView* label = [[UITextView alloc] init];
				NSString* totalTasks = NSLocalizedString(@"RESULT_TOTAL_TASKS", nil);
				totalTasks = [totalTasks stringByAppendingString:[NSString stringWithFormat:@" %i", [[info objectForKey:@"totalSolves"] intValue]]];
        [label setText:totalTasks];
				[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];
        [label setFrame:CGRectMake(70, 100, 310, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setEditable:NO];
        [label setUserInteractionEnabled:NO];
        [result->infoView addSubview:label];
        label = [[UITextView alloc] init];
				NSString* totalMistakes = NSLocalizedString(@"RESULT_TOTAL_MISTAKES", nil);
				totalMistakes = [totalMistakes stringByAppendingString:[NSString stringWithFormat:@" %i", [[info objectForKey:@"totalMistakes"] intValue]]];
        [label setText:totalMistakes];
				[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];
        [label setFrame:CGRectMake(70, 150, 310, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setEditable:NO];
        [label setUserInteractionEnabled:NO];
        [result->infoView addSubview:label];
        break;
      }
      case GameTypeCustom: {
        UITextView* label = [[UITextView alloc] init];
				NSString* elapsedTime = NSLocalizedString(@"RESULT_ELAPSED_TIME", nil);
				elapsedTime = [elapsedTime stringByAppendingString:[NSString stringWithFormat:@" %.1f", [[info objectForKey:@"elapsedTime"] floatValue]]];
				elapsedTime = [elapsedTime stringByAppendingString:NSLocalizedString(@"RESULT_SECONDS", nil)];
        [label setText:elapsedTime];
				[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];
        [label setFrame:CGRectMake(70, 100, 310, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setEditable:NO];
        [label setUserInteractionEnabled:NO];
        [result->infoView addSubview:label];
        label = [[UITextView alloc] init];
				[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];

				NSString* totalTasks = NSLocalizedString(@"RESULT_TOTAL_TASKS", nil);
				totalTasks = [totalTasks stringByAppendingString:[NSString stringWithFormat:@" %i", [[info objectForKey:@"totalSolves"] intValue]]];
        [label setText:totalTasks];
        //[label setCenter:CGPointMake(70, 150)];
        //[label sizeToFit];
        [label setFrame:CGRectMake(70, 150, 310, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setEditable:NO];
        [label setUserInteractionEnabled:NO];
        [result->infoView addSubview:label];
        label = [[UITextView alloc] init];
				[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];

				NSString* totalMistakes = NSLocalizedString(@"RESULT_TOTAL_MISTAKES", nil);
				totalMistakes = [totalMistakes stringByAppendingString:[NSString stringWithFormat:@" %i", [[info objectForKey:@"totalMistakes"] intValue]]];
        [label setText:totalMistakes];
        //[label setCenter:CGPointMake(70, 200)];
        //[label sizeToFit];
        [label setFrame:CGRectMake(70, 200, 310, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setEditable:NO];
        [label setUserInteractionEnabled:NO];
        [result->infoView addSubview:label];
        result->continueAfterPopUp = NO;
        break;
      }
      case GameTypeLearning: {
        if (info) {
					if ([info objectForKey:@"AllLevelsDone"]) {
						
						UITextView* label = [[UITextView alloc] init];
						[label setText:NSLocalizedString(@"RESULT_ALL_GAME_COMPLETE_LBL", nil)];
						[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];
						[label setFrame:CGRectMake(25, 150, 400, 200)];
						[label setTextAlignment:UITextAlignmentCenter];
						[label setBackgroundColor:[UIColor clearColor]];
						[label setEditable:NO];
						label.userInteractionEnabled = NO;
						[result->infoView addSubview:label];
						
						[backButton addTarget:self action:@selector(exitToMenu) forControlEvents:UIControlEventTouchUpInside];
						[backButton setCenter:CGPointMake(result->infoView.frame.size.width/2, result->infoView.frame.size.height - 60)];
						[result->infoView addSubview:backButton];
						
						[result addSubview:result->infoView];
						return result;
					}
          result->continueAfterPopUp = YES;
          UITextView* label = [[UITextView alloc] init];
          [label setText:NSLocalizedString(@"RESULT_JUST_COMPLETED_LBL", nil)];
					[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];
          [label setFrame:CGRectMake(25, 100, 400, 40)];
          [label setTextAlignment:UITextAlignmentCenter];
          [label setBackgroundColor:[UIColor clearColor]];
          [label setEditable:NO];
					label.userInteractionEnabled = NO;
          [result->infoView addSubview:label];
          
          label = [[UITextView alloc] init];
          [label setText:[NSString stringWithFormat:@"%i", [[info objectForKey:@"completedLevel"] intValue]]];
          [label setFont:[UIFont systemFontOfSize:180]];
          [label setFrame:CGRectMake(25, 130, 400, 200)];
					label.userInteractionEnabled = NO;
          [label setTextAlignment:UITextAlignmentCenter];
          [label setBackgroundColor:[UIColor clearColor]];
          [label setEditable:NO];
          [result->infoView addSubview:label];
          
          label = [[UITextView alloc] init];
          [label setText:NSLocalizedString(@"RESULT_LEVEL_TEXT", nil)];
					label.userInteractionEnabled = NO;
					[label setFont:[UIFont fontWithName:kAppProfileFontName size:20]];
          [label setFrame:CGRectMake(25, 330, 400, 80)];
          [label setTextAlignment:UITextAlignmentCenter];
          [label setBackgroundColor:[UIColor clearColor]];
          [label setEditable:NO];
          [result->infoView addSubview:label];
					
          [backButton setCenter:CGPointMake(result->infoView.frame.size.width/2, result->infoView.frame.size.height - 60)];
          
          [result->infoView addSubview:backButton];
        }
        else {
					[NLSound playSound:SoundTypeGameOver];
          UITextView* text = [[UITextView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
          [text setText:NSLocalizedString(@"RESULT_FAIL_TEXT", @"text after fail in learning mode")];
          [text setFont:[UIFont fontWithName:kAppProfileFontName size:32]];
          [text setBackgroundColor:[UIColor clearColor]];
          [text setUserInteractionEnabled:NO];

          //[text sizeToFit];
          //[text setCenter:CGPointMake(result->infoView.frame.size.width/2, result->infoView.frame.size.height/2)];
          [text setFrame:CGRectMake(25, 205, 400, 100)];
          [text setTextAlignment:UITextAlignmentCenter];
          [text setEditable:NO];
          [result->infoView addSubview:text];
          
          result->continueAfterPopUp = YES;
          
          [caption setText:NSLocalizedString(@"RESULT_GAME_OVER_TEXT", nil)];
          
          [continueButton setTitle:NSLocalizedString(@"RESULT_RESTART_BUTTON", @"button at the bottom") forState:UIControlStateNormal];
          [continueButton sizeToFit];
          [continueButton setCenter:CGPointMake(result->infoView.frame.size.width/2+100, result->infoView.frame.size.height - 60)];
          
          [backButton setTitle:NSLocalizedString(@"RESULT_EXIT_BTN", @"exit") forState:UIControlStateNormal];
          [backButton sizeToFit];
          [backButton setCenter:CGPointMake(result->infoView.frame.size.width/2-100, result->infoView.frame.size.height - 60)];
          [result->infoView addSubview:backButton];
        }
        break;
      }
      default:
        break;
    }
    //[caption sizeToFit];
    //[caption setCenter:CGPointMake(result->infoView.frame.size.width/2, 60)];
    [result addSubview:result->infoView];
  }
  return result;
}

-(void)backButton:(id)sender
{
	[NLSound playSound:SoundTypeClick];
  continueAfterPopUp = NO;
  [self continueButton:sender];
}

-(void)continueButton:(id)sender
{
	[NLSound playSound:SoundTypeClick];
  if (continueAfterPopUp) {
    [self hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"restartLevel" object:nil];
  }
  if (!continueAfterPopUp) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exitToMainMenu" object:nil];
  }
}

- (void)exitToMenu {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"exitToMenuNow" object:nil];
}

-(void)show
{
  [UIView animateWithDuration:0.6 animations:^{
    [infoView setCenter:CGPointMake(512, 384)];
    [darkView setAlpha:0.5];
  }];
}
-(void)hide
{
  [UIView animateWithDuration:0.6 animations:^{
    [infoView setCenter:CGPointMake(512, -225)];
    [darkView setAlpha:0];
  } completion:^(BOOL finished){
    [self removeFromSuperview];
  }];
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
