//
//  MainMenu.h
//  NLProject
//
//  Created by Алексей Гончаров on 21.07.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLProfileView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "NLSound.h"

@interface MainMenu:UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> {
	NLProfileView* profileView;
	UIView* aboutView;
	int countOfUsers;
	NSArray* userNames;
	UIScrollView* majorScrollView;
	UITextView *infoText;
	UIScrollView *leftScroll, *rightScroll;
	UIView* darkView, *tutorial;
	NSMutableArray* arrayOfTypes;
	UILabel* usernameLabel;
	BOOL tutorialShown;
}
- (void)moveProfile:(id)sender;

@end
