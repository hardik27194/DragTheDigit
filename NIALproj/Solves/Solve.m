//
//  Solve.m
//  Project2
//
//  Created by Алексей Гончаров on 22.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "Solve.h"

@implementation Solve
@synthesize variables, signs;
@synthesize number0;
@synthesize number1;
@synthesize number2;
@synthesize result;
@synthesize firstSign;
@synthesize secondSign;
@synthesize countOfVariables;
@synthesize page, labels, answers, typeOfSolve, needPlusminus, fullDescription, liteDescription;

-(void) allBlanksNO {
	number0.blank = NO;
	firstSign.blank = NO;
	secondSign.blank = NO;
	number1.blank = NO;
	number2.blank = NO;
	result.blank = NO;
}
-(id) init {
    if (self = [super init]) {
		variables = [[NSMutableArray alloc] initWithCapacity:3];
		signs = [[NSMutableArray alloc] initWithCapacity:2];
		placeOfBrackets = 0;
		number1 = [[Element alloc]init];
		number0 = [[Element alloc]init];
        number2 = [[Element alloc] init];
		result = [[Element alloc]init];
		firstSign = [[SignElement alloc]init];
		secondSign = [[SignElement alloc] init];
		countOfVariables = 2;
		labels = [[NSMutableArray alloc] init];
		typeOfSolve = YES;
	}
    return self;
}
-(id) initWithResult:(int)res Sign:(int)sgn {
	self = [[Solve alloc]init];
	placeOfBrackets = 0;
	countOfVariables = 2;
	result.value = res;
	firstSign.sign = sgn;
	if (sgn == 1) {
		number0.value = [Generator generateNewNumberWithStart:0 Finish:res];
		number1.value = res - number0.value;
		
	}
	else {
		number0.value = [Generator generateNewNumberWithStart:res Finish:99];
		number1.value = number0.value - res;
	}
	return self;
}
-(id) initWithCountOfNumbers:(int)numbers {
	placeOfBrackets = 0;
	Solve* buf = [[Solve alloc] init];
	if (numbers == 2) {
		return buf;
	}
	if (numbers == 3) {
		buf.secondSign.blank = NO;
		buf.number2.blank = NO;
		return buf;
	}
	return buf;
}
-(void)setBlankAtIndex: (int) index {
    switch (index) {
        case 0:
            number0.blank = YES;
            break;
        case 1:
            firstSign.blank = YES;
            break;
        case 2 :
            number1.blank = YES;
			break;
		case 3 :
            secondSign.blank = YES;
			break;
		case 4 :
            number2.blank = YES;
			break;
		case 5 :
            result.blank = YES;
			break;
        default:
            break;
    }
}
-(void)setRandomBlanksOnNumbers {
	[self allBlanksNO];
	if (countOfVariables == 1) {
		int k = [Generator generateNewNumberWithStart:0 Finish:0];
		switch (k) {
			case 0:
				[self setBlankAtIndex:0];
				return;
			case 1:
				[self setBlankAtIndex:5];
				return;
			default:
				return;
		}
	}
	if (countOfVariables == 2) {
		int k = [Generator generateNewNumberWithStart:0 Finish:2];
		switch (k) {
			case 0:
				[self setBlankAtIndex:0];
				break;
			case 1:
				[self setBlankAtIndex:2];
				break;
			case 2:
				[self setBlankAtIndex:5];
				break;				
			default:
				break;
		}
	}
	else {
		int k = [Generator generateNewNumberWithStart:0 Finish:3];
		switch (k) {
			case 0:
				[self setBlankAtIndex:0];
				break;
			case 1:
				[self setBlankAtIndex:2];
				break;
			case 2:
				[self setBlankAtIndex:4];
				break;
			case 3:
				[self setBlankAtIndex:5];
				break;				
			default:
				break;
		}
	}
}
-(void)setRandomBlanksOnSigns {
	[self allBlanksNO];
	int k = [Generator generateNewNumberWithStart:0 Finish:1];
	switch (k) {
		case 0:
			[self setBlankAtIndex:1];
      if (number1.value == 0) firstSign.beforeNull = YES;
			break;
		case 1:
			[self setBlankAtIndex:3];
      if (number2.value == 0) secondSign.beforeNull = YES;
			break;
		default:
			break;
	}
}
-(id)initWithDifficulty:(int)difficulty {
	self = [[Solve alloc]init];
	placeOfBrackets = 0;
	countOfVariables = 2;
	int k;
	liteDescription = NSLocalizedString(@"SOLVE_LITE_DESC", @"Solve lite description");
	NSString* slldesc = [NSString stringWithString:liteDescription];
	switch (difficulty) {
		case 0: {
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_0", @"Solve full description");
			countOfVariables = 2;	
			result.value = [Generator generateNewNumberWithStart:1 Finish:9];
			number0.value = [Generator generateNewNumberWithStart:1 Finish:9];
			if (result.value > number0.value) {
				firstSign.sign = 1;
				number1.value = result.value - number0.value;
			}
			else if (result.value < number0.value) {
				firstSign.sign = 2;
				number1.value = number0.value - result.value;
			}
			else {
				firstSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 1: {
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_1", @"Solve full description");
			countOfVariables = 3;
			result.value = [Generator generateNewNumberWithStart:1 Finish:9];
			number0.value = [Generator generateNewNumberWithStart:1 Finish:9];
			if (number0.value == 10) {
				firstSign.sign = 2;
				
			}
			else {
				firstSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
			}
			if (firstSign.sign == 1) {
				number1.value = [Generator generateNewNumberWithStart:1 Finish:10 - number0.value];
				k = number0.value + number1.value;
				k = result.value - k;
				if (k > 0 ) {
					secondSign.sign = 1;
				} else if (k < 0) {
					secondSign.sign = 2;
				}
				else {
					secondSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
				}
				number2.value = abs(k);
			} else {
				number1.value = [Generator generateNewNumberWithStart:1 Finish:number0.value];
				k = number0.value - number1.value;
				k = result.value - k;
				if (k > 0 ) {
					secondSign.sign = 1;
				} else if (k < 0) {
					secondSign.sign = 2;
				}
				else {
					secondSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
				}
				number2.value = abs(k);
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 2: {
			self = [[Solve alloc]initWithDifficulty:1];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_2", @"Solve full description");
			liteDescription = NSLocalizedString(@"SOLVE_LITE_DESC_2", @"Solve lite description");
			[self setRandomBlanksOnSigns];
			typeOfSolve = NO;
			break;
		}
		case 3: {
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_3", @"Solve full description");
			countOfVariables = 2;
			number0.value = [Generator generateNewNumberWithStart:10 Finish:20];
			result.value = [Generator generateNewNumberWithStart:10 Finish:20];
			k = result.value - number0.value;
			number1.value = abs(k);
			if (k > 0 ) {
				firstSign.sign = 1;
			} else if (k < 0) {
				firstSign.sign = 2;
			}
			else {
				firstSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 4: {
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_4", @"Solve full description");
			countOfVariables = 2;
			switch ([Generator generateNewNumberWithStart:0 Finish:1]) {
				case 0:
					number0.value = [Generator generateNewNumberWithStart:0 Finish:9];
					result.value = [Generator generateNewNumberWithStart:11 Finish:20];
					firstSign.sign = 1;
					number1.value = result.value - number0.value;
					break;
				case 1:
					number0.value = [Generator generateNewNumberWithStart:11 Finish:20];
					result.value = [Generator generateNewNumberWithStart:0 Finish:9];
					firstSign.sign = 2;
					number1.value = number0.value - result.value;
					break;
				default:
					break;
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 5: {
			self = [[Solve alloc] initWithDifficulty:4];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_5", @"Solve full description");
			countOfVariables = 3;
			if (firstSign.sign == 2) {
				number1.value = [Generator generateNewNumberWithStart:0 Finish:number0.value];
				k = result.value - (number0.value - number1.value);
				number2.value = abs(k);
				if (k > 0 ) {
					secondSign.sign = 1;
				} else if (k < 0) {
					secondSign.sign = 2;
				}
				else {
					secondSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
				}
			}
			else {
				number1.value = [Generator generateNewNumberWithStart:0 Finish:20 - number0.value];
				k = result.value - (number0.value + number1.value);
				number2.value = abs(k);
				if (k > 0 ) {
					secondSign.sign = 1;
				} else if (k < 0) {
					secondSign.sign = 2;
				}
				else {
					secondSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
				}
			}
			break;
		}
		case 6: {
			self = [[Solve alloc] initWithDifficulty:5];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_6", @"Solve full description");
			liteDescription = NSLocalizedString(@"SOLVE_LITE_DESC_6", @"Solve lite description");
			[self setRandomBlanksOnSigns];
			typeOfSolve = NO;
			break;
		}
		case 7: {
			self = [[Solve alloc] initWithDifficulty:0];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_7", @"Solve full description");
			number0.value*=10;
			number1.value*=10;
			result.value*=10;
			countOfVariables = 2;
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 8: {
			self = [[Solve alloc] initWithDifficulty:1];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_8", @"Solve full description");
			number0.value*=10;
			number1.value*=10;
			number2.value*=10;
			result.value*=10;
			countOfVariables = 3;
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 9: {
			self = [[Solve alloc]initWithDifficulty:7];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_9", @"Solve full description");
			liteDescription = NSLocalizedString(@"SOLVE_LITE_DESC_9", @"Solve lite description");
			[self allBlanksNO];
			firstSign.blank = YES;
				//[self setRandomBlanksOnSigns];
			break;
		}
		case 10: {
			self = [[Solve alloc]initWithDifficulty:8];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_10", @"Solve full description");
			liteDescription = NSLocalizedString(@"SOLVE_LITE_DESC_10", @"Solve lite description");
			[self setRandomBlanksOnSigns];
			typeOfSolve = NO;
			break;
		}
		case 11: {
			self = [[Solve alloc] initWithDifficulty:0];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_11", @"Solve full description");

			k = [Generator generateNewNumberWithStart:2 Finish:9];
			k*=10;
			number0.value+=k;
			result.value+=k;
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 12: {
			self = [[Solve alloc] initWithDifficulty:0];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_12", @"Solve full description");
			int p;
			if (firstSign.sign ==2 ) {
				k = [Generator generateNewNumberWithStart:2 Finish:9];
				number0.value+=10*k;
				p = [Generator generateNewNumberWithStart:2 Finish:k];
				number1.value+=10*p;
				result.value+=10*(k-p);
			}
			else {
				k = [Generator generateNewNumberWithStart:2 Finish:8];
				number0.value+=10*k;
				p = [Generator generateNewNumberWithStart:1 Finish:9 - k];
				number1.value+=10*p;
				result.value+=10*(p+k);
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 13: {
				//Порядок действий в примерах со скобками
			liteDescription = NSLocalizedString(@"SOLVE_LITE_DESC_13", @"Solve lite description");
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_13", @"Solve full description");

			countOfVariables = 3;
			placeOfBrackets = [Generator generateNewNumberWithStart:1 Finish:2];
			int k = [Generator generateNewNumberWithStart:0 Finish:3];
			if (k == 0) {
				k = 4;
			} else if (k == 1) {
				k = 7;
			} else if (k == 2) {
				k = 11;
			} else {
				k = 12;
			}
			Solve* buf = [[Solve alloc] initWithDifficulty:k];
			if (placeOfBrackets == 1) {
				number0 = buf.number0;
				firstSign = buf.firstSign;
				number1 = buf.number1;
				secondSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
				if (secondSign.sign == 1) {
					number2.value = [Generator generateNewNumberWithStart:0 Finish:99 - buf.result.value];
					result.value = buf.result.value + number2.value;
				}
				else {
					number2.value = [Generator generateNewNumberWithStart:0 Finish:buf.result.value];
					result.value = buf.result.value - number2.value;
				}
			}
			else {
				number1 = buf.number0;
				secondSign = buf.firstSign;
				number2 = buf.number1;
				firstSign.sign  = [Generator generateNewNumberWithStart:1 Finish:2];
				if (firstSign.sign == 1) {
					number0.value = [Generator generateNewNumberWithStart:0 Finish:99 - buf.result.value];
					result.value = buf.result.value + number0.value;
				}
				else {
					number0.value = [Generator generateNewNumberWithStart:buf.result.value Finish:99];
					result.value = number0.value - buf.result.value;
				}
			}
			[self allBlanksNO];
			result.blank = YES;
			break;
		}
		case 14: {
				//Сложение с получением круглой суммы. Вычитание из круглого двузначного числа
			k = [Generator generateNewNumberWithStart:0 Finish:1];
			self = [[Solve alloc] initWithResult:10 Sign:1];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_14", @"Solve full description");
			liteDescription = slldesc;
			int p = [Generator generateNewNumberWithStart:0 Finish:8];
			number0.value += 10*p;
			result.value *= p;
			p = [Generator generateNewNumberWithStart:0 Finish:8 - p];
			number1.value += 10*p;
			result.value += 10*(p+1);
			if (k == 1) {
				Element* buf = result;
				result = number0;
				number0 = buf;
				firstSign = [[SignElement alloc] initWithSign:2 Blank:NO];
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 15: {
			self = [[Solve alloc] initWithDifficulty:5];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_15", @"Solve full description");
			liteDescription = NSLocalizedString(@"SOLVE_LITE_DESC_15", @"Solve lite description");

			k = [Generator generateNewNumberWithStart:0 Finish:8];
			number0.value += 10*k;
			int p = [Generator generateNewNumberWithStart:0 Finish:8-k];
			if (firstSign.sign == 1) {
				number1.value += 10*p;
			}
			else if (secondSign.sign == 1) {
				number2.value += 10*p;
			}
			else {
				p = 0;
			}
			result.value += 10*(p+k);
			do {
				[self setRandomBlanksOnNumbers];
			} while (number0.blank || result.blank);
			if (number1.blank) {
				firstSign.blank = YES;
			}
			if (number2.blank) {
				secondSign.blank = YES;
			}
			break;
		}
		case 16: {
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_16", @"Solve full description");

			number0.value = [Generator generateNewNumberWithStart:21 Finish:88];
			firstSign.sign = [Generator generateNewNumberWithStart:1 Finish:2];
			if (firstSign.sign == 1) {
				number1.value = [Generator generateNewNumberWithStart:11 - number0.value%10 Finish:9];
				result.value = number0.value + number1.value;
			}
			else {
				number1.value = [Generator generateNewNumberWithStart:number0.value%10 + 1 Finish:9];
				result.value = number0.value - number1.value;
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		case 17: {
			self = [[Solve alloc] initWithDifficulty: 16];
			fullDescription = NSLocalizedString(@"SOLVE_FULL_DESC_17", @"Solve full description");
			if (firstSign.sign == 1) {
				k = [Generator generateNewNumberWithStart: 1 Finish: 9 - number0.value/10];
				number1.value += 10*(k-1);
				result.value += 10*(k-1);
			}
			else {
				k = [Generator generateNewNumberWithStart:0 Finish:number0.value/10 - 1];
				number1.value += 10*k;
				result.value -= 10*k;
			}
			[self setRandomBlanksOnNumbers];
			break;
		}
		default:
			break;
	}
	return self;
}
-(NSString *)description {
	if (placeOfBrackets == 0) {
		if (countOfVariables == 2) {
			return  [[NSString alloc]initWithFormat:@"%@\t%@\t%@\t=\t%@", number0, firstSign, number1, result];
		}
		else {
			return  [[NSString alloc]initWithFormat:@"%@\t%@\t%@\t%@\t%@\t=\t%@", number0, firstSign, number1, secondSign, number2, result];
		}
	}
	else if (placeOfBrackets == 1) {
		return  [[NSString alloc]initWithFormat:@"(%@\t%@\t%@)\t%@\t%@=\t%@", number0, firstSign, number1, secondSign, number2, result];
	}
		else {
			return  [[NSString alloc]initWithFormat:@"%@\t%@\t(%@\t%@\t%@)= %@", number0, firstSign, number1, secondSign, number2, result];
		}
	return @" ";
}
-(BOOL) checkElementAnswer:(Element*) answer {
    if (number0.blank) {
        if(number0==answer) return YES;
    }
    if (number1.blank) {
        if(number1==answer) return YES;
    }
    if (number2.blank) {
        if(number2==answer) return YES;
    }
	if (result.blank) {
        if(result==answer) return YES;
    }
    return NO;
}
-(BOOL) checkSignAnswer:(SignElement*) answer {
	if (firstSign.blank) {
        if(firstSign==answer) return YES;
    }
	if (secondSign.blank) {
        if(secondSign==answer) return YES;
    }
	return NO;
}

-(void) showSolveOnView:(UIView *)view_ {
		//prepearing
	needPlusminus = NO;
	[variables addObject:number0];
	[signs addObject:firstSign];
	[variables addObject:number1];
	if (countOfVariables == 3) {
		[signs addObject:secondSign];
		[variables addObject:number2];
	}
	[variables addObject:result];
	[signs addObject:[[SignElement alloc] initWithSign:0 Blank:NO]];
	answers = [[NSMutableArray alloc] init];

		//NSLog(@"%@\n%@", variables, signs);
		//creating labels
		//view_.backgroundColor = [UIColor underPageBackgroundColor];
	for (int i = 0; i < variables.count; ++i) {
		Element* num = [variables objectAtIndex:i];
		NLElementView* element = [[NLElementView alloc] initWithType:ElementTypeNumber andText:num.description andOrigin:CGPointMake(kLeftBoarder + i*(kNumber + kSign), kViewCenterY - kNumber/2 + yOffset) andEditable:num.blank];
		element.tag = 100+i;
		if (num.blank) {
			NSString* answer = element._text;
			[answers addObject:answer];
			[labels addObject:element];
			[element setTextTo:@"" animation:NO];
		}
		[view_ addSubview:element];
	}
	for (int i = 0; i < signs.count; ++i) {
    SignElement *numnum = [signs objectAtIndex:i];
		Element* num = [signs objectAtIndex:i];
		NLElementView* element = [[NLElementView alloc] initWithType:ElementTypeSign andText:num.description andOrigin:CGPointMake(kLeftBoarder + kNumber + i*(kNumber + kSign), kViewCenterY - kSign/2 + yOffset)andEditable:num.blank];
		element.tag = 100+i;
    if (numnum.beforeNull) element.beforeNull = YES;
		if (num.blank) {
			needPlusminus = YES;
			NSString* answer = element._text;
			[answers addObject:answer];
			[labels addObject:element];
			[element setTextTo:@"" animation:NO];
		}
		[view_ addSubview:element];
	}
	if (placeOfBrackets > 0) {
		if (placeOfBrackets == 1) {
			CGRect rect = CGRectMake(kLeftBoarder - 5, kViewCenterY - kNumber/2 + yOffset-10, 40, kNumber);
			UILabel* bracket = [[UILabel alloc] initWithFrame:rect];
			bracket.text = @"(";
			[bracket setTextAlignment:UITextAlignmentLeft];
			[bracket setFont:[UIFont fontWithName:@"Verdana" size:kNumberFontSize]];
			bracket.backgroundColor = [UIColor clearColor];
			[view_ addSubview:bracket];
			rect = CGRectMake(kLeftBoarder + 2*kNumber + kSign/3 + 6, kViewCenterY - kNumber/2 + yOffset-10, 40, kNumber);
			bracket = [[UILabel alloc] initWithFrame:rect];
			bracket.text = @")";
			[bracket setTextAlignment:UITextAlignmentLeft];
			[bracket setFont:[UIFont fontWithName:@"Verdana" size:kNumberFontSize]];
			bracket.backgroundColor = [UIColor clearColor];
			[view_ addSubview:bracket];
		}
		else {
			CGRect rect = CGRectMake(kLeftBoarder - 5 + kNumber + kSign, kViewCenterY - kNumber/2 + yOffset-10, 40, kNumber);
			UILabel* bracket = [[UILabel alloc] initWithFrame:rect];
			bracket.text = @"(";
			[bracket setTextAlignment:UITextAlignmentLeft];
			[bracket setFont:[UIFont fontWithName:@"Verdana" size:kNumberFontSize]];
			bracket.backgroundColor = [UIColor clearColor];
			[view_ addSubview:bracket];
			rect = CGRectMake(kLeftBoarder + 3*kNumber + 4*kSign/3 + 6, kViewCenterY - kNumber/2 + yOffset-10, 40, kNumber);
			bracket = [[UILabel alloc] initWithFrame:rect];
			bracket.text = @")";
			[bracket setTextAlignment:UITextAlignmentLeft];
			[bracket setFont:[UIFont fontWithName:@"Verdana" size:kNumberFontSize]];
			bracket.backgroundColor = [UIColor clearColor];
			[view_ addSubview:bracket];

		}
	}

}

@end