//
//  NLProfileView.m
//  NLProject
//
//  Created by Alexey Goncharov on 05.08.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "NLProfileView.h"
#import "NLSound.h"
#import "Appirater.h"
@implementation NLProfileView

@synthesize currentUser, users, setUser;

- (void)resignAll {
	[inputUser resignFirstResponder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
			self.frame = frame;
			[self loadInfoFromBase];
			self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AccountBoard.jpg"]];

			title = [[UILabel alloc]initWithFrame:CGRectMake(kProfileWidth/2 - 150, 15, 300, 45)];
			title.text = NSLocalizedString(@"PROFILE_TITLE", nil);
			title.backgroundColor = [UIColor clearColor];
			title.textAlignment = UITextAlignmentCenter;
			title.tag = 1000;
			title.font = [UIFont fontWithName:kAppProfileFontName size:27];
			[self addSubview:title];
			setUser = (BOOL)[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUsername"];
			if (setUser) {
				[self setUserAsCurrent:[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUsername"]];
				[self showCurrentUser];
			}
			else {
				[self showChangingUserPage:nil];
			}
			[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveDataBeforeTerminate) name:@"SaveData" object:self];
		}
    return self;
}

- (void)reloadStatistics {
	if (setUser) {
		[self showCurrentUser];
	}
}


#pragma mark - View loading Methods

- (void)showCurrentUser {
	[self clearScrollView];
	[self saveCurrentUser];
	[self saveInfoToBase];
	
	UILabel* usernameLabel = [[UILabel alloc]init];
	usernameLabel.text = [self getUsernameFromUser:currentUser];
	usernameLabel.frame = CGRectMake(kProfileWidth/2 - 150, 60, 300, 40);
	usernameLabel.textAlignment = UITextAlignmentCenter;
	usernameLabel.font = [UIFont fontWithName:kAppProfileFontName size:27];
	usernameLabel.backgroundColor = [UIColor clearColor];
	[usernameLabel adjustsFontSizeToFitWidth];
	[self addSubview:usernameLabel];
	
	UILabel* rank = [[UILabel alloc]initWithFrame:CGRectMake(30, 105, 420, 40)];
	rank.backgroundColor = [UIColor clearColor];
	rank.font = [UIFont fontWithName:kAppProfileFontName size:20];
	rank.textAlignment = UITextAlignmentLeft;
	rank.text = NSLocalizedString(@"PROFILE_LINE_RANK", @"rank");
	NSString* userRank = [self getRank];//[currentUser objectForKey:@"Rank"];
	rank.text = [rank.text stringByAppendingString:userRank];
	[self addSubview:rank];
	
	UILabel* lastLevel = [[UILabel alloc]initWithFrame:CGRectMake(30, 150, 420, 40)];
	lastLevel.backgroundColor = [UIColor clearColor];
	lastLevel.font = [UIFont fontWithName:kAppProfileFontName size:20];
	lastLevel.textAlignment = UITextAlignmentLeft;
	lastLevel.text = NSLocalizedString(@"PROFILE_LINE_LEVELS", @"last level");
	NSNumber* lastL = [currentUser objectForKey:@"LastLevel"];
	if ([lastL isEqualToNumber:[NSNumber numberWithInt:-1]]) {
		lastL = [NSNumber numberWithInt:0];
	}
	else {
		lastL = [NSNumber numberWithInt:[lastL intValue]+1];
	}

	NSString* level = [NSString stringWithFormat:@"%@", lastL];
	lastLevel.text = [lastLevel.text stringByAppendingString:level];
	if ([currentUser objectForKey:@"DoneGame"]) {
		lastLevel.text = [lastLevel.text stringByAppendingString:NSLocalizedString(@"GAME_DONE", nil)];
	}
	[self addSubview:lastLevel];
	
	UILabel* rightPercent = [[UILabel alloc]initWithFrame:CGRectMake(30, 195, 420, 40)];
	rightPercent.font = [UIFont fontWithName:kAppProfileFontName size:20];
	rightPercent.backgroundColor = [UIColor clearColor];
	rightPercent.textAlignment = UITextAlignmentLeft;
	rightPercent.text = NSLocalizedString(@"PROFILE_LINE_RIGHT_ANSWS", @"percent of right");
	NSNumber* rightA = [currentUser objectForKey:@"Mistakes"];
	NSNumber* proposed = [currentUser objectForKey:@"ProposedSolves"];
	NSString* right;
	if ([proposed isEqualToNumber:[NSNumber numberWithInt:0]]) {
		right = @"N/A";
	}
	else {
		right = [NSString stringWithFormat:@"%d", 100*([proposed intValue]-[rightA intValue])/[proposed intValue]];
		right = [right stringByAppendingString:@"\%"];
	}
	rightPercent.text = [rightPercent.text stringByAppendingString:right];
	[self addSubview:rightPercent];
	
	UILabel* bestTimeRes = [[UILabel alloc]initWithFrame:CGRectMake(30, 240, 420, 40)];
	bestTimeRes.font = [UIFont fontWithName:kAppProfileFontName size:20];
	bestTimeRes.backgroundColor = [UIColor clearColor];
	bestTimeRes.textAlignment = UITextAlignmentLeft;
	bestTimeRes.text = NSLocalizedString(@"PROFILE_LINE_RECORD_TIME", @"control");
	NSString* best = [NSString stringWithFormat:@"%@", [currentUser objectForKey:@"BestControlResult"]];

	bestTimeRes.text = [bestTimeRes.text stringByAppendingString:best];
	[self addSubview:bestTimeRes];
	
	UILabel* averageTime = [[UILabel alloc]initWithFrame:CGRectMake(30, 285, 420, 40)];
	averageTime.backgroundColor = [UIColor clearColor];
	averageTime.font = [UIFont fontWithName:kAppProfileFontName size:20];
	averageTime.textAlignment = UITextAlignmentLeft;
	averageTime.text = NSLocalizedString(@"PROFILE_LINE_AVG_TIME", @"average time");
	NSString* average = [NSString stringWithFormat:@"%.2f", [[currentUser objectForKey:@"AverageTimeForSolve"] floatValue]];
	
	averageTime.text = [averageTime.text stringByAppendingString:average];
	[self addSubview:averageTime];
	
	UIButton* changeProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
	changeProfileButton.frame = CGRectMake(kProfileWidth/2 - 170, kProfileHeight - 60, 160, 35);
	[changeProfileButton setTitle: NSLocalizedString(@"PROFILE_CHANGE_PROF_BTN", @"change profile") forState:UIControlStateNormal];
	[changeProfileButton addTarget:self action:@selector(showChangingUserPage:) forControlEvents:UIControlEventTouchUpInside];
	[changeProfileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[changeProfileButton setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
	[self addSubview:changeProfileButton];
	
	UIButton* deleteProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[deleteProfileButton setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
	[deleteProfileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	deleteProfileButton.frame = CGRectMake(kProfileWidth/2 + 10, kProfileHeight - 60, 160, 35);
	[deleteProfileButton setTitle: NSLocalizedString(@"PROFILE_DELETE_PROF_BTN", @"delete profile") forState:UIControlStateNormal];
	[deleteProfileButton addTarget:self action:@selector(deleteCurrentUser:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:deleteProfileButton];
}

- (UIButton*)getUsernameButton {
	UIButton* tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
	return tempButton;
}

- (void)showChangingUserPage:(id)sender {
	if (sender != nil) {
		[NLSound playSound:SoundTypeClick];
	}
	[self clearScrollView];
	UIButton* createUser = [self getUsernameButton];
	createUser.frame = CGRectMake(kProfileWidth/2 - 80, 80, 160, 40);
	[createUser setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
	[createUser setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

	[createUser setTitle:NSLocalizedString(@"PROFILE_CREATE_PROF_BTN", @"create new profile") forState:UIControlStateNormal];
	[createUser addTarget:self action:@selector(showCreatingDialog:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:createUser];
	if (users.count > 0) {
		int i = 0;
		for (NSMutableDictionary* userForButton in users) {
			UIButton* userButton = [self getUsernameButton];
			++i;
			userButton.frame = CGRectMake(kProfileWidth/2 - 80, 80 + 50*i, 160, 40);
			[userButton setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
			[userButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

			[userButton setTitle:[self getUsernameFromUser:userForButton] forState:UIControlStateNormal];
			[userButton addTarget:self action:@selector(setUser:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:userButton];
		}
	}
}

- (void)setUser:(id)sender {
	[NLSound playSound:SoundTypeClick];
	UIButton* pressedButton = sender;
	if (setUser) {
		[self saveCurrentUser];
	}
	[self setUserAsCurrent:pressedButton.titleLabel.text];
		//[self showCurrentUser];
}

- (void)deleteCurrentUser:(id)sender {
	[NLSound playSound:SoundTypeClick];
	[self deleteUserFromBase:[self getUsernameFromUser:currentUser]];
	[self showChangingUserPage:nil];
}

- (void)showCreatingDialog:(id)sender {
	if (sender != nil) {
		[NLSound playSound:SoundTypeClick];
	}
	[self clearScrollView];
	UIImageView* textBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TutorialButton"]];
	textBG.frame = CGRectMake(kProfileWidth/2 - 100, 80, 200, 40);
	[self addSubview:textBG];
	inputUser = [[UITextField alloc]initWithFrame:CGRectMake(kProfileWidth/2 - 90, 86, 180, 40)];
	inputUser.backgroundColor = [UIColor clearColor];
	inputUser.delegate = self;
	[inputUser setReturnKeyType:UIReturnKeyDone];
	[inputUser setPlaceholder:NSLocalizedString(@"PROFILE_NAME_FIELD_PLACEHOLDER", @"name textfield placeholder")];
	[inputUser setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
	[self addSubview:inputUser];
	[inputUser becomeFirstResponder];
	UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(kProfileWidth/2 - 80, 130, 160, 40);
	[doneButton setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
	[doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

	[doneButton setTitle:NSLocalizedString(@"PROFILE_CREATE_BTN", @"create button") forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(createUserButton:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:doneButton];
	
	UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(kProfileWidth/2 - 80, 280, 160, 40);
	[backButton setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
	[backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

	[backButton setTitle:NSLocalizedString(@"PROFILE_BACK_BTN", @"back button") forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(showChangingUserPage:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:backButton];
}


- (void)clearScrollView {
	for (UIView* viewToDelete in self.subviews) {
		if (viewToDelete.tag != 1000) {
				[viewToDelete removeFromSuperview];
		}	
	}
	[self saveCurrentUser];
	[self saveInfoToBase];
}

- (void)createUserButton:(id)sender {
	[NLSound playSound:SoundTypeClick];
	NSString* newUsername = inputUser.text;
	if ([self shouldAuthorised:newUsername]) {
		[self createNewUserWithName:newUsername];
		[self setUserAsCurrent:newUsername];
			//[self showCurrentUser];
	}
	else {
		UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"PROFILE_ALRT_WRONG_USERNAME", @"alert wrong username") delegate:self cancelButtonTitle:NSLocalizedString(@"PROFILE_ALRT_WRONG_USERNAME_OK_BTN", @"alert wrong username ok button") otherButtonTitles:nil];
		[NLSound playSound:SoundTypeAlert];
		[alert show];
		inputUser.text = @"";
	}
}

- (BOOL)shouldAuthorised:(NSString*)username {
	BOOL buf = YES;
	if ([username isEqualToString:@""] || username == nil) {
		return NO;
	}
	buf = ![self isUserInBase:username];
	return buf;
}

#pragma mark - Base Oriented Methods

- (void)saveDataBeforeTerminate {
	[self saveCurrentUser];
	[self saveInfoToBase];
}

- (void)loadInfoFromBase {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	users = [NSMutableArray arrayWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"Users.plist"]];
	if ([[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUser"]) {
		currentUser = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUser"];
		setUser = YES;
	}
	else {
		setUser = NO;
	}
}

- (void)saveCurrentUser {
	NSString* currentUsername = [self getUsernameFromUser:currentUser];
	for (int i = 0; i < users.count; ++i) {
		NSMutableDictionary* userForChange = [users objectAtIndex:i];
		NSString* bufUsername = [self getUsernameFromUser:userForChange];
		if ([currentUsername isEqualToString:bufUsername]) {
			userForChange = currentUser;
			break;
		}
	}
	NSLog(@"Current user saved");
}

- (void)saveInfoToBase {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	[users writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Users.plist"] atomically:YES];
	NSLog(@"Data saved");
}
/* Username
 * Rank
 * LastLevel
 * ProposedSolves
 * RightAnswers
 * BestControlResult
 * AverageTimeForSolve
 */
- (void)createNewUserWithName:(NSString*)username {
	[Appirater userDidSignificantEvent:YES];
	NSMutableDictionary* newUser = [[NSMutableDictionary alloc]init];
	[newUser setObject:username forKey:@"Username"];
	[newUser setObject:NSLocalizedString(@"PROFILE_RANKS_BEGINNER", @"beginner rank") forKey:@"Rank"];
	[newUser setObject:[NSNumber numberWithInt:-1]	forKey:@"LastLevel"];//-1
	[newUser setObject:[NSNumber numberWithInt:0] forKey:@"ProposedSolves"];
	[newUser setObject:[NSNumber numberWithInt:0] forKey:@"RightAnswers"];
	[newUser setObject:[NSNumber numberWithInt:0] forKey:@"BestControlResult"];
	[newUser setObject:[NSNumber numberWithFloat:0.0] forKey:@"AverageTimeForSolve"];
	[newUser setObject:[NSNumber numberWithFloat:0.0] forKey:@"Rating"];
	[newUser setObject:[NSNumber numberWithInt:0] forKey:@"Mistakes"];

	[users addObject:newUser];
	[Appirater userDidSignificantEvent:NO];
	[[NSNotificationCenter defaultCenter]postNotificationName:@"NewUserCreated" object:nil];
}

- (void)deleteUserFromBase:(NSString*)username {
	for (int i = 0; i < users.count; ++i) {
		NSMutableDictionary* userForChange = [users objectAtIndex:i];
		NSString* bufUsername = [self getUsernameFromUser:userForChange];
		if ([username isEqualToString:bufUsername]) {
			[users removeObjectAtIndex:i];
			break;
		}
	}
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CurrentUsername"];
	[[NSUserDefaults standardUserDefaults]synchronize];
	setUser = NO;
}

- (BOOL)isUserInBase:(NSString*)username {
	for (int i = 0; i < users.count; ++i) {
		NSMutableDictionary* userForChange = [users objectAtIndex:i];
		NSString* bufUsername = [self getUsernameFromUser:userForChange];
		if ([username isEqualToString:bufUsername]) {
			return YES;
		}
	}
	return NO;
}

- (NSMutableDictionary*)getUserInfo:(NSString*)username {
	for (int i = 0; i < users.count; ++i) {
		NSMutableDictionary* userForChange = [users objectAtIndex:i];
		NSString* bufUsername = [self getUsernameFromUser:userForChange];
		if ([username isEqualToString:bufUsername]) {
			return userForChange;
		}
	}
	return nil;
}

- (void)setUserAsCurrent:(NSString*)username {
		//todo hide profile view
	
	for (int i = 0; i < users.count; ++i) {
		NSMutableDictionary* userForChange = [users objectAtIndex:i];
		NSString* bufUsername = [self getUsernameFromUser:userForChange];
		if ([username isEqualToString:bufUsername]) {
			currentUser = userForChange;
		}
	}
	setUser = YES;
	[[NSUserDefaults standardUserDefaults]setObject:username forKey:@"CurrentUsername"];
	[[NSUserDefaults standardUserDefaults]synchronize];
	[[NSNotificationCenter defaultCenter]postNotificationName:@"UserSet" object:nil];
}

- (NSString*)getUsernameFromUser:(NSMutableDictionary*)user {
	return [user objectForKey:@"Username"];
}

#pragma mark - TextFieldMethods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
		//[self animateTextField: textField up: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[self createUserButton:nil];
	[theTextField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
		//[self animateTextField: textField up: NO];

}

- (void)animateTextField:(UITextField*)textField up:(BOOL)up {
	const int movementDistance = 110; // tweak as needed
	const float movementDuration = 0.3f; // tweak as needed
	
	int movement = (up ? -movementDistance : movementDistance);
	
	[UIView beginAnimations: @"anim" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
	self.frame = CGRectOffset(self.frame, 0, movement);
	[UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[NLSound playSound:SoundTypeClick];
}


- (NSString*)getRank {
	NSString* rankString;
	NSNumber* proposed = [currentUser objectForKey:@"ProposedSolves"];
	if ([proposed intValue] < 50) {
		rankString = NSLocalizedString(@"RANK_BEGINNER", nil);
	}
	else {
		NSNumber* mistakes = [currentUser objectForKey:@"Mistakes"];
		float trueKoeff = 0.0;
		if ([proposed intValue] != 0) {
			trueKoeff = (float)([proposed intValue]-[mistakes intValue])/[proposed intValue];
		}
		float ratingKoeff = [[currentUser objectForKey:@"Rating"]floatValue];
		ratingKoeff = ratingKoeff/[proposed floatValue];
		float timeKoeff = 1/[[currentUser objectForKey:@"AverageTimeForSolve"]floatValue];
		if ([[currentUser objectForKey:@"AverageTimeForSolve"]floatValue] == 0) {
			timeKoeff = 0.0;
		}
		float rank = trueKoeff*ratingKoeff*timeKoeff*100;
		if (rank < 0.5) {
			rankString = NSLocalizedString(@"RANK_1", nil);
		}
		else if (rank < 1) {
			rankString = NSLocalizedString(@"RANK_2", nil);
		}
		else if (rank < 1.5) {
			rankString = NSLocalizedString(@"RANK_3", nil);
		}
		else if (rank < 2) {
			rankString = NSLocalizedString(@"RANK_4", nil);
		}
		else if (rank < 3.5) {
			rankString = NSLocalizedString(@"RANK_5", nil);
		}
		else if (rank < 5) {
			rankString = NSLocalizedString(@"RANK_6", nil);
		}
	else {
		rankString = NSLocalizedString(@"RANK_7", nil);
	}
	}
	return rankString;
}

@end
