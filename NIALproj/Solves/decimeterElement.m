//
//  decimeterElement.m
//  Project2
//
//  Created by Алексей Гончаров on 10.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import "decimeterElement.h"

@implementation decimeterElement
@synthesize decimeters;
@synthesize centimeters;


-(id)initWithDecimeters:(Element *)dec Centimeters:(Element *)cent {
	decimeters = dec;
	centimeters = cent;
	return self;
}
-(NSString*) description {
	if (decimeters.value == 0) {
		return [[NSString alloc]initWithFormat:@"%@cm", centimeters];
	}
	if (centimeters.value == 0) {
		return [[NSString alloc]initWithFormat:@"%@dm", decimeters];
	}
	return [[NSString alloc]initWithFormat:@"%@dm %@cm", decimeters, centimeters];
}
-(void) getCentimetersFromDecimeter {
	centimeters.value += 10*decimeters.value;
	decimeters.value = 0;
}
-(void) getDecimetresFromCentimetres {
	decimeters.value += centimeters.value/10;
	centimeters.value = 0;
}
@end
