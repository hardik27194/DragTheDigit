//
//  Element.m
//  Project2
//
//  Created by Алексей Гончаров on 31.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "Element.h"

@implementation Element

@synthesize value;
@synthesize blank;
@synthesize centimetersOnly;
@synthesize typeOfValue;
-(id) init {
	value = 0;
	blank = NO;
	typeOfValue = 0;
	centimetersOnly = NO;
	return self;
}
-(id) initWithValue:(int)val Blank:(BOOL)blnk 
{
	value = val;
	blank = blnk;
	return self;
}
-(id) initWithValue:(int)val {
	value = val;
	return self;
}
- (NSString *) description
{
	
	if (typeOfValue == 0) {
		if (blank) {
				//return [[NSString alloc] initWithFormat:@"*"];
			
		}
		return [[NSString alloc] initWithFormat:@"%d", value];
	}
	if (typeOfValue == 1) {
		if (centimetersOnly || value/10 == 0) {
			if (blank) {
					//return [[NSString alloc] initWithFormat:@"* cm"];
				
			}
			return [[NSString alloc] initWithFormat:@"%d cm", value];
		}
		if (value%10 == 0) {
			if (blank) {
					//return [[NSString alloc] initWithFormat:@"* dm"];
				
			}
			return [[NSString alloc] initWithFormat:@"%d dm", value/10];
		}
		if (blank) {
				//return [[NSString alloc] initWithFormat:@"* dm * cm"];
			
		}
		return [[NSString alloc] initWithFormat:@"%d dm %d cm", value/10, value%10];
	}
	if (typeOfValue == 2) {
		if (centimetersOnly || value/10 == 0) {
			if (blank) {
					//return [[NSString alloc] initWithFormat:@"* un"];
				
			}
			return [[NSString alloc] initWithFormat:@"%d un", value];
		}
		if (value%10 == 0) {
			if (blank) {
					//return [[NSString alloc] initWithFormat:@"* tn"];
				
			}
			return [[NSString alloc] initWithFormat:@"%d tn", value/10];
		}
		if (blank) {
				//return [[NSString alloc] initWithFormat:@"* tn * un"];
			
		}
		return [[NSString alloc] initWithFormat:@"%d tn %d un", value/10, value%10];
	}
	return @"";
}
@end
