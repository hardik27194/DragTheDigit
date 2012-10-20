//
//  Decimeters.m
//  Project2
//
//  Created by Алексей Гончаров on 10.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "Decimeters.h"

@implementation Decimeters


-(id) init {
	number0 = [[Element alloc] init];
	number1 = [[Element alloc] init];
	number2 = [[Element alloc] init];
	result = [[Element alloc] init];
	firstSign = [[SignElement alloc]init];
	secondSign = [[SignElement alloc]init];
	number0.typeOfValue = 1;
	number1.typeOfValue = 1;
	number2.typeOfValue = 1;
	result.typeOfValue = 1;
	variables = [[NSMutableArray alloc]init];
	signs = [[NSMutableArray alloc]init];
	labels = [[NSMutableArray alloc]init];
	return self;
}
-(id) initFromSolve:(Solve *)solve {
	self = [[Decimeters alloc]init];
	number0 = solve.number0;
	number0.typeOfValue = 1;
	number1 = solve.number1;
	number1.typeOfValue = 1;
	number2 = solve.number2;
	number2.typeOfValue = 1;
	result = solve.result;
	result.typeOfValue = 1;
	firstSign = solve.firstSign;
	secondSign = solve.secondSign;
	countOfVariables = solve.countOfVariables;
	return self;
}
-(id) initTens_UnitsFromSolve:(Solve *)solve {
	self = [[Decimeters alloc]init];
	number0 = solve.number0;
	number0.typeOfValue = 2;
	number1 = solve.number1;
	number1.typeOfValue = 2;
	number2 = solve.number2;
	number2.typeOfValue = 2;
	result = solve.result;
	result.typeOfValue = 2;
	firstSign = solve.firstSign;
	secondSign = solve.secondSign;
	countOfVariables = solve.countOfVariables;
	return self;
}
-(id) initWithDifficulty:(int)difficulty {
	int k;

	switch (difficulty) {
		case 0: {
	
			self = [[Decimeters alloc] init];
			fullDescription = NSLocalizedString(@"DECIMETERS_FULL_DESC_0", @"Decimeters full description");
			liteDescription = NSLocalizedString(@"DECIMETERS_LITE_DESC_0", @"Decimeters lite description");
			countOfVariables = 1;
			k = [Generator generateNewNumberWithStart:1 Finish:99];
			number0.value = k;
			result.value = k;
			int p  = [Generator generateNewNumberWithStart:0 Finish:1];
			if (p == 0) {
				result.centimetersOnly = YES;
			}
			else {
				number0.centimetersOnly = YES;
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 1: {

			self = [[Decimeters alloc] initFromSolve:[[Solve alloc]initWithDifficulty:7]];
			fullDescription = NSLocalizedString(@"DECIMETERS_FULL_DESC_1", @"Decimeters full description");

			number0.centimetersOnly = YES;
			number1.centimetersOnly = YES;
			secondSign.sign = 0;
			number2.value = result.value;
			result.centimetersOnly = NO;
			number2.centimetersOnly = YES;
			[self allBlanksNO];
			number2.blank = YES;
			if (number2.value >= 10) {
				countOfVariables = 3;
				result.blank = YES;
			}
			break;
		}
		case 2: {
			self = [[Decimeters alloc] initFromSolve:[[Solve alloc]initWithDifficulty:12]];
			fullDescription = NSLocalizedString(@"DECIMETERS_FULL_DESC_2", @"Decimeters full description");

			break;
		}
		case 3: {
			self = [[Decimeters alloc] initTens_UnitsFromSolve:[[Solve alloc]initWithDifficulty:11]];
			fullDescription = NSLocalizedString(@"DECIMETERS_FULL_DESC_3", @"Decimeters full description");

			break;
		}
		case 4: {
			self = [[Decimeters alloc] initTens_UnitsFromSolve:[[Solve alloc]initWithDifficulty:12]];
			fullDescription = NSLocalizedString(@"DECIMETERS_FULL_DESC_4", @"Decimeters full description");

			break;
		}
		case 5: {
			self = [[Decimeters alloc] initFromSolve:[[Solve alloc]initWithDifficulty:14]];
			fullDescription = NSLocalizedString(@"DECIMETERS_FULL_DESC_5", @"Decimeters full description");
			break;
		}
		case 6: {
			k = [Generator generateNewNumberWithStart:0 Finish:17];
			self = [[Decimeters alloc]initFromSolve:[[Solve alloc] initWithDifficulty:k]];
			fullDescription = NSLocalizedString(@"DECIMETERS_FULL_DESC_6", @"Decimeters full description");

			number0.typeOfValue = 1;
			number0.centimetersOnly = YES;
			number1.typeOfValue = 1;
			number1.centimetersOnly = YES;
			number2.typeOfValue = 1;
			number2.centimetersOnly = YES;
			result.typeOfValue = 1;
			result.centimetersOnly = YES;
		}
		default:
			break;
	}
	if (difficulty > 0) {
		liteDescription = NSLocalizedString(@"DECIMETERS_LITE_DESC_1-6", @"Decimeters lite description");

	}

	return self;
}
-(NSString*) description {
	if (countOfVariables == 1)
		return [[NSString alloc] initWithFormat:@"%@ = %@", number0, result];
	if (countOfVariables == 2)
		return [[NSString alloc] initWithFormat:@"%@ %@ %@ = %@", number0, firstSign, number1, result];
	
	return [[NSString alloc] initWithFormat:@"%@ %@ %@ %@ %@ = %@", number0, firstSign, number1, secondSign, number2, result];
}
-(BOOL) checkElementAnswerDecimeters:(int)dm Centimeters:(int)cm {
	if (countOfVariables == 1) {
		if (number0.blank) {
			return (10*dm+cm == number0.value);
		}
		if (result.blank) {
			return (10*dm+cm == result.value);
		}
	}
	if (countOfVariables == 2) {
		if (number0.blank) {
			return (10*dm+cm == number0.value);
		}
		if (number1.blank) {
			return (10*dm+cm == number1.value);
		}
		if (result.blank) {
			return (10*dm+cm == result.value);
		}
	}
	if (countOfVariables == 3) {
		if (number0.blank) {
			return (10*dm+cm == number0.value);
		}
		if (number1.blank) {
			return (10*dm+cm == number1.value);
		}
		if (number2.blank) {
			return (10*dm+cm == number2.value);
		}
		if (result.blank) {
			return (10*dm+cm == result.value);
		}
	}
	return NO;
}
-(BOOL) checkSignAnswer:(SignElement *)answer {
	if (countOfVariables == 2) {
		if (firstSign.blank) {
			return (answer == firstSign);
		}
	}
	if (countOfVariables == 3) {
		if (firstSign.blank) {
			return (answer == firstSign);
		}
		if (secondSign.blank) {
			return (answer == secondSign);
		}
	}
	return NO;
}

- (void)showSolveOnView:(UIView *)view_ {
		//prepearing
	needPlusminus = NO;
	[variables addObject:number0];
	if (countOfVariables > 1) {
		[signs addObject:firstSign];
		[variables addObject:number1];
	}
	if (countOfVariables > 2) {
		[signs addObject:secondSign];
		[variables addObject:number2];
	}
	[variables addObject:result];
	[signs addObject:[[SignElement alloc] initWithSign:0 Blank:NO]];
	int cNum = 0;
	int cVar = 0;
	int cSign = 0;
	int xOffset = 10;
	NSArray* values;
	CGPoint origin;
	NLElementView* newElement;
	for (int i = 0;  i < variables.count; ++i) {
		values =  [[[variables objectAtIndex:i] description] componentsSeparatedByString:@" "];
			//NSLog(@"%@", values);
		
		if (number0.value < 10 || number0.value%10 == 0) {
				//xOffset = 100;
		}
		for (int j = 0; j < values.count; ++j) {
			NSString* elementText = [values objectAtIndex:j];
			int caseNum = 0;
			if ([elementText isEqualToString:@"dm"] || [elementText isEqualToString:@"cm"] ||
				[elementText isEqualToString:@"tn"] || [elementText isEqualToString:@"un"]) {
				caseNum = 1;
			}
			switch (caseNum) {
				case 0: {
					origin = CGPointMake(xOffset + cNum*kNumber+cVar*kValueWidth + cSign*kSign, kViewCenterY - kNumber/2 + yOffset);
					newElement = [[NLElementView alloc]initWithType:ElementTypeNumber andText:elementText andOrigin:origin andEditable:[[variables objectAtIndex:i]blank]];
					++cNum;
					if ([[variables objectAtIndex:i] blank]) {
						[newElement setTextTo:@"" animation:NO];
						[labels addObject:newElement];
					}
					[view_ addSubview:newElement];
					break;
				}
				case 1: {
					if ([elementText isEqualToString:@"dm"]) {
						elementText = NSLocalizedString(@"DM", @"decimeters value");
					}
					if ([elementText isEqualToString:@"cm"]) {
						elementText = NSLocalizedString(@"CM", @"centimeters value");
					}
					if ([elementText isEqualToString:@"tn"]) {
						elementText = NSLocalizedString(@"TN", @"tens value");
					}
					if ([elementText isEqualToString:@"un"]) {
						elementText = NSLocalizedString(@"UN", @"units value");
					}
					origin = CGPointMake(xOffset + cNum*kNumber+cVar*kValueWidth  + cSign*kSign, kViewCenterY - kSign/2 + yOffset);
					newElement = [[NLElementView alloc]initWithType:ElementTypeValue andText:elementText andOrigin:origin];
					++cVar;
					
					
					[view_ addSubview:newElement];
					break;
				}
				default:
					break;
			}
		}
		if (i < signs.count) {
			NSString* sign = [[signs objectAtIndex:i] description];
			origin = CGPointMake(xOffset + cNum*kNumber+cVar*kValueWidth + cSign*kSign, kViewCenterY - kSign/2 + yOffset);
			newElement = [[NLElementView alloc]initWithType:ElementTypeSign andText:sign andOrigin:origin andEditable:[[signs objectAtIndex:i] blank]];
			++cSign;
			if ([[signs objectAtIndex:i] blank]) {
				needPlusminus = YES;
				[newElement setTextTo:@"" animation:NO];
				[labels addObject:newElement];
			}
			[view_ addSubview:newElement];
		}
	}
}
@end
