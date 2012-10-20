//
//  NLKeyboard.h
//  NLProject
//
//  Created by Алексей Гончаров on 24.07.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    KeyboardTypeNumbers,
     KeyboardTypeSigns,
     KeyboardTypePlusMinus
}  KeyboardType;

@class NLElementView;



@interface NLKeyboard : UIView

@property NSMutableArray* buttons;

@property NSMutableArray* magnetArray;
@property NSArray* changebleObjects;
@property NSMutableArray* clearObjects;
@property KeyboardType typeOfKeyboard;

@property NSMutableArray* currentlyMoving;
@property NSMutableArray* backPoints;
@property NSMutableArray* arrayOfTouches;
@property NLElementView* currentlyAddingResult;
@property BOOL currentlyAddingSecondNumber;

- (id)initKeyboardWithType:(KeyboardType)type andMagnetArray:(NSArray*)array;
- (void)rebuildWithChangableArray:(NSArray*)array;
- (void)changeKeyboardType:(KeyboardType)type;
@end
