//
//  NLProfileView.h
//  NLProject
//
//  Created by Alexey Goncharov on 05.08.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface NLProfileView : UIView <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
	UIScrollView* majorScrollView;
	UILabel* title;
	UITextField* inputUser;
}

@property (nonatomic, readwrite) NSMutableArray* users;
@property (nonatomic, readwrite) NSMutableDictionary* currentUser;
@property (nonatomic, readwrite)  BOOL setUser;

- (void)saveDataBeforeTerminate;
- (void)reloadStatistics;
- (void)resignAll;
	/* Username
	 * Rank
	 * LastLevel
	 * ProposedSolves
	 * RightAnswers
	 * BestControlResult
	 * AverageTimeForSolve
	 */



@end
