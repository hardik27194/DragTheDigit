//
//  MagicSquare.m
//  Project2
//
//  Created by Алексей Гончаров on 23.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "MagicSquare.h"
#import "NLElementView.h"

@implementation MagicSquare
@synthesize labels, fullDescription, liteDescription;

-(id) init {
	if (self = [super init]) {
		fullDescription = NSLocalizedString(@"MAG_SQ_FULL_DESC", @"FullDescription magic square");
		numbers = [[NSMutableArray alloc] init];
		[numbers addObject: [[Element alloc] initWithValue:4 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:9 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:2 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:3 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:5 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:7 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:8 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:1 Blank:NO]];
		[numbers addObject: [[Element alloc] initWithValue:6 Blank:NO]];	
	}
	return self;
}
-(id) initWithIncreasing:(int)arg {
	MagicSquare *buf = [[MagicSquare alloc] init];
	int rotatesCount = [Generator generateNewNumberWithStart:0 Finish:3];
	for (int i = 0; i <= rotatesCount; ++i) {
		[buf rotate];
	}
	[buf increaseOnNumber:arg];
	return buf;	
}
-(id) initWithDifficulty:(int)difficulty {
	MagicSquare *buf =[[MagicSquare alloc]init];
	if (difficulty == 0) {
		buf = [[MagicSquare alloc] initWithIncreasing:0];
		buf.fullDescription = [buf.fullDescription stringByAppendingString:NSLocalizedString(@"MAG_SQ_FULL_DESC_ADD_0", @"Addition magic square FullDescription")];
	}
	if (difficulty == 1) {
		buf = [[MagicSquare alloc] initWithIncreasing:[Generator generateNewNumberWithStart:1 Finish:11]];
		buf.fullDescription = [buf.fullDescription stringByAppendingString:NSLocalizedString(@"MAG_SQ_FULL_DESC_ADD_1", @"Addition magic square FullDescription")];
	}
	if (difficulty == 2) {
		buf = [[MagicSquare alloc] initWithIncreasing:[Generator generateNewNumberWithStart:12 Finish:90]];
		buf.fullDescription = [buf.fullDescription stringByAppendingString:NSLocalizedString(@"MAG_SQ_FULL_DESC_ADD_2", @"Addition magic square FullDescription")];
	} 
	self = buf;
	[self setRandomBlanks];
	return self;
}
-(void) rotate {
	NSMutableArray *buf = [[NSMutableArray alloc] init];
	[buf addObject: [numbers objectAtIndex:6]];
	[buf addObject: [numbers objectAtIndex:3]];
	[buf addObject: [numbers objectAtIndex:0]];
	[buf addObject: [numbers objectAtIndex:7]];
	[buf addObject: [numbers objectAtIndex:4]];
	[buf addObject: [numbers objectAtIndex:1]];
	[buf addObject: [numbers objectAtIndex:8]];
	[buf addObject: [numbers objectAtIndex:5]];
	[buf addObject: [numbers objectAtIndex:2]];
	numbers = buf;
}
-(void) increaseOnNumber:(int)arg {
	for (int i = 0; i < 9; ++i) {
		Element *buf = [numbers objectAtIndex:i];
		buf.value += arg;
		[numbers replaceObjectAtIndex:i withObject: buf];
	}
	
}
-(BOOL) checkSolving:(int*) answers {
	int k = 0;
	BOOL result = YES;
	for (int i = 0; i < 9; ++i) {
		Element *buf = [numbers objectAtIndex:i];
		if (buf.blank) {
			if (buf.value == answers[k]) {
				++k;
			}
			else
				result = NO;
		}
	}
	return result;
}
-(void) setBlankAtIndex:(int)index {
	Element *buf = [numbers objectAtIndex:index];
	int buffer = buf.value;
	[numbers replaceObjectAtIndex:index withObject:[[Element alloc]initWithValue:buffer
																		   Blank:YES]];
}
-(void) deleteBlankAtIndex:(int)index {
	Element *buf = [numbers objectAtIndex:index];
	int buffer = buf.value;
	[numbers replaceObjectAtIndex:index withObject:[[Element alloc]initWithValue:buffer
																		   Blank:NO]];
}
-(void) setRandomBlanks {
	int number = [Generator generateNewNumberWithStart:0 Finish:7];
	if (number == 0) {
		[self setBlankAtIndex:0];
		[self setBlankAtIndex:3];
		[self setBlankAtIndex:6];
	}
	if (number == 1) {
		[self setBlankAtIndex:1];
		[self setBlankAtIndex:4];
		[self setBlankAtIndex:7];
	}
	if (number == 2) {
		[self setBlankAtIndex:2];
		[self setBlankAtIndex:5];
		[self setBlankAtIndex:8];
	}
	if (number == 3) {
		[self setBlankAtIndex:0];
		[self setBlankAtIndex:1];
		[self setBlankAtIndex:2];
	}
	if (number == 4) {
		[self setBlankAtIndex:3];
		[self setBlankAtIndex:4];
		[self setBlankAtIndex:5];
	}
	if (number == 5) {
		[self setBlankAtIndex:6];
		[self setBlankAtIndex:7];
		[self setBlankAtIndex:8];
	}
	if (number == 6) {
		[self setBlankAtIndex:0];
		[self setBlankAtIndex:4];
		[self setBlankAtIndex:8];
	}
	if (number == 7) {
		[self setBlankAtIndex:2];
		[self setBlankAtIndex:4];
		[self setBlankAtIndex:6];
	}
	int key = 0;
	do {
		number = [Generator generateNewNumberWithStart:0 Finish:8];
		Element *buf = [numbers objectAtIndex:number];
		if (buf.blank == NO) {
			[self setBlankAtIndex:number];
			++key;
		}
	} while (key < 1);
	for (int i = 0; i < 9; ++i) {
		Element *buf = [numbers objectAtIndex:i];
		if (buf.blank) {
			[self deleteBlankAtIndex:i];
		}
		else {
			[self setBlankAtIndex:i];
		}
	}
}
-(void) print {
	NSLog(@"%@ %@ %@", [numbers objectAtIndex:0], [numbers objectAtIndex:1], [numbers objectAtIndex:2]);
	NSLog(@"%@ %@ %@", [numbers objectAtIndex:3], [numbers objectAtIndex:4], [numbers objectAtIndex:5]);
	NSLog(@"%@ %@ %@", [numbers objectAtIndex:6], [numbers objectAtIndex:7], [numbers objectAtIndex:8]);	
}
-(Element*) elementAtIndex:(int)index {
	return [numbers objectAtIndex:index];
}

- (void)showSolveOnView:(UIView*) view_  {
	labels = [[NSMutableArray alloc]initWithCapacity:5];
	int xLevel = 300;
	int yLevel = 250;
	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 3; ++j) {
			CGPoint origin = CGPointMake(xLevel + j*(kNumber+5), yLevel + i*(kNumber + 5));
			int count = 3*i + j;
			Element* buf = [numbers objectAtIndex:count];
			NLElementView* newElement = [[NLElementView alloc]initWithType:ElementTypeNumber andText:buf.description andOrigin:origin andEditable:buf.blank];
			if (buf.blank) {
				[newElement setTextTo:@"" animation:NO];
				[labels addObject:newElement];
			}
			[view_ addSubview:newElement];
		}
	}
	liteDescription = NSLocalizedString(@"MAG_SQ_LITE_DESC", @"Lite magic square description");
}

@end
