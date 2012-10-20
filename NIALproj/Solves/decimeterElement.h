//
//  decimeterElement.h
//  Project2
//
//  Created by Алексей Гончаров on 10.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"

@interface decimeterElement : NSObject {
	Element* decimeters;
	Element* centimeters;
}
@property Element* decimeters;
@property Element* centimeters;


-(id) initWithDecimeters: (Element*) dec  Centimeters: (Element*) cent;
- (NSString *) description;
-(void) getCentimetersFromDecimeter;
-(void) getDecimetresFromCentimetres;
@end
