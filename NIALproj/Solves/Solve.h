//
//  Solve.h
//  Project2
//
//  Created by Алексей Гончаров on 22.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"
#import "SignElement.h"
#import "NLElementView.h"
#import "Generator.h"
#import "Constants.h"

@interface Solve : NSObject {
	int placeOfBrackets;
	int countOfVariables;
	Element* number0, *number1, *number2, *result;
	SignElement* firstSign, *secondSign;
	NSMutableArray* variables, *signs;
	NSMutableArray* labels, *answers;
	BOOL needPlusminus;
	NSString* fullDescription, *liteDescription;
}
@property NSMutableArray* variables, *signs;
@property Element* number0;
@property Element* number1;
@property Element* number2;
@property Element* result;
@property SignElement* firstSign;
@property SignElement* secondSign;
@property int countOfVariables;
@property UIView* page;
@property BOOL typeOfSolve; // NO = signs; YES = numbers;
@property NSMutableArray* labels, *answers;
@property BOOL needPlusminus;
@property NSString* fullDescription, *liteDescription;

- (id)init;
- (id)initWithResult: (int) res Sign: (int)sgn;
- (id)initWithCountOfNumbers:(int) numbers;
- (NSString*)description;
- (void)allBlanksNO;
- (BOOL)checkElementAnswer:(Element*) answer;
- (BOOL)checkSignAnswer:(SignElement*) answer;
- (void)setBlankAtIndex: (int) index;
- (void)setRandomBlanksOnNumbers;
- (void)setRandomBlanksOnSigns;


	//interface
- (id)initWithDifficulty:(int)difficulty;
- (void)showSolveOnView: (UIView*) view_;

@end
