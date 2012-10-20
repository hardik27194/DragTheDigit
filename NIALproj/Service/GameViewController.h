#import <UIKit/UIKit.h>
#import "NLKeyboard.h"
#import "NLProgress.h"
#import "NLProfileView.h"

typedef enum {
	GameTypeLearning,
	GameTypeCustom,
	GameTypeControl
} GameType;

typedef enum {
	SolveTypeSolve,
	SolveTypeDecimeters,
	SolveTypeMagicSquare,
	SolveTypeInterestingSquare,
	SolveTypeCompares,
	SolveTypeEquation
} SolveType;

@interface GameViewController : UIViewController {
	int countOfProposedSolves; //количество предложенных примеров
	int countOfTrueAnswers; // количество правильных ответов
  int countOfMistakes; // количество ошибок
	float rating;
	GameType typeOfGame;
	NLKeyboard* keyboard;
	NLProgress* progressBar;
	NLProfileView* profileView;
		//this property shows us whether we should start new game with getting default settings
	BOOL newGame;
	
		//shows number of current level in the current game which we should appear on the screen
	NSInteger numberOfCurrentLevel;
	
		//shows number of current solve in the level's array
	NSInteger currentSublevel;
	
		//shows type of current solve
		//next types of solves are supporting
		//1 - solve (usial 1 + 2 = 3)
		//2 - decimeters
		//3 - magicSquare
		//4 - interestingSquare
		//5 - comparator
		//6 - equation
	
		//this dictionary contains the list of levels and included solves with their difficulties
	NSMutableArray *levels;
	
		//there are UILabels which shows your current lives condition in this array
		//label.tag = 100..102
	NSMutableArray *lives;
	
		//there are data about current level
		//it looks like string 1-1 which means typeOfSolve = 1 and difficultyOfSolve = 1
	NSMutableArray *currentLevel;
	
		//in this textView we show the description of each solve: how to use and what we want
	UITextView *description;
	
		//here we put the information about current condition of player's answers
		//shows in percents
	UITextView *statistic;
	
	UIView* instanceView;
	
	NSMutableArray* answers, *labelsForKeyboard;
	  
  NSDate* elapsedTime;
  NSDate* timeSinceSolveArrived;
  NSTimeInterval totalTime;
	int proposed, failed;
	UIView *fullInfoView, *liteInfoView;
	
	UIButton* doneButton;
	BOOL newLevel;
	BOOL infoFlipped;
	
	int currentDiff, currentType;
  
  NSTimer* timer;
}


- (id)initWithType:(GameType)type andProfile:(NLProfileView*)profile;
- (id)initWithType:(int)type andDifficult:(int)difficult andCount:(int)count andProfile:(NLProfileView*)profile;;
- (id)initWithTime:(NSTimeInterval)time andProfile:(NLProfileView*)profile;;


@end