//
//  NLProgress.h
//  NLProject
//
//  Created by Nikita Popov on 01.08.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLProgress : UIScrollView <UIAlertViewDelegate, UIScrollViewDelegate>

@property NSMutableArray* levelViews;
@property NSMutableArray* sublevelViews;
@property int currentLevel;
@property int currentSublevel;

-(id)initWithParam:(NSDictionary*)param;
-(void)nextSublevelWithAnswer:(BOOL)answer;
-(void)nextLevelWithAnswer:(BOOL)answer;
-(void)restart;

@end
