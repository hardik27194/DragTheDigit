//
//  SignElement.h
//  Project2
//
//  Created by Алексей Гончаров on 09.04.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignElement : NSObject {
	/*
	 * класс знаков.
	 *  0 - "="
	 *  1 - "+"
	 *  2 - "-"
	 *  3 - ">"
	 *  4 - "<"
	 *  5 - ">="
	 *  6 - "<="
	 */
	short sign;
	BOOL blank;
}
@property short sign;
@property BOOL blank;
@property BOOL beforeNull;
-(id) initWithSign: (short) sgn
			  Blank:(BOOL) blnk;
- (NSString *) description;

@end
