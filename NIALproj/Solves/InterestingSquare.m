//
//  InterestingSquare.m
//  Project2
//
//  Created by Алексей Гончаров on 25.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "InterestingSquare.h"
#include "Constants.h"
#import "NLElementView.h"
@implementation InterestingSquare

@synthesize labels, fullDescription, liteDescription;

-(id) initWithCentre:(int)centre {
	fullDescription = NSLocalizedString(@"INT_SQ_FULL_DESC", @"interesting square full description");
	int _centre = centre;
	int _upperLeft = [Generator generateNewNumberWithStart:1 Finish:_centre/2];
	int _upperRight = [Generator generateNewNumberWithStart:0 Finish:_centre - _upperLeft];
	int _upper = _centre - _upperLeft - _upperRight;
	int _lowerLeft = [Generator generateNewNumberWithStart:0 Finish:_centre - _upperLeft];
	int _left = _centre - _upperLeft - _lowerLeft;
	int _lowerRight = [Generator generateNewNumberWithStart:0 Finish:_centre - MAX(_lowerLeft, _upperRight)];
	int _lower = _centre - _lowerLeft - _lowerRight;
	int _right = _centre - _lowerRight - _upperRight;
	elements = [NSArray arrayWithObjects:[NSNumber numberWithInt:_upperLeft],
							[NSNumber numberWithInt:_upper],
							[NSNumber numberWithInt:_upperRight],
							[NSNumber numberWithInt:_left],
							[NSNumber numberWithInt:_centre],
							[NSNumber numberWithInt:_right],
							[NSNumber numberWithInt:_lowerLeft],
							[NSNumber numberWithInt:_lower],
							[NSNumber numberWithInt:_lowerRight], nil];
	return self;
}
-(id) initWithDifficulty:(int)difficulty {
	if (difficulty == 0) {
		InterestingSquare *buf = [[InterestingSquare alloc] initWithCentre:[Generator generateNewNumberWithStart:5 Finish:10]];
		buf.fullDescription = [buf.fullDescription stringByAppendingString:NSLocalizedString(@"INT_SQ_FULL_DESC_ADD_0", @"Addition square FullDescription")];
		return buf;
	}
	if (difficulty == 1) {
		InterestingSquare *buf = [[InterestingSquare alloc] initWithCentre:[Generator generateNewNumberWithStart:11 Finish:20]];
				buf.fullDescription = [buf.fullDescription stringByAppendingString:NSLocalizedString(@"INT_SQ_FULL_DESC_ADD_1", @"Addition square FullDescription")];
		return buf;
	}
	if (difficulty == 2) {
		InterestingSquare *buf = [[InterestingSquare alloc] initWithCentre:[Generator generateNewNumberWithStart:21 Finish:99]];
				buf.fullDescription = [buf.fullDescription stringByAppendingString:NSLocalizedString(@"INT_SQ_FULL_DESC_ADD_2", @"Addition square FullDescription")];
		return buf;
	}
	else return [[InterestingSquare alloc]initWithCentre:0];
}
- (void)showSolveOnView:(UIView*) view_ {
	labels = [[NSMutableArray alloc]initWithCapacity:4];
	int xLevel = 300;
	int yLevel = 250;
	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 3; ++j) {
			CGPoint origin = CGPointMake(xLevel + j*(kNumber+5), yLevel + i*(kNumber + 5));
			int count = 3*i + j;
			NSNumber* buf = [elements objectAtIndex:count];
			NLElementView* newElement = [[NLElementView alloc]initWithType:ElementTypeNumber andText:buf.description andOrigin:origin];
			if (count%2 == 1) {
				newElement = [[NLElementView alloc]initWithType:ElementTypeNumber andText:buf.description andOrigin:origin andEditable:YES];
				[newElement setTextTo:@"" animation:NO];
				[labels addObject:newElement];
			}
			if (count == 4) {
				newElement = [[NLElementView alloc]initWithType:ElementTypeRed andText:buf.description andOrigin:origin andEditable:NO];
			}
		[view_ addSubview:newElement];
		}
	}
	liteDescription = NSLocalizedString(@"INT_SQ_LITE_DESC", @"interesting square lite description");
}
@end
