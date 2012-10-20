//
//  InterestingSquare.h
//  Project2
//
//  Created by Алексей Гончаров on 25.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Generator.h"
#import "Element.h"
@interface InterestingSquare : NSObject {
	NSArray* elements;
}
@property NSString* fullDescription, *liteDescription;

@property NSMutableArray* labels;
- (id)initWithCentre:(int)centre;
- (id)initWithDifficulty:(int)difficulty;
- (void)showSolveOnView:(UIView*) view_;
@end
