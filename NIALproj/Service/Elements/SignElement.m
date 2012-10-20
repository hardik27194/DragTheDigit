//
//  SignElement.m
//  Project2
//
//  Created by Алексей Гончаров on 09.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "SignElement.h"

@implementation SignElement
@synthesize sign;
@synthesize blank;
@synthesize beforeNull;

-(id) init {
	sign = 0;
	blank = NO;
  beforeNull = NO;
	return self;
}
-(id) initWithSign:(short)sgn Blank:(BOOL)blnk {
	sign = sgn;
	blank = blnk;
	return self;
}
- (NSString *) description{
	/*if (blank) {
		return [[NSString alloc] initWithFormat:@"*"];
	}*/
	if (sign == 0) {
		return [[NSString alloc] initWithFormat:@"="];
	}
    if (sign == 1) {
		return [[NSString alloc] initWithFormat:@"+"];
	}
	if (sign == 2) {
		return [[NSString alloc] initWithFormat:@"-"];
	}
	if (sign == 3) {
		return [[NSString alloc] initWithFormat:@">"];
	}
	if (sign == 4) {
		return [[NSString alloc] initWithFormat:@"<"];
	}
	/*if (sign == 3) {
		return [[NSString alloc] initWithFormat:@"⩾"];
	}
	if (sign == -3) {
		return [[NSString alloc] initWithFormat:@"⩽"];
	}*/
	return [[NSString alloc] initWithFormat:@"ERROR"];
}
@end
