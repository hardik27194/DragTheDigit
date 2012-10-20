//
//  Element.h
//  Project2
//
//  Created by Алексей Гончаров on 31.03.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Element: NSObject
{
	int value;
	BOOL blank;
	int typeOfValue;
	/*тип значения которое будет храниться
	 * 0 - дефолт - просто цифра
	 * 1 - длина дц,см
	 * 2 - десятки и единицы
	 */

	BOOL centimetersOnly; // актуально только для длины - все выражается в дециметрах
}
@property (readwrite) int value;
@property (readwrite) BOOL blank;
@property int typeOfValue;
@property BOOL centimetersOnly;
-(id) initWithValue: (int) val
			  Blank:(BOOL) blnk;
- (NSString *) description;

@end