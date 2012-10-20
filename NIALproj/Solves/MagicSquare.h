//
//  MagicSquare.h
//  Project2
//
//  Created by Алексей Гончаров on 23.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

// Интерфейс initWithDifficulty: (int) difficuty // диапазон [0..2]

#import <Foundation/Foundation.h>
#import "Generator.h"
#import "Element.h"


@interface MagicSquare : NSObject
{
	NSMutableArray *numbers;
}
@property NSMutableArray *labels;
@property NSString* fullDescription, *liteDescription;

-(id) initWithIncreasing: (int) arg;
-(id) initWithDifficulty: (int) difficulty;
-(void) rotate;
-(void) increaseOnNumber: (int) arg;
-(BOOL) checkSolving: (int*) answers;
-(void) setBlankAtIndex: (int) index;
-(void) deleteBlankAtIndex: (int) index;
-(void) setRandomBlanks;
-(void) print;
-(Element*) elementAtIndex: (int) index;

- (void)showSolveOnView:(UIView*) view_;
@end

