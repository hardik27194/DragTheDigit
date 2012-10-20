//
//  NLResultInfo.h
//  NLProject
//
//  Created by Nikita Popov on 10.08.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "Appirater.h"

@interface NLResultInfo : UIView
{
  GameType gameTypePlayed;
  UIView* darkView;
  UIView* infoView;
  BOOL continueAfterPopUp;
}

+(id)resultInfoAfterGameType:(GameType)gameType withStatistic:(NSDictionary*)info;
-(void)show;
-(void)hide;
@end
