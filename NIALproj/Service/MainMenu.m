//
//  MainMenu.m
//  NLProject
//
//  Created by Алексей Гончаров on 21.07.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#define kButtonWidth 200
#define kButtonHeight 100

#define kTextHeight 587
#define kTextWidth 350
#define kCurtainHeight 92
#define kHideElementHeight 42
#define kShownArea 490


#import "MainMenu.h"
#import "GameViewController.h"
#import "NLProgress.h"
#import "NLProfileView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "NLTutotial.h"


@interface MainMenu ()

@end

@implementation MainMenu



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIButton*) getMenuButtonWithTitle: (NSString*) title {
	UIButton* button =[UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
	button.tag = 1;

	return button;
}

- (void)addLeftInfo {
	leftScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(210, kCurtainHeight, kTextWidth, kShownArea + kHideElementHeight)];
	leftScroll.contentSize = CGSizeMake(kTextWidth, 2*kShownArea + kHideElementHeight-17);
	leftScroll.contentOffset = CGPointMake(0, kShownArea-100);
	leftScroll.pagingEnabled = YES;
	leftScroll.bounces = NO;
  leftScroll.delegate = self;
	[leftScroll setShowsVerticalScrollIndicator:NO];
	UIImageView* shutter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shutter.jpg"]];
	shutter.frame = CGRectMake(0, 0, kTextWidth, kShownArea);
	[leftScroll addSubview:shutter];
	UILabel* ring = [[UILabel alloc]initWithFrame:CGRectMake(350/2-20, kShownArea, 40, 42)];
	ring.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Ring"]];
	[leftScroll addSubview:ring];
	[majorScrollView addSubview:leftScroll];
	UIImageView* curtain = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Curtain"]];
	curtain.frame = CGRectMake(200, 0, 370, 92);
	[majorScrollView addSubview:curtain];
}

- (void)addRightInfo {
	rightScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(580, kCurtainHeight, kTextWidth, kShownArea + kHideElementHeight)];
	rightScroll.contentSize = CGSizeMake(kTextWidth, 2*kShownArea + kHideElementHeight-17);
	rightScroll.contentOffset = CGPointMake(0, kShownArea-17);
	rightScroll.pagingEnabled = YES;
	rightScroll.bounces = NO;
	[rightScroll setShowsVerticalScrollIndicator:NO];
	UIImageView* shutter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shutter.jpg"]];
	shutter.frame = CGRectMake(0, 0, kTextWidth, kShownArea);
	[rightScroll addSubview:shutter];
	UILabel* ring = [[UILabel alloc]initWithFrame:CGRectMake(350/2-20, kShownArea, 40, 42)];
	ring.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Ring"]];
	[rightScroll addSubview:ring];
	[majorScrollView addSubview:rightScroll];
	UIImageView* curtain = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Curtain"]];
	curtain.frame = CGRectMake(570, 0, 370, 92);
  rightScroll.delegate = self;
	[majorScrollView addSubview:curtain];
}

- (void)loadWallpapers {
	UIImageView *wallpaper = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WallpeperTop.jpg"]];
	wallpaper.frame = CGRectMake(170, 0, 800, 50);
	[majorScrollView addSubview:wallpaper];
	wallpaper = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WallpeperTop.jpg"]];
	wallpaper.frame = CGRectMake(170, 625, 800, 50);
	[majorScrollView addSubview:wallpaper];
	int i = 0;
	int k = -714;
	while (i < 7) {
		if (i == 4)
			k+=718;
		wallpaper = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WallpeperLine.jpg"]];
		wallpaper.frame = CGRectMake(k + i*238, 0, 238, 768);
		[majorScrollView addSubview:wallpaper];
		++i;
	}	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	tutorialShown = NO;
	self.view.backgroundColor = [UIColor clearColor];
	
	majorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 7684)];
	[self.view addSubview:majorScrollView];
	majorScrollView.backgroundColor = [UIColor clearColor];
	[majorScrollView setContentSize:majorScrollView.frame.size];
	[majorScrollView setAlwaysBounceHorizontal:YES];
	[majorScrollView setAlwaysBounceVertical:NO];
	[majorScrollView setShowsHorizontalScrollIndicator:NO];
	
	[self loadWallpapers];
	
	UIImageView* window = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Window"]];
	window.frame = CGRectMake(170, 50, 800, 577);
	[majorScrollView addSubview:window];
	
	profileView = [[NLProfileView alloc]initWithFrame:CGRectMake(512-kProfileWidth/2, -kProfileHeight, kProfileWidth, kProfileHeight)];
	
		////
	
	[self addLeftInfo];
	[self addRightInfo];
	
	UIImageView* table = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"table"]];
	table.frame = CGRectMake(80, 640, 929, 213);
	[majorScrollView addSubview:table];
	
	
	UIImage* titleBG = [UIImage imageNamed:@"TitleButton"];
	UIImageView* titleSheet;
	
		//learning button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(30, 20, 120, 137);
	[button addTarget:self action:@selector(newGameButton:) forControlEvents:UIControlEventTouchUpInside];
	UIImageView* buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LearningButton"]];
	buttonFrame.frame =  CGRectMake(30, 20, 120, 120);
	[majorScrollView addSubview:buttonFrame];
	[majorScrollView addSubview:button];
	UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(40, 130, 100, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[majorScrollView addSubview:titleSheet];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"MENU_LEARNING_BTN", @"Learning title");
	title.textAlignment = UITextAlignmentCenter;
	[majorScrollView addSubview:title];
		//custom button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(20, 160, 100, 117);
	[button addTarget:self action:@selector(newGameButtonWithParametrs:) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CustomButton"]];
	buttonFrame.frame =  CGRectMake(20, 160, 100, 100);
	[majorScrollView addSubview:buttonFrame];
	[majorScrollView addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 120, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[majorScrollView addSubview:titleSheet];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"MENU_CUSTOM_BTN", @"Custom title");
	title.textAlignment = UITextAlignmentCenter;
	[majorScrollView addSubview:title];
		//timegame button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(50, 280, 100, 117);
	[button addTarget:self action:@selector(newGameButtonWithTimer:) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TimeButton"]];
	buttonFrame.frame =  CGRectMake(50, 280, 100, 100);
	[majorScrollView addSubview:buttonFrame];
	[majorScrollView addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(40, 370, 120, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[majorScrollView addSubview:titleSheet];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"MENU_TIME_BTN", @"Time title");
	title.textAlignment = UITextAlignmentCenter;
	[majorScrollView addSubview:title];
		//profile button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(10, 420, 100, 107);
	[button addTarget:self action:@selector(moveProfile:) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ProfileButton"]];
	buttonFrame.frame =  CGRectMake(10, 420, 100, 100);
	[majorScrollView addSubview:buttonFrame];
	[majorScrollView addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(20, 510, 80, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[majorScrollView addSubview:titleSheet];
	title.backgroundColor = [UIColor clearColor];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.text = NSLocalizedString(@"MENU_PROFILE_BTN", @"Profile title");
	title.textAlignment = UITextAlignmentCenter;
	[majorScrollView addSubview:title];
		//about button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(25, 540, 110, 127);
	[button addTarget:self action:@selector(showTutorial:) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"InfoButton"]];
	buttonFrame.frame =  CGRectMake(25, 540, 110, 110);
	[majorScrollView addSubview:buttonFrame];
	[majorScrollView addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(35, 640, 90, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[majorScrollView addSubview:titleSheet];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"MENU_INFO_BTN", @"Info title");
	title.textAlignment = UITextAlignmentCenter;
	[majorScrollView addSubview:title];

	darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
  [darkView setBackgroundColor:[UIColor blackColor]];
  [darkView setAlpha:0];
  [darkView setTag:1000];
  [self.view addSubview:darkView];
	[self.view addSubview:profileView];
	
	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(kProfileWidth-62, 19, 40, 40);
	closeButton.tag = 1000;
	[closeButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CloseButton"]]];
	[closeButton addTarget:self action:@selector(moveProfile:) forControlEvents:UIControlEventTouchUpInside];
	[profileView addSubview:closeButton];
	
	titleBG = [UIImage imageNamed:@"TitleLabel"];
	usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(500, 720, 160, 17)];
	[usernameLabel setBackgroundColor:[UIColor colorWithPatternImage:titleBG]];
	usernameLabel.textAlignment = UITextAlignmentCenter;
	[majorScrollView addSubview:usernameLabel];
	
}

- (void)reloadUsername {
	if ([[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUsername"]) {
		usernameLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUsername"];
	}
	else {
		usernameLabel.text = nil;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[self makeLight];
	if (![[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUsername"]) {
		[self moveProfile:nil];
	}
	else {
		[self reloadUsername];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touch");
}

- (void)moveLeftScroll:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	if (leftScroll.frame.origin.y < 0) {
		leftScroll.frame = CGRectMake(210, kCurtainHeight, kTextWidth, kShownArea + kHideElementHeight);
	}
	else {
		leftScroll.frame = CGRectMake(210, -kShownArea + kCurtainHeight + 10, kTextWidth, kShownArea + kHideElementHeight);
	}
	[UIView commitAnimations];
}

- (void)moveRightScroll:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	if (rightScroll.frame.origin.y < 0) {
		rightScroll.frame = CGRectMake(580, kCurtainHeight, kTextWidth, kShownArea + kHideElementHeight);
	}
	else {
		rightScroll.frame = CGRectMake(580, -kShownArea + kCurtainHeight + 10, kTextWidth, kShownArea + kHideElementHeight);
	}
	[UIView commitAnimations];
}

- (void)moveProfile:(id)sender {
	if (sender != nil) {
		[NLSound playSound:SoundTypeClick];
	}
	if (profileView.frame.origin.y < 0) {
		[self makeDark];
		[profileView reloadStatistics];
		[UIView animateWithDuration:0.6 animations:^{
			profileView.frame = CGRectMake(self.view.center.x-225, 160, 450, 450);
		}];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideProfile) name:@"UserSet" object:nil];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTutorial:) name:@"NewUserCreated" object:nil];
	}
	else {
 		[self makeLight];
		[self reloadUsername];
		[profileView resignAll];
		[UIView animateWithDuration:0.6 animations:^{
			profileView.frame = CGRectMake(self.view.center.x-225, -450, 450, 450);
		}];
	}
}

- (void)hideProfile {
	[UIView animateWithDuration:0.6 animations:^{
		profileView.frame = CGRectMake(self.view.center.x-225, -450, 450, 450);
	}];
	[self reloadUsername];
	[profileView resignAll];
	[self makeLight];
}

- (void)makeDark {
  [UIView animateWithDuration:0.5 animations:^{
    [darkView setAlpha:0.7];
  }];
}

- (void)makeLight {
	[UIView animateWithDuration:0.5 animations:^{
		darkView.alpha = 0;
	}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"%@", [NSValue valueWithCGPoint:scrollView.contentOffset]);
}

- (void)newGameButton:(id)sender {
	[NLSound playSound:SoundTypeClick];
	if (!profileView.setUser) {
		[self showUserAlert];
	}
	else {
		GameViewController* game = [[GameViewController alloc] initWithType:GameTypeLearning andProfile:profileView];
		[self.navigationController pushViewController:game animated:YES];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)showUserAlert {
	UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"MENU_NO_USER_ALRT", @"choose user alert")  delegate:self cancelButtonTitle:NSLocalizedString(@"MENU_NO_USER_ALERT_CANCEL_BTN", nil) otherButtonTitles:NSLocalizedString(@"MENU_NO_USER_ALERT_REDIRECT_BTN", nil), nil];
	[NLSound playSound:SoundTypeAlert];
	[alert show];
}

#pragma mark - AlertView Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[NLSound playSound:SoundTypeClick];
		if (buttonIndex == 1) {
		[self moveProfile:nil];
	}
}

#pragma mark - Game Methods
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//	[self animateTextField: textField up: YES];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//	[theTextField resignFirstResponder];
//	return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//	
//	[self animateTextField: textField up: NO];
//}
//
//- (void)animateTextField:(UITextField*)textField up:(BOOL)up {
//	const int movementDistance = 110; // tweak as needed
//	const float movementDuration = 0.3f; // tweak as needed
//	
//	int movement = (up ? -movementDistance : movementDistance);
//	
//	[UIView beginAnimations: @"anim" context: nil];
//	[UIView setAnimationBeginsFromCurrentState: YES];
//	[UIView setAnimationDuration: movementDuration];
//	self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//	[UIView commitAnimations];
//}

-(void)newGameButtonWithParametrs:(id)sender
{
	[NLSound playSound:SoundTypeClick];
  if (!profileView.setUser) {
		[self showUserAlert];
	}
	else {
    [self makeDark];
	UIView* temp = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-225, -450, 450, 450)];
	[temp setTag:2];
	temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AccountBoard.jpg"]];
	[self.view addSubview:temp];
	[UIView animateWithDuration:0.6 animations:^{
		[temp setCenter:self.view.center];
	}];
	UIPickerView* picker = [[UIPickerView alloc] initWithFrame:CGRectMake(67, 20+50, 320,216)];
	[temp addSubview:picker];
	picker.delegate = self;
	picker.showsSelectionIndicator = YES;
	[picker setTag:3];
	
	arrayOfTypes = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"PICKER_SOLVE", nil),NSLocalizedString(@"PICKER_DECIMETRES", nil),NSLocalizedString(@"PICKER_MAG_SQ", nil),NSLocalizedString(@"PICKER_INT_SQ", nil),NSLocalizedString(@"PICKER_COMPARE", nil),NSLocalizedString(@"PICKER_EQUATION", nil), nil];
	UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(67, 250+40, 320, 50)];
	[slider setTag:4];
	[slider setMinimumValue:10];
	[slider setMaximumValue:100];
	[slider setValue:55];
  [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	[temp addSubview:slider];
    
    UILabel* infoLabel = [[UILabel alloc] init];
    [infoLabel setText:NSLocalizedString(@"CUSTOM_COUNT", @"count of solves")];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel sizeToFit];
    [infoLabel setCenter:CGPointMake(150, 350)];
    [temp addSubview:infoLabel];
  
  UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(/*temp.bounds.size.width/2-25*/150+infoLabel.frame.size.width/2, 300+25, 50, 50)];
  [label setTextAlignment:UITextAlignmentCenter];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setText:@"55"];
  [label setTag:55];
  [temp addSubview:label];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:NSLocalizedString(@"CUSTOM_START", @"Start button") forState:UIControlStateNormal];
	[button setFrame:CGRectMake(temp.bounds.size.width/2-40, temp.bounds.size.height-70, 80, 40)];

	[button addTarget:self action:@selector(newGameWithParametrs:) forControlEvents:UIControlEventTouchUpInside];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"TutorialButton"] forState:UIControlStateNormal];
	[temp addSubview:button];
  
  button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:@"" forState:UIControlStateNormal];
  [button setFrame:CGRectMake(temp.frame.size.width-40-22, 19, 40, 40)];

  [button addTarget:self action:@selector(returnToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"CloseButton"] forState:UIControlStateNormal];

  [temp addSubview:button];
    //array = [[NSMutableArray alloc] initWithObjects:@"first",@"second",@"third", nil];
	}
}

-(void)sliderChanged:(id)sender
{
  [(UILabel*)[[self.view viewWithTag:2] viewWithTag:55] setText:[NSString stringWithFormat:@"%.0f",[(UISlider*)[[self.view viewWithTag:2] viewWithTag:4] value]]];
}


-(void)newGameWithParametrs:(id)sender
{
	int type = [(UIPickerView*)[[self.view viewWithTag:2] viewWithTag:3] selectedRowInComponent:0]+1;
	int difficult = [(UIPickerView*)[[self.view viewWithTag:2] viewWithTag:3] selectedRowInComponent:1];
	int count = [(UISlider*)[[self.view viewWithTag:2] viewWithTag:4] value];
	GameViewController* game = /*[[GameViewController alloc] initWithTime:10];*/[[GameViewController alloc] initWithType:type andDifficult:difficult andCount:count andProfile:profileView];
	[self.navigationController pushViewController:game animated:YES];
  [self makeLight];
	[UIView animateWithDuration:0.6 animations:^{
		[[self.view viewWithTag:2] setCenter:CGPointMake(self.view.center.x, -400)];
	} completion:^(BOOL finished){
		[[self.view viewWithTag:2] removeFromSuperview];
	}];
}

-(void)returnToMainMenu:(id)sender
{
	[NLSound playSound:SoundTypeClick];
  [self makeLight];
  [UIView animateWithDuration:0.6 animations:^{
        [[self.view viewWithTag:1000] setAlpha:0];
		[[self.view viewWithTag:2] setCenter:CGPointMake(self.view.center.x, -450)];
	} completion:^(BOOL finished){
		[[self.view viewWithTag:2] removeFromSuperview];
    
	}];
}

-(void)newGameButtonWithTimer:(id)sender
{
	[NLSound playSound:SoundTypeClick];
  if (!profileView.setUser) {
		[self showUserAlert];
	}
	else {
	GameViewController* game = [[GameViewController alloc] initWithTime:300 andProfile:profileView];
	[self.navigationController pushViewController:game animated:YES];
  }
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
	if(component==0) return 6;
	else {
		switch ([pickerView selectedRowInComponent:0]) {
			case 0:
				return 18;
				break;
			case 1:
				return 7;
				break;
			case 2:
				return 3;
				break;
			case 3:
				return 3;
				break;
			case 4:
				return 13;
				break;
			case 5:
				return 9;
				break;
			default:
				return 0;
				break;
		}
	}
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component==0) {
		return 240;
	}
	return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
	if(component==0) return [arrayOfTypes objectAtIndex:row];
	else return [NSString stringWithFormat:@"%d",row+1];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
	if (component==0) {
		[pickerView reloadComponent:1];
	}
}

#pragma mark - Tutorial Methods

- (void)showTutorial:(id)sender {
	if (sender != nil)
		[NLSound playSound:SoundTypeClick];
	if (tutorialShown) {
		return;
	}
	tutorialShown = YES;
	tutorial = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	tutorial.tag = 15;
	tutorial.backgroundColor = [UIColor clearColor];
		
	UIView* rightDark = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	rightDark.backgroundColor = [UIColor blackColor];
	rightDark.alpha = 0.8;
	[tutorial addSubview:rightDark];
	
	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(750, 704, 200, 62);
	closeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TutorialButton"]];
	[closeButton addTarget:self action:@selector(hideTutorial) forControlEvents:UIControlEventTouchUpInside];
	[closeButton setTitle:NSLocalizedString(@"TUTOR_CLOSE_BTN", @"close button") forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[tutorial addSubview:closeButton];
	
	[self addAbout];
	
		//learning button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(30, 20, 120, 137);
	
	UIImage* titleBG = [UIImage imageNamed:@"TitleButton"];
	UIImageView* titleSheet;
	
	[button addTarget:self action:@selector(showLearningTutorial) forControlEvents:UIControlEventTouchUpInside];
	UIImageView* buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LearningButton"]];
	buttonFrame.frame =  CGRectMake(30, 20, 120, 120);
	[tutorial addSubview:buttonFrame];
	[tutorial addSubview:button];
	UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(40, 130, 100, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[tutorial addSubview:titleSheet];
	
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"TUTOR_LEARNING_BTN", @"Learning title");
	title.textAlignment = UITextAlignmentCenter;
	[tutorial addSubview:title];
		//custom button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(20, 160, 100, 117);
	[button addTarget:self action:@selector(showCustomTutorial) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CustomButton"]];
	buttonFrame.frame =  CGRectMake(20, 160, 100, 100);
	[tutorial addSubview:buttonFrame];
	[tutorial addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 120, 17)];
	
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[tutorial addSubview:titleSheet];
	
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"TUTOR_CUSTOM_BTN", @"Custom title");
	title.textAlignment = UITextAlignmentCenter;
	[tutorial addSubview:title];
		//timegame button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(50, 280, 100, 117);
	[button addTarget:self action:@selector(showTimeTutorial) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TimeButton"]];
	buttonFrame.frame =  CGRectMake(50, 280, 100, 100);
	[tutorial addSubview:buttonFrame];
	[tutorial addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(40, 370, 120, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[tutorial addSubview:titleSheet];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"TUTOR_TIME_BTN", @"Time title");
	title.textAlignment = UITextAlignmentCenter;
	[tutorial addSubview:title];
		//gameplay button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(10, 420, 100, 107);
	[button addTarget:self action:@selector(showProfileTutorial) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GameplayButton"]];
	buttonFrame.frame =  CGRectMake(10, 420, 100, 100);
	[tutorial addSubview:buttonFrame];
	[tutorial addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(20, 510, 80, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[tutorial addSubview:titleSheet];
	title.backgroundColor = [UIColor clearColor];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.text = NSLocalizedString(@"TUTOR_HOW_TO_PLAY_BTN", @"Gameplay title");
	title.textAlignment = UITextAlignmentCenter;
	[tutorial addSubview:title];
		//about button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(25, 540, 110, 127);
	[button addTarget:self action:@selector(showAboutTutorial) forControlEvents:UIControlEventTouchUpInside];
	buttonFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"InfoButton"]];
	buttonFrame.frame =  CGRectMake(25, 540, 110, 110);
	[tutorial addSubview:buttonFrame];
	[tutorial addSubview:button];
	title = [[UILabel alloc]initWithFrame:CGRectMake(35, 640, 90, 17)];
	titleSheet = [[UIImageView alloc]initWithImage:titleBG];
	titleSheet.frame = title.frame;
	[tutorial addSubview:titleSheet];
	title.font = [UIFont fontWithName:@"Verdana" size:13];
	title.backgroundColor = [UIColor clearColor];
	title.text = NSLocalizedString(@"TUTOR_INFO_BTN", @"Info title");
	title.textAlignment = UITextAlignmentCenter;
	[tutorial addSubview:title];
	tutorial.alpha = 0;
	[self.view addSubview:tutorial];
	[UIView animateWithDuration:0.5 animations:^{
		tutorial.alpha = 1;
	}];
	
  
  
  
}

- (void)showMailDialog {
	[NLSound playSound:SoundTypeClick];
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc]init];
		[mailController setSubject:@"NIAL support"];
		[mailController setToRecipients:[NSArray arrayWithObject:@"nialsoft@gmail.com"]];
		NSString* message = NSLocalizedString(@"MAIL_HEAD", @"mail head");
		message = [message stringByAppendingString:@"\n-----------------------------------------------------------------------------------\n"];
		[mailController setMessageBody:message isHTML:NO];
		mailController.mailComposeDelegate = self;
		[self.navigationController presentModalViewController:mailController animated:YES];
	}
	else {
		UIAlertView* alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"MAIL_ERROR", @"mail error") message:@"MAIL_ERROR_MSG" delegate:self cancelButtonTitle:NSLocalizedString(@"MAIL_ERROR_CANCEL_BTN", nil) otherButtonTitles:nil ];
		alert.tag = 101;
		[NLSound playSound:SoundTypeAlert];
		[alert show];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[NLSound playSound:SoundTypeClick];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)clearTutorial {
	for (UIView* viewToDelete in tutorial.subviews) {
		if (viewToDelete.tag == 2) {
			[viewToDelete removeFromSuperview];
		}
	}
}

- (void)addAbout {
	UITextView* startTutorialText = [[UITextView alloc]initWithFrame:CGRectMake(180, 20, 800, 300)];
	startTutorialText.text = NSLocalizedString(@"TUTOR_START_LABEL", @"Label on the about screen");
	startTutorialText.font = [UIFont fontWithName:kAppTutorialFontName size:25];
	startTutorialText.textColor = [UIColor whiteColor];
	startTutorialText.userInteractionEnabled = NO;
	startTutorialText.backgroundColor = [UIColor clearColor];
	startTutorialText.tag = 2;
	[tutorial addSubview:startTutorialText];
	
	UILabel* nialLabel = [[UILabel alloc]initWithFrame:CGRectMake(512-250, 400, 415, 151)];
	nialLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nial_about"]];
	nialLabel.tag = 2;
	[tutorial addSubview:nialLabel];
	
	UILabel* version = [[UILabel alloc]initWithFrame:CGRectMake(180, 600, 180, 20)];
	version.backgroundColor = [UIColor clearColor];
	version.text = NSLocalizedString(@"TUTOR_VERSION_LABEL", nil);
	version.text = [version.text stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]];
	version.textAlignment = UITextAlignmentCenter;
	version.textColor = [UIColor lightGrayColor];
	version.tag = 2;
	[tutorial addSubview:version];
	
	UILabel* localization = [[UILabel alloc]initWithFrame:CGRectMake(310, 600, 200, 20)];
	localization.backgroundColor = [UIColor clearColor];
	localization.text = NSLocalizedString(@"TUTOR_LOCALIZATION", nil);
	localization.textAlignment = UITextAlignmentCenter;
	localization.textColor = [UIColor lightGrayColor];
	localization.tag = 2;
	[tutorial addSubview:localization];
	
	UILabel* design = [[UILabel alloc]initWithFrame:CGRectMake(480, 600, 200, 20)];
	design.backgroundColor = [UIColor clearColor];
	design.text = NSLocalizedString(@"Design by HK", nil);
	design.textAlignment = UITextAlignmentCenter;
	design.textColor = [UIColor lightGrayColor];
	design.tag = 2;
	[tutorial addSubview:design];
	
	UIButton* mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
	mailButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TutorialButton"]];
	[mailButton addTarget:self action:@selector(showMailDialog) forControlEvents:UIControlEventTouchUpInside];
	mailButton.frame = CGRectMake(200, 705, 200, 62);
	mailButton.tag = 2;
	[mailButton setTitle:NSLocalizedString(@"TUTOR_SUPPORT_BTN", nil) forState:UIControlStateNormal];
	[tutorial addSubview:mailButton];
}

- (void)addText {
	infoText = [[UITextView alloc]initWithFrame:CGRectMake(180, 30, 800, 700)];
	infoText.backgroundColor = [UIColor clearColor];
	infoText.tag = 2;
	infoText.userInteractionEnabled = NO;
	infoText.editable = NO;
	infoText.text = @"Default info text";
	infoText.textColor = [UIColor whiteColor];
	infoText.font = [UIFont fontWithName:kAppTutorialFontName size:25];
	[tutorial addSubview:infoText];
}

- (void)showLearningTutorial {
	[NLSound playSound:SoundTypeClick];
	[self clearTutorial];
  [self addText];
  infoText.text = NSLocalizedString(@"TUTOR_LEARNING_TEXT", nil);
}

- (void)showCustomTutorial {
	[NLSound playSound:SoundTypeClick];
	[self clearTutorial];
	[self addText];
	infoText.text = NSLocalizedString(@"TUTOR_CUSTOM_TEXT", nil);

}

- (void)showTimeTutorial {
	[NLSound playSound:SoundTypeClick];
	[self clearTutorial];
	[self addText];
	infoText.text = NSLocalizedString(@"TUTOR_TIME_TEXT", nil);

}

- (void)showProfileTutorial {
	[NLSound playSound:SoundTypeClick];
	[self clearTutorial];
	//[self addText];
	//infoText.text = NSLocalizedString(@"TUTOR_PROFILE_TEXT", nil);
  NLTutotial* temp = [[NLTutotial alloc] init];
  temp.tag = 2;
  [tutorial addSubview:temp];

}

- (void)showAboutTutorial {
	[NLSound playSound:SoundTypeClick];
	[self clearTutorial];
	[self addAbout];
}

- (void)hideTutorial {
	[NLSound playSound:SoundTypeClick];
	[Appirater userDidSignificantEvent:NO];
	for (UIView* viewToDelete in self.view.subviews) {
		if (viewToDelete.tag == 15) {
			[UIView animateWithDuration:0.5 animations:^{
				viewToDelete.alpha = 0;
			} completion:^(BOOL finished) {
				[viewToDelete removeFromSuperview];
			}];
		}
	}
	tutorialShown = NO;
}

@end
