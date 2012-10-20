//
//  Decimeters.h
//  Project2
//
//  Created by Алексей Гончаров on 10.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Solve.h"
#import "decimeterElement.h"

@interface Decimeters: Solve 



-(id) initFromSolve:(Solve*) solve;
-(id) initTens_UnitsFromSolve:(Solve *)solve;
-(id) initWithDifficulty:(int) difficulty;
-(BOOL) checkElementAnswerDecimeters:(int) dm
						 Centimeters: (int) cm;
-(BOOL) checkSignAnswer:(SignElement*) answer;
-(NSString*) description;
@end
