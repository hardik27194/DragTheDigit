//
//  Comparator.h
//  Project2
//
//  Created by Алексей Гончаров on 17.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Solve.h"

@interface Comparator : NSObject {
	Element *leftNumber0, *leftNumber1, *leftNumber2, *rightNumber0, *rightNumber1, *rightNumber2;
	SignElement *sign, *leftFirstSign, *rightFirstSign, *leftSecondSign, *rightSecondSign;
	int countOfVariables;
	NSString* liteDescription;
}
@property NSMutableArray* labels;
@property int countOfVariables;
@property NSString* fullDescription, *liteDescription;

- (id)initCompareSolveWithDifficulty: (int) difficulty;
- (id)initEquationWithDifficulty: (int) difficulty;
- (void)setLeftSolve: (Solve*) solve;
- (void)setRightSolve: (Solve*) solve;
- (NSString*)description;

- (void)showSolveOnView:(UIView*) view_;
@end
