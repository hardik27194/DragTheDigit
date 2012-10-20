//
//  NLElementView.h
//  NLProject
//
//  Created by Alexey Goncharov on 26.07.12.
//  Copyright (c) 2012 NIALsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Constants.h"

typedef enum  {
	ElementTypeNumber,
	ElementTypeSign,
  ElementTypePlusMinus,
	ElementTypeValue,
  ElementTypeEraser,
	ElementTypeRed
} ElementType;

@interface NLElementView : UIView {
}

@property NSString* _text;
@property NSString* _answer;
@property UIImage* _backgroundImage;
@property ElementType _type;
@property BOOL _selected;
@property UILabel* _label;
@property BOOL beforeNull;


+ (id)elementWithType:(ElementType)type;
+ (id)elementWithElement:(NLElementView*)element;
+ (id)elementWithElement:(NLElementView *)element editable:(BOOL)editable;
- (id)initWithType:(ElementType)type andText:(NSString*)text andOrigin:(CGPoint)point;
- (id)initWithType:(ElementType)type andText:(NSString*)text andOrigin:(CGPoint)point andEditable:(BOOL)editable;
- (NSString*)getText;
- (void)setTextTo:(NSString*)text animation:(BOOL)animation;
- (UIView*)getView;
- (CGPoint)getCenter;
- (void)setCenter:(CGPoint)center;
- (CGSize)getFrame;

-(void) selectElement;
-(void) deselectElement;
-(void) selectAction;
-(void) show;
-(void) hide;

@end