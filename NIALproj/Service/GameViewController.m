#define savesFile @"Saves.plist"
#define levelsFile @"Levels.plist"

#import "AppDelegate.h"
#import "GameViewController.h"
#import "Comparator.h"
#import "Solve.h"
#import "InterestingSquare.h"
#import "MagicSquare.h"
#import "Decimeters.h"
#import "NLResultInfo.h"
#import "NLSound.h"

@implementation GameViewController

- (void)getSolveRating {
	rating = 0.0;
	int countOfSolvesinLevel;
	switch (currentType) {
		case 1:
			countOfSolvesinLevel = 18;
			break;
		case 2:
			countOfSolvesinLevel = 7;
			break;
		case 3:
			countOfSolvesinLevel = 3;
			break;
		case 4:
			countOfSolvesinLevel = 3;
			break;
		case 5:
			countOfSolvesinLevel = 13;
			break;
		case 6:
			countOfSolvesinLevel = 9;
			break;
		default:
			break;
	}
	rating = (float)(currentDiff+1)/countOfSolvesinLevel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
			// Custom initialization
	}
	return self;
}

#pragma mark - Init Methods

	//before calling you should init levels array and numberOfCurrentLevel
- (void)addProgressBar {
	UIImageView* progressBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ProgressBG"]];
	progressBG.frame = CGRectMake(80, 10, 600, 56);
	[self.view addSubview:progressBG];
	
	NSMutableArray* subLevels = [[NSMutableArray alloc]init];
	for (NSArray* sublev in levels) {
		[subLevels addObject:[NSNumber numberWithInt:sublev.count]];
	}
	NSDictionary* params = [[NSDictionary alloc]initWithObjectsAndKeys:subLevels, @"levels", [NSNumber numberWithInt:numberOfCurrentLevel], @"currentLevel", nil];
	progressBar = [[NLProgress alloc]initWithParam:params];
	[self.view addSubview:progressBar];
}

- (void)loadFiles {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	
	NSMutableArray* base = [NSMutableArray arrayWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"Levels.plist"]];
	NSMutableArray* level;
	levels = [[NSMutableArray alloc]initWithCapacity:base.count];
	for (int i = 0; i < base.count; ++i) {
		NSString* currentLevelString = [base objectAtIndex:i];
			// int levelCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfSolvesInLevel"] intValue];
		level = [[NSMutableArray alloc]initWithCapacity:20];
		for ( int j = 0; j < 20; ++j) {
			[level addObject:currentLevelString];
		}
		[levels addObject:level];
	}
	proposed = 0;
	failed = 0;
}

-(void) readSavedInfo {
	numberOfCurrentLevel = [[profileView.currentUser objectForKey:@"LastLevel"]integerValue];
}

- (id)initWithType:(GameType)type andProfile:(NLProfileView*)profile {
	self = [[GameViewController alloc]init];
	profileView = profile;
	typeOfGame = type;
	currentSublevel = 0;
  countOfMistakes = 0;
	countOfProposedSolves = 0;
	switch (type) {
		case GameTypeLearning: {
			[self loadFiles];
			[self readSavedInfo];
			
			
			break;
		}
		case GameTypeCustom: {
      //[self loadFiles];
      numberOfCurrentLevel = -1;
			break;
		}
		case GameTypeControl: {
			//[self loadFiles];
      numberOfCurrentLevel = -1;
			break;
		}
		default:
			break;
	}
	return self;
}

- (id)initWithType:(int)type andDifficult:(int)difficult andCount:(int)count andProfile:(NLProfileView*)profile
{
  self = [[GameViewController alloc] initWithType:GameTypeCustom andProfile:profile];
  if (self) {
    currentLevel = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i=0; i<count; ++i) {
      [currentLevel addObject:[NSString stringWithFormat:@"%i-%i",type,difficult]];
      levels = [[NSMutableArray alloc] initWithObjects:currentLevel, nil];
    }
    }
  return self;
}

- (id)initWithTime:(NSTimeInterval)time andProfile:(NLProfileView*)profile
{
  self = [[GameViewController alloc] initWithType:GameTypeControl andProfile:profile];
  if (self) {
    totalTime = time;
    currentLevel = [[NSMutableArray alloc] initWithCapacity:900];
    [[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfSolvesInLevel"];
    NSMutableArray* types = [[NSMutableArray alloc] initWithCapacity:6];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"solveEnabled"] boolValue]) [types addObject:[NSNumber numberWithInt:1]];
    if ([[defaults objectForKey:@"decimetersEnabled"] boolValue]) [types addObject:[NSNumber numberWithInt:2]];
    if ([[defaults objectForKey:@"magicSquareEnabled"] boolValue]) [types addObject:[NSNumber numberWithInt:3]];
    if ([[defaults objectForKey:@"interestingSquareEnabled"] boolValue]) [types addObject:[NSNumber numberWithInt:4]];
    if ([[defaults objectForKey:@"compareEnabled"] boolValue]) [types addObject:[NSNumber numberWithInt:5]];
    if ([[defaults objectForKey:@"equationEnabled"] boolValue]) [types addObject:[NSNumber numberWithInt:6]];
    
    
    for (int i=0; i<900; ++i) {
      int type = [Generator generateNewNumberWithStart:0 Finish:[types count]-1];
      type = [[types objectAtIndex:type] intValue];
      int diff;
      switch (type) {
        case 1:
          diff = [Generator generateNewNumberWithStart:0 Finish:[[defaults objectForKey:@"solveDifficult"] intValue]];
          break;
        case 2:
          diff = [Generator generateNewNumberWithStart:0 Finish:[[defaults objectForKey:@"decimetersDifficult"] intValue]];
          break;
        case 3:
          diff = [Generator generateNewNumberWithStart:0 Finish:[[defaults objectForKey:@"magicSquareDifficult"] intValue]];
          break;
        case 4:
          diff = [Generator generateNewNumberWithStart:0 Finish:[[defaults objectForKey:@"interestingSquareDifficult"] intValue]];
          break;
        case 5:
          diff = [Generator generateNewNumberWithStart:0 Finish:[[defaults objectForKey:@"compareDifficult"] intValue]];
          break;
        case 6:
          diff = [Generator generateNewNumberWithStart:0 Finish:[[defaults objectForKey:@"equationDifficult"] intValue]];
          break;
        default:
          return 0;
          break;
      }
      [currentLevel addObject:[NSString stringWithFormat:@"%i-%i",type,diff]];
    }
    levels = [[NSMutableArray alloc] initWithObjects:currentLevel,nil]; //addObject:currentLevel];
  }
  return self;
}

-(void)countdown:(NSTimer*)timerLocal
{
  NSArray* array = [[(UILabel*)[self.view viewWithTag:50] text] componentsSeparatedByString:@":"];
  int seconds = [[array objectAtIndex:1] integerValue];
  int minutes = [[array objectAtIndex:0] integerValue];
  --seconds;
  if (seconds<0) {
    --minutes;
    seconds=59;
  }
  if (minutes<0) {
    [self finishGame];
    [timerLocal invalidate];
    [NLSound playSound:SoundTypeEndTime];
    
  }
  else if(seconds<10)[(UILabel*)[self.view viewWithTag:50] setText:[NSString stringWithFormat:@"%i:0%i",minutes,seconds]];
  else [(UILabel*)[self.view viewWithTag:50] setText:[NSString stringWithFormat:@"%i:%i",minutes,seconds]];
  if (minutes<1&&seconds==9) {
    [NLSound playSound:SoundTypeTimer];
  }
}

#pragma mark - Working Methods

- (void)startGame {
	switch (typeOfGame) {
		case GameTypeLearning: {
			if (numberOfCurrentLevel == -1) {
					//some welcome screen for this mode
			}
			++numberOfCurrentLevel;
			[self loadLives];
				//[self showNextLevelScreen];
			[self addProgressBar];
			currentLevel = [levels objectAtIndex:numberOfCurrentLevel];
			currentSublevel = -1;
			[self showNextSublevel];
				//	[self removeNextLevelScreen];
			break;
		}
    case GameTypeCustom: {
      if (numberOfCurrentLevel == -1) {
        //some welcome screen for this mode
			}
			++numberOfCurrentLevel;
			//[self loadLives];
			//[self showNextLevelScreen];
			[self addProgressBar];
      currentSublevel = -1;
			[self showNextSublevel];
			//[self removeNextLevelScreen];
			break;
    }
    case GameTypeControl: {
      if (numberOfCurrentLevel == -1) {
        //some welcome screen for this mode
			}
			++numberOfCurrentLevel;
			//[self loadLives];
			//[self showNextLevelScreen];
			//[self addProgressBar];
      UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(412, 5, 200, 62)];
      [label setTag:50];
      [label setBackgroundColor:[UIColor clearColor]];
      [label setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:40.0]];
      [label setText:[NSString stringWithFormat:@"%i:0%i",(int)totalTime/60,(int)totalTime%60]];
			[label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TutorialButton"]]];
			[label setTextAlignment:UITextAlignmentCenter];
      timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
      [self.view addSubview:label];
      currentSublevel = -1;
			[self showNextSublevel];
			//[self removeNextLevelScreen];
			break;
    }
		default:
			break;
	}
	
}

- (void)showNextSublevel {
	newLevel = NO;
		//[self saveStatistics];
	++currentSublevel;
	if (currentSublevel > currentLevel.count - 1) {
		[self showNextLevel];
	}
	else {
		NSString* sublevelInfo = [currentLevel objectAtIndex:currentSublevel];
		NSArray* solveInfo = [sublevelInfo componentsSeparatedByString:@"-"];
		NSInteger typeOfSolve = [[solveInfo objectAtIndex:0]integerValue];
		currentType = typeOfSolve;
		NSInteger	difficulty = [[solveInfo objectAtIndex:1]integerValue];
		currentDiff = difficulty;
		[self showNewSolve:typeOfSolve withDifficulty:difficulty];
    //[progressBar nextSublevelWithAnswer:YES];
  }
	[self saveStatistics];
}

- (void)showNextLevel {
	newLevel = YES;
	[self saveStatistics];
	if (typeOfGame==GameTypeLearning) [self loadLives];
	++numberOfCurrentLevel;
	if (numberOfCurrentLevel < levels.count) {
		/*[self showNextLevelScreen];
		currentLevel = [levels objectAtIndex:numberOfCurrentLevel];
		currentSublevel = -1;
		[self showNextSublevel];
		[self removeNextLevelScreen];*/
    NSDictionary* stat = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:numberOfCurrentLevel] forKey:@"completedLevel"];
    NLResultInfo* nextLevelSplashScreen = [NLResultInfo resultInfoAfterGameType:typeOfGame withStatistic:stat];
    [self.view addSubview:nextLevelSplashScreen];
    [nextLevelSplashScreen show];
	}
	else {
		numberOfCurrentLevel = -1;
		if (typeOfGame == GameTypeLearning) {
			[profileView.currentUser setObject:@"YES" forKey:@"DoneGame"];
		}
		[self saveStatistics];
		[self finishGame];
	}
}

-(void)restartLevel {
  if ([lives count]==0) {
    [progressBar restart];
    [self loadLives];
  }
  else {
    [progressBar nextLevelWithAnswer:YES];
  }
		//[self showNextLevelScreen];
  currentLevel = [levels objectAtIndex:numberOfCurrentLevel];
  currentSublevel = -1;
  [self showNextSublevel];
  [self removeNextLevelScreen];
  
}

- (void)finishGame {
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitButton:) name:@"exitToMenuNow" object:nil];
  switch (typeOfGame) {
    case GameTypeLearning: {
			if (lives.count == 0) {
				NLResultInfo* gameOver = [NLResultInfo resultInfoAfterGameType:typeOfGame withStatistic:nil];
				[self.view addSubview:gameOver];
				[gameOver show];
			}
      else {
				[lives removeAllObjects];
				numberOfCurrentLevel = -1;
				[self saveStatistics];
				NSDictionary* params = [NSDictionary dictionaryWithObject:@"YES" forKey:@"AllLevelsDone"];
				NLResultInfo* gameOver = [NLResultInfo resultInfoAfterGameType:typeOfGame withStatistic:params];
				[self.view addSubview:gameOver];
				[gameOver show];
			}
      break;
    }
    case GameTypeCustom: {
      NSTimeInterval totalElapsedTime = [[NSDate date] timeIntervalSinceDate:elapsedTime];
      /*GameOverViewController* gameOver = [[GameOverViewController alloc]initWithTotalSolves:countOfProposedSolves andRightSolves:countOfTrueAnswers andElapsedTime:totalElapsedTime];
      [self presentModalViewController:gameOver animated:YES];
      [self.navigationController popToRootViewControllerAnimated:NO];*/
      NSMutableDictionary* statistics = [[NSMutableDictionary alloc] init];
      [statistics setObject:[NSNumber numberWithFloat:totalElapsedTime] forKey:@"elapsedTime"];
      [statistics setObject:[NSNumber numberWithInt:countOfProposedSolves-countOfMistakes] forKey:@"totalSolves"];
      [statistics setObject:[NSNumber numberWithInt:countOfMistakes] forKey:@"totalMistakes"];
      NLResultInfo* gameOver = [NLResultInfo resultInfoAfterGameType:typeOfGame withStatistic:statistics];
      [self.view addSubview:gameOver];
      [gameOver show];
      break;
    }
    case GameTypeControl: {
      /*GameOverViewController* gameOver = [[GameOverViewController alloc]initWithTotalSolves:countOfTrueAnswers andRightSolves:countOfTrueAnswers andElapsedTime:0];
      [self presentModalViewController:gameOver animated:YES];
      [self.navigationController popToRootViewControllerAnimated:NO];*/
      NSMutableDictionary* statistics = [[NSMutableDictionary alloc] init];
      [statistics setObject:[NSNumber numberWithInt:countOfTrueAnswers] forKey:@"totalSolves"];
      [statistics setObject:[NSNumber numberWithInt:countOfMistakes] forKey:@"totalMistakes"];
      NLResultInfo* gameOver = [NLResultInfo resultInfoAfterGameType:typeOfGame withStatistic:statistics];
      [self.view addSubview:gameOver];
      [gameOver show];
      
      NSNumber* number = [profileView.currentUser objectForKey:@"BestControlResult"];
      if (countOfTrueAnswers>[number intValue]) {
        [profileView.currentUser setObject:[NSNumber numberWithInt:countOfTrueAnswers] forKey:@"BestControlResult"];
      }
      
      break;
    }
    default:
      break;
  }
}

- (void)showNextLevelScreen {
	[self loadLives];
	NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
	[params setObject:[NSNumber numberWithInt:numberOfCurrentLevel] forKey:@"LastLevel"];
	[params setObject:[NSNumber numberWithInt:countOfProposedSolves] forKey:@"ProposedSolves"];
	[params setObject:[NSNumber numberWithInt:countOfMistakes] forKey:@"Mistakes"];

	UIView* nextLevelScreen = [[UIView alloc]init];
	nextLevelScreen.backgroundColor = [UIColor blackColor];
	nextLevelScreen.alpha = 0;
	UILabel* level = [[UILabel alloc]initWithFrame:CGRectMake(512 - 150, 768/2 - 75, 300, 150)];
	level.text = [[NSString alloc]initWithFormat:@"Level %d", numberOfCurrentLevel+1];
	level.backgroundColor = [UIColor clearColor];
	level.textColor = [UIColor whiteColor];
	level.font = [UIFont fontWithName:@"Courier" size:60];
	[level setTextAlignment:UITextAlignmentCenter];
	[level adjustsFontSizeToFitWidth];
	[nextLevelScreen addSubview:level];
	nextLevelScreen.tag = 2;
	[self.view addSubview:nextLevelScreen];
	[UIView animateWithDuration:1 animations:^{
		nextLevelScreen.alpha = 0.7;
	}];
}

- (void)removeNextLevelScreen {
	for (UIView* nextLevelScreen in self.view.subviews) {
		if (nextLevelScreen.tag == 2) {
			[UIView animateWithDuration:2 animations:^{
				nextLevelScreen.alpha = 0;
			} completion:^(BOOL finished) {
				[nextLevelScreen removeFromSuperview];
			}];
		}
	}
}

- (void)showRedFlashLight {
	UIView* redScreen = [[UIView alloc]init];
	redScreen.frame = CGRectMake(0, 0, 1024, 768);
	redScreen.backgroundColor = [UIColor redColor];
	redScreen.alpha = 0;
	redScreen.tag = 3;
	[self.view addSubview:redScreen];
	[UIView animateWithDuration:1 animations:^{
		redScreen.alpha = 0.7;
	}];
}

- (void)removeRedFlashLight {
	for (UIView* redScreen in self.view.subviews) {
		if (redScreen.tag == 3) {
			[UIView animateWithDuration:1.5 animations:^{
				redScreen.alpha = 0;
			} completion:^(BOOL finished) {
				[redScreen removeFromSuperview];
			}];
		}
	}
}

- (void)showNewSolve:(NSInteger)type withDifficulty:(NSInteger)difficulty {
	[UIView animateWithDuration:0.5 animations:^{
		instanceView.alpha = 0;
	} ];
	for (UIView* viewToDelete in instanceView.subviews) {
		[viewToDelete removeFromSuperview];
	}
	if (type > 6 || type < 1) {
		NSLog(@"Invalid Type!");
		return;
	}
	[self clearInfoView];
		NSString* adultDesc, * childDesc;
	switch (type) {
		case 1: {
			Solve* buf = [[Solve alloc] initWithDifficulty:difficulty];
			[buf showSolveOnView:instanceView];
			labelsForKeyboard = buf.labels;
//			if (buf.needPlusminus) {
//				[keyboard changeKeyboardType:KeyboardTypePlusMinus];
//			}
//			else {
//				[keyboard changeKeyboardType:KeyboardTypeNumbers];
//			}
			adultDesc = buf.fullDescription;
			childDesc = buf.liteDescription;
			break;
		}
		case 2: {
			Decimeters* buf = [[Decimeters alloc] initWithDifficulty:difficulty];
			[buf showSolveOnView:instanceView];
			labelsForKeyboard = buf.labels;
//			if (buf.needPlusminus) {
//				[keyboard changeKeyboardType:KeyboardTypePlusMinus];
//			}
//			else {
//				[keyboard changeKeyboardType:KeyboardTypeNumbers];
//			}
			adultDesc = buf.fullDescription;
			childDesc = buf.liteDescription;
			break;
		}
		case 3: {
			MagicSquare* buf = [[MagicSquare alloc] initWithDifficulty:difficulty];
			[buf showSolveOnView:instanceView];
			labelsForKeyboard = buf.labels;
			//[keyboard changeKeyboardType:KeyboardTypeNumbers];
			
			adultDesc = buf.fullDescription;
			childDesc = buf.liteDescription;
			break;
		}
		case 4: {
			InterestingSquare* buf = [[InterestingSquare alloc] initWithDifficulty:difficulty];
			[buf showSolveOnView:instanceView];
			labelsForKeyboard = buf.labels;
			//[keyboard changeKeyboardType:KeyboardTypeNumbers];
			
			adultDesc = buf.fullDescription;
			childDesc = buf.liteDescription;
			break;
		}
		case 5: {
			Comparator* buf = [[Comparator alloc] initCompareSolveWithDifficulty:difficulty];
			[buf showSolveOnView:instanceView];
			labelsForKeyboard = buf.labels;
			//[keyboard changeKeyboardType:KeyboardTypeSigns];
			
			adultDesc = buf.fullDescription;
			childDesc = buf.liteDescription;

			break;
		}
		case 6: {
			Comparator* buf = [[Comparator alloc] initEquationWithDifficulty:difficulty];
			[buf showSolveOnView:instanceView];
			labelsForKeyboard = buf.labels;
			//[keyboard changeKeyboardType:KeyboardTypeNumbers];
			
			adultDesc = buf.fullDescription;
			childDesc = buf.liteDescription;

			break;
		}
		default:
			break;
	}
	UILabel* info =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 730, 249)];
	[info setText:adultDesc];
	info.textAlignment = UITextAlignmentCenter;
	[info setNumberOfLines:10];
	info.backgroundColor = [UIColor clearColor];
	info.textColor = [UIColor blackColor];
	info.font = [UIFont fontWithName:@"Verdana" size:25];
	[fullInfoView addSubview:info];
	
	info =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 730, 249)];
	[info setText:adultDesc];//childDesc];
	info.textAlignment = UITextAlignmentCenter;
	[info setNumberOfLines:10];
	info.backgroundColor = [UIColor clearColor];
	info.textColor = [UIColor blackColor];
	info.font = [UIFont fontWithName:@"Verdana" size:25];
	[liteInfoView addSubview:info];
  ///////////ВОТ ЗДЕСЬ
  for (UIView* viewToDelegate in [instanceView subviews]) {
    [viewToDelegate setCenter:CGPointMake(viewToDelegate.center.x, viewToDelegate.center.y-100)];
  }
	
	[UIView animateWithDuration:0.5 animations:^{
		instanceView.alpha = 1;
	} ];
	[keyboard rebuildWithChangableArray:labelsForKeyboard];
}

- (BOOL)isAnswerRight {
	for (int i = 0; i < labelsForKeyboard.count; ++i) {
		NLElementView* bufLabel = [labelsForKeyboard objectAtIndex:i];
		if(![bufLabel._text isEqualToString:bufLabel._answer]) {
      if (bufLabel.beforeNull && ![bufLabel._answer isEqualToString:@""]) {
        
      } else   return NO;
    }
	}
	return YES;
}

#pragma mark - Load View Elements Methods

- (void)loadInfoView {
	infoFlipped = NO;
	liteInfoView = [[UIView alloc]initWithFrame:CGRectMake(512-375, 70, 750, 249)];
	liteInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Leither"]];
	//[self.view addSubview:liteInfoView];
	[self.view insertSubview:liteInfoView belowSubview:instanceView];
  
	UIButton* flipButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
	flipButton.tag = 1;
	flipButton.frame = CGRectMake(20, 20, 50, 50);
	[flipButton addTarget:self action:@selector(moveInfoView) forControlEvents:UIControlEventTouchUpInside];
	//[liteInfoView addSubview:flipButton];
	
	fullInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 750, 249)];
	[fullInfoView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Leither"]]];
	
	flipButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
	flipButton.tag = 1;
	flipButton.frame = CGRectMake(20, 20, 50, 50);
	[flipButton addTarget:self action:@selector(moveInfoView) forControlEvents:UIControlEventTouchUpInside];
	[liteInfoView addSubview:flipButton];
	[fullInfoView addSubview:flipButton];
}

- (void)clearInfoView {
	for (UIView* viewToDelete in fullInfoView.subviews) {
		if (viewToDelete.tag != 1) {
			[viewToDelete removeFromSuperview];
		}
	}
	for (UIView* viewToDelete in liteInfoView.subviews) {
		if (viewToDelete.tag != 1) {
			[viewToDelete removeFromSuperview];
		}
	}
	[fullInfoView removeFromSuperview];
	infoFlipped = NO;
}

- (void)moveInfoView {
	[NLSound playSound:SoundTypeFlip];
	if (infoFlipped) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:liteInfoView cache:YES];
		[fullInfoView removeFromSuperview];
		[UIView commitAnimations];
		infoFlipped = NO;
	}
	else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:liteInfoView cache:YES];
		[liteInfoView addSubview:fullInfoView];
		[UIView commitAnimations];
		infoFlipped = YES;
	}
}

- (UIButton*)getNextButton {
	doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(1024-105, 768 - 250, 100, 100);
//	[doneButton setTitle:@"Next" forState:UIControlStateNormal];
	doneButton.tag = 1105;
	doneButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NextButton"]];
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	return doneButton;
}

- (UIButton*)getBackButton {
	UIButton* exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	exitButton.frame = CGRectMake(5, 100, 100, 100);
	exitButton.tag = 1104;
	exitButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeButton"]];
	[exitButton addTarget:self
								 action:@selector(exitButton:)
			 forControlEvents:UIControlEventTouchUpInside];
	[exitButton setImage:[[UIImage alloc] init] forState:UIControlEventTouchDown];
	return exitButton;
}

- (UIButton*)getShuffleKeyboardButton {
	UIButton* shuffleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	shuffleButton.frame = CGRectMake(1024-100, 768 - 200, 100, 100);
	[shuffleButton setTitle:@"R" forState:UIControlStateNormal];// @"R";
  [shuffleButton.titleLabel setFont:[UIFont systemFontOfSize:100]];
	shuffleButton.tag = 1105;
	shuffleButton.backgroundColor = [UIColor lightGrayColor];
	[shuffleButton addTarget:self	action:@selector(shuffleButton:) forControlEvents:UIControlEventTouchUpInside];
	return shuffleButton;
}

- (UIView*)getInstanceView {
  ////////////////И ЗДЕСЬ
	UIView* tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 70+100, 1024, kViewHeight)];
	tempView.tag = 1100;
	tempView.alpha = 0;
	tempView.backgroundColor = [UIColor  clearColor];
	return tempView;
}

#pragma mark - Standart Methods

- (void)viewDidLoad {
	[super viewDidLoad];
  elapsedTime = [NSDate date];
	
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitButton:) name:@"exitToMainMenu" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartLevel) name:@"restartLevel" object:nil];
	self.view.backgroundColor= [UIColor clearColor];
	
	
	keyboard = [[NLKeyboard alloc]initKeyboardWithType:KeyboardTypeNumbers andMagnetArray:[[NSArray alloc]init]];
	[self.view addSubview:keyboard];

	instanceView = [self getInstanceView];
	[self.view addSubview:instanceView];
			//buttons loading
	[self.view addSubview:[self getBackButton]];
	[self.view addSubview:[self getNextButton]];
		
	[self loadInfoView];
	
	[self startGame];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
	[NLSound playSound:SoundTypeClick];
	if (buttonIndex == 0) {
		NSLog(@"Cancel Tapped.");
	}
	else
		if (buttonIndex == 1) {
			[self.navigationController popViewControllerAnimated:YES];
		}
}

- (void)viewDidUnload {
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Lives Methods

- (UILabel*)getLife {
	UILabel* lifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	lifeLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RedStar"]];
	lifeLabel.tag = 13;
	return lifeLabel;
}

- (void)loadLives {
	for (UIView* life in self.view.subviews) {
		if (life.tag == 13) {
			[life removeFromSuperview];
		}
	}
	lives = [[NSMutableArray alloc]initWithCapacity:3];
	for (int i = 1; i <= 3; ++i) {
		UILabel* lifeLabel = [self getLife];
		lifeLabel.frame = CGRectMake(700 + i*60, 20, 40, 40);
		[lives addObject:lifeLabel];
    [lifeLabel setAlpha:0];
		[self.view addSubview:lifeLabel];
	}
  [UIView animateWithDuration:0.5 animations:^{
    for (UILabel* temp in lives) [temp setAlpha:1];
  }];
}

- (void)decreaseLife {
	if (lives.count == 1) {
		[self performSelector:@selector(finishGame) withObject:nil afterDelay:0.5];
	}
  UILabel* label = [lives lastObject];
  [lives removeLastObject];
  [UIView animateWithDuration:0.5 animations:^{
    [label setAlpha:0];
  }completion:^(BOOL finished){
    [label removeFromSuperview];
  }];
}

#pragma mark - Buttons Methods 

- (void)doneButton:(id)sender {
	++countOfProposedSolves;
	++proposed;
	if (![self isAnswerRight]) {
		[NLSound playSound:SoundTypeWrong];
	}
	else {
		[NLSound playSound:SoundTypeClick];
	}
	switch (typeOfGame) {
		case GameTypeLearning:{
			if ([self isAnswerRight]) {
				++countOfTrueAnswers;
				[progressBar nextSublevelWithAnswer:YES];
				if (infoFlipped) {
					[self moveInfoView];
				}
				[self showNextSublevel];
			}
			else {
				
				++failed;
				++countOfMistakes;
				[self showRedFlashLight];
				[self decreaseLife];
				[self removeRedFlashLight];
			}
			break;
		}
      case GameTypeCustom:
    {
      if ([self isAnswerRight]) {
				++countOfTrueAnswers;
				[progressBar nextSublevelWithAnswer:YES];
				if (infoFlipped) {
					[self moveInfoView];
				}
				[self showNextSublevel];
			}
			else {
				++failed;

				++countOfMistakes;
				[self showRedFlashLight];
        //[progressBar nextSublevelWithAnswer:NO];
				[self decreaseLife];
				[self removeRedFlashLight];
			}
			break;
    }
    case GameTypeControl: {
			if (infoFlipped) {
				[self moveInfoView];
			}
      if ([self isAnswerRight]) {
				++countOfTrueAnswers;
			}
			else {
				++failed;

				++countOfMistakes;
				[self showRedFlashLight];
				[self removeRedFlashLight];
			}
      [self showNextSublevel];
      break;
    }
		default:
			break;
	}
}

- (void)exitButton:(id)sender {

		//[self.navigationController popViewControllerAnimated:YES];
  if ([lives count]>0) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_EXIT_BTN_ALRT", nil)
                                                    message:NSLocalizedString(@"GAME_EXIT_BTN_ALRT_MSG", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"GAME_EXIT_BTN_ALRT_CANCEL_BTN", nil)
                                          otherButtonTitles:NSLocalizedString(@"GAME_EXIT_BTN_ALRT_OK_BTN", nil), nil];
    [NLSound playSound:SoundTypeAlert];
    [alert show];
  }
  else {
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
  }
	
	
}


#pragma mark - save statistic Methods

- (void)saveStatistics {
	if (typeOfGame == GameTypeLearning) {
		if (newLevel) {
			NSNumber* number =  [ NSNumber numberWithInteger:numberOfCurrentLevel];
			[profileView.currentUser setObject: number forKey:@"LastLevel"];
			newLevel = NO;
		}
	}
  float average = [[profileView.currentUser objectForKey:@"AverageTimeForSolve"] floatValue];
  if (isnan(average)) average = 0;
  int was = [[profileView.currentUser objectForKey:@"ProposedSolves"]intValue];
		//NSLog([timeSinceSolveArrived description]);
		//NSLog([[NSDate date] description]);
  float plus = [timeSinceSolveArrived timeIntervalSinceNow];
  plus = ABS(plus);
  plus = plus*proposed;
  average = (average*was + plus) / (was + proposed);
  NSNumber* number = [NSNumber numberWithInt:was + proposed];
  [profileView.currentUser setObject: number forKey:@"ProposedSolves"];
  number = [NSNumber numberWithFloat:average];
  [profileView.currentUser setObject:number forKey:@"AverageTimeForSolve"];
  was = [[profileView.currentUser objectForKey:@"Mistakes"]intValue];
	
  number = [NSNumber numberWithInt:was + failed];
  [profileView.currentUser setObject: number forKey:@"Mistakes"];
	
	if (failed == 0) {
		[self getSolveRating];
	}
	else {
		rating = 0.0;
	}
	float lastRating = [[profileView.currentUser objectForKey:@"Rating"]floatValue];
	lastRating += rating;
  [profileView.currentUser setObject:[NSNumber numberWithFloat:lastRating] forKey:@"Rating"];
  
	proposed = 0;
	failed = 0;
	[profileView saveDataBeforeTerminate];
  timeSinceSolveArrived = [NSDate date];
}

@end