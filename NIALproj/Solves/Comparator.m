//
//  Comparator.m
//  Project2
//
//  Created by Алексей Гончаров on 17.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "Comparator.h"

@implementation Comparator

@synthesize countOfVariables;
@synthesize labels, fullDescription,liteDescription;

- (id)init {
	labels = [[NSMutableArray alloc]init];
	leftNumber0 = [[Element alloc]init];
	leftNumber1 = [[Element alloc]init];
	leftNumber2 = [[Element alloc]init];
	rightNumber0 = [[Element alloc]init];
	rightNumber1 = [[Element alloc]init];
	rightNumber2 = [[Element alloc]init];
	sign = [[SignElement alloc]init];
	leftFirstSign = [[SignElement alloc]init];
	leftSecondSign = [[SignElement alloc]init];
	rightFirstSign = [[SignElement alloc]init];
	rightSecondSign = [[SignElement alloc]init];
	countOfVariables = 2;
	return self;
}
- (id)initEquationWithDifficulty:(int)difficulty {
	self = [[Comparator alloc]init];
	liteDescription = NSLocalizedString(@"EQUATION_LITE_DESC", @"Equation lite description");
	fullDescription = NSLocalizedString(@"EQUATION_FULL_DESC", @"Equation full description");
	Solve *left;
	int leftDiff;
	switch (difficulty) {
		case 0:
			leftDiff = 0;
			break;
		case 1:
			leftDiff = 3;
			break;
		case 2:
			leftDiff = 4;
			break;
		case 3:
			leftDiff = 5;
			break;
		case 4:
			leftDiff = 11;
			break;
		case 5:
			leftDiff = 12;
			break;
		case 6:
			leftDiff = 14;
			break;
		case 7:
			leftDiff = 16;
			break;
		case 8:
			leftDiff = 17;
			break;
		default:
			break;
	}
	left = [[Solve alloc]initWithDifficulty:leftDiff];

	countOfVariables = left.countOfVariables;
	leftNumber0 = left.number0;
	leftNumber1 = left.number1;
	leftNumber2 = left.number2;
	leftFirstSign = left.firstSign;
	leftSecondSign = left.secondSign;
	Solve *right;
	do {
		right = [[Solve alloc]initWithDifficulty:leftDiff];
	} while (right.result.value != left.result.value);
	rightNumber0 = right.number0;
	rightNumber1 = right.number1;
	rightNumber2 = right.number2;
	rightFirstSign = right.firstSign;
	rightSecondSign = right.secondSign;
	sign.sign = 0;
	[self allBlanksNO];
	
	
	
	switch ([Generator generateNewNumberWithStart:0 Finish:3]) {
		case 0:
			leftNumber0.blank = YES;
			break;
		case 1:
			leftNumber1.blank = YES;
			break;
		case 2:
			rightNumber0.blank = YES;
			break;
		case 3:
			rightNumber1.blank = YES;
			break;
		default:
			break;
	}
	return self;
}
- (void)setLeftSolve: (Solve*) solve {
	leftNumber0 = solve.number0;
	leftNumber1 = solve.number1;
	leftNumber2 = solve.number2;
	countOfVariables = solve.countOfVariables;
	leftFirstSign = solve.firstSign;
	leftSecondSign = solve.secondSign;
}
- (void)setRightSolve: (Solve*) solve {
	rightNumber0 = solve.number0;
	rightNumber1 = solve.number1;
	rightNumber2 = solve.number2;
	rightFirstSign = solve.firstSign;
	rightSecondSign = solve.secondSign;
}
- (id)initCompareSolveWithDifficulty:(int)difficulty {
	self = [[Comparator alloc]init];
	liteDescription = NSLocalizedString(@"COMPARATOR_LITE_DESC", @"Comparator lite description");
	fullDescription = NSLocalizedString(@"COMPARATOR_FULL_DESC", @"Comparator full description");
	switch (difficulty) {
		case 0:
			difficulty = 0;
			break;
		case 1:
			difficulty = 1;
			break;
		case 2:
			difficulty = 3;
			break;
		case 3:
			difficulty = 4;
			break;
		case 4:
			difficulty = 5;
			break;
		case 5:
			difficulty = 7;
			break;
		case 6:
			difficulty = 8;
			break;
		case 7:
			difficulty = 11;
			break;
		case 8:
			difficulty = 12;
			break;
		case 9:
			difficulty = 14;
			break;
		case 10:
			difficulty = 15;
			break;
		case 11:
			difficulty = 16;
			break;
		case 12:
			difficulty = 17;
			break;
		default:
			break;
	}
	Solve *solve1 = [[Solve alloc]initWithDifficulty:difficulty];
	Solve *solve2 = [[Solve alloc]initWithDifficulty:difficulty];
	[self setLeftSolve:solve1];
	[self setRightSolve:solve2];
	int leftr = solve1.result.value;
	int rightr = solve2.result.value;

	if (leftr > rightr) {
		sign.sign = 3;
	} else if (leftr < rightr) {
		sign.sign = 4;
	} else {
		sign.sign = 0;
	}
	[self allBlanksNO];
	sign.blank = YES;
	return self;
}
- (void)allBlanksNO {
	leftNumber0.blank = NO;
	leftNumber1.blank = NO;
	leftNumber2.blank = NO;
	rightNumber0.blank = NO;
	rightNumber1.blank = NO;
	rightNumber2.blank = NO;
	sign.blank = NO;
	leftFirstSign.blank = NO;
	leftSecondSign.blank = NO;
	rightFirstSign.blank = NO;
	rightSecondSign.blank = NO;
}
- (NSString*)description {
	if (countOfVariables == 2) {
		return [[NSString alloc] initWithFormat:@"%@ %@ %@ %@ %@ %@ %@", leftNumber0, leftFirstSign,
		leftNumber1, sign, rightNumber0, rightFirstSign, rightNumber1 ];
	}
	return [[NSString alloc] initWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",
			leftNumber0, leftFirstSign,leftNumber1, leftSecondSign,leftNumber2, sign, 
			rightNumber0, rightFirstSign, rightNumber1, rightSecondSign, rightNumber2];
}

- (void)showSolveOnView: (UIView*) view_ {
	int xOffset = kViewCenterX - countOfVariables*kNumber - (countOfVariables - 1)*kSign - kSign/2;
	NLElementView* newElement;
	NSMutableArray* numbers = [[NSMutableArray alloc]initWithObjects:leftNumber0, leftNumber1, nil];
	NSMutableArray* signs = [[NSMutableArray alloc]initWithObjects:leftFirstSign, nil];
	if (countOfVariables == 3) {
		[signs addObject:leftSecondSign];
		[numbers addObject:leftNumber2];
	}
	[numbers addObjectsFromArray:[NSArray arrayWithObjects:rightNumber0, rightNumber1, nil]];
	[signs addObjectsFromArray:[NSArray arrayWithObjects:sign, rightFirstSign, nil]];
	if (countOfVariables == 3) {
		[signs addObject:rightSecondSign];
		[numbers addObject:rightNumber2];
	}
	CGPoint originNumber = CGPointMake(xOffset, kViewCenterY + yOffset - kNumber/2);
	CGPoint originSign = CGPointMake(xOffset + kNumber, kViewCenterY + yOffset - kSign/2);
	for (int i = 0; i < numbers.count; ++i) {
		Element* buf = [numbers objectAtIndex:i];
		newElement = [[NLElementView alloc]initWithType:ElementTypeNumber andText:buf.description andOrigin:originNumber andEditable:buf.blank];
		originNumber.x += kNumber + kSign;
		if (buf.blank) {
			[newElement setTextTo:@"" animation:NO];
			[labels addObject:newElement];
		}
		[view_ addSubview:newElement];
	}
	for (int i = 0; i < signs.count; ++i) {
		SignElement* buf = [signs objectAtIndex:i];
		newElement = [[NLElementView alloc]initWithType:ElementTypeSign andText:buf.description andOrigin:originSign andEditable:buf.blank];
		originSign.x += kNumber + kSign;
		if (buf.blank) {
			[newElement setTextTo:@"" animation:NO];
			[labels addObject:newElement];
		}
		[view_ addSubview:newElement];
	}
}
@end
