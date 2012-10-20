#import "NLElementView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NLElementView
@synthesize _text, _backgroundImage, _selected, _type, _label, _answer, beforeNull;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		_label = [[UILabel alloc]init];
		_label.backgroundColor = [UIColor clearColor];
    beforeNull = NO;
	}
	return self;
}

+ (id)elementWithElement:(NLElementView *)element
{
	return [NLElementView elementWithElement:element editable:NO];
}

+(id)elementWithElement:(NLElementView *)element editable:(BOOL)editable
{
	NLElementView* result = [NLElementView elementWithType:element._type editable:editable];
	result._text = element._text;
	result._answer = element._answer;
	result._label.text = element._label.text;
	result.frame = element.frame;
	result._selected = element._selected;
	return result;
}

+(id)elementWithType:(ElementType)type editable:(BOOL)editable
{
	NLElementView* tempView = [[NLElementView alloc]init];
	tempView._type = type;
	switch (type) {
		case ElementTypeNumber: {
				//numberElement
			tempView.frame = CGRectMake(0, 0, kNumber, kNumber);
			[tempView._label setTextAlignment:UITextAlignmentCenter];
			[tempView._label setFont:[UIFont fontWithName:kFontName size:kNumberFontSize]];
			if (editable) {
				tempView/*._label*/.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ButtonLight"]];
			}
			else {
				tempView/*._label*/.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ButtonDark"]];
			}
			break;
		}
		case ElementTypeSign: {
				//signElement
			tempView.frame = CGRectMake(0, 0, kSign, kSign);
			[tempView._label setTextAlignment:UITextAlignmentCenter];
			[tempView._label setFont:[UIFont fontWithName:kFontName size:kSignFontSize]];
			if (editable) {
				tempView/*._label*/.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignButtonLight"]];
			}
			else {
				tempView/*._label*/.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignButtonDark"]];
			}
			break;
		}
		case ElementTypeValue: {
				//valueElement
			tempView.frame = CGRectMake(0, 0, kValueWidth, kSign);
			[tempView._label setTextAlignment:UITextAlignmentCenter];
			[tempView._label setFont:[UIFont fontWithName:kFontName size:kValueFontSize]];
			if (editable) {
				tempView/*._label*/.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignButtonLight"]];
			}
			else {
				tempView/*._label*/.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignButtonDark"]];
			}
			break;
		}
    case ElementTypeEraser: {
      //Eraser
      //tempView.frame = CGRectMake(0, 0, kNumber, kNumber);
			[tempView._label setTextAlignment:UITextAlignmentCenter];
			[tempView._label setFont:[UIFont fontWithName:kFontName size:kNumberFontSize]];
			UIImageView* temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Eraser"]];
      [tempView setBackgroundColor:[UIColor clearColor]];
      [tempView._label setBackgroundColor:[UIColor clearColor]];
      [tempView addSubview:temp];
      [tempView setFrame:[temp frame]];
			break;
    }
		case ElementTypeRed: {
				//Eraser
				//tempView.frame = CGRectMake(0, 0, kNumber, kNumber);
			[tempView._label setTextAlignment:UITextAlignmentCenter];
			[tempView._label setFont:[UIFont fontWithName:kFontName size:kNumberFontSize]];
			UIImageView* temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ButtonRed"]];
      [tempView setBackgroundColor:[UIColor clearColor]];
      [tempView._label setBackgroundColor:[UIColor clearColor]];
      [tempView addSubview:temp];
      [tempView setFrame:[temp frame]];
			break;
    }
		default:
			break;
	}
		//tempView._label.backgroundColor = [UIColor lightGrayColor];
	tempView._label.frame = tempView.frame;
	[tempView addSubview:tempView._label];
	
	return tempView;
}

+ (id)elementWithType:(ElementType)type {
	return [NLElementView elementWithType:type editable:NO];
}

- (id)initWithType:(ElementType)type
					 andText:(NSString*)text
				 andOrigin:(CGPoint)point
{
	self = [NLElementView elementWithType:type];
	_selected = NO;
	_text = text;
	_answer = @"";
	_label.text = text;
		//_label.backgroundColor = [UIColor underPageBackgroundColor];
	self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
	return self;
	
}

- (id)initWithType:(ElementType)type
           andText:(NSString*)text
         andOrigin:(CGPoint)point
       andEditable:(BOOL)editable
{
	self = [NLElementView elementWithType:type editable:editable];
	_selected = NO;
	_text = text;
	_answer = @"";
	_label.text = text;
		//_label.backgroundColor = [UIColor underPageBackgroundColor];
	self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
	return self;
}


- (NSString*)getText {
	return self._label.text;
}
- (void)setTextTo:(NSString*)text animation:(BOOL)animation {
	if (animation) {
		[UIView animateWithDuration:0.1 animations:^{
			self._label.alpha = 0;
		} completion:^(BOOL finished){
			self._label.text = text;
      [UIView animateWithDuration:0.3 animations:^{
        self._label.alpha = 1;
      }];
    }];
	}
	else {
		self._label.text = text;
	}
	
}
- (UIView*)getView {
	return self;
}
- (CGPoint)getCenter {
	return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
- (void)setCenter:(CGPoint)center {
	self.frame = CGRectMake(center.x-self.frame.size.width/2, center.y-self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
}
- (CGSize)getFrame {
	return self.frame.size;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void)selectAction
{
	if (_selected) {
			//[self selectElement];
	}
	else {
			//  [self deselectElement];
	}
}

-(void)show
{
	[UIView animateWithDuration:0.6 animations:^{[self setAlpha:1];}];
}

-(void)hide
{
	[UIView animateWithDuration:0.6 animations:^{[self setAlpha:0];}];
}

-(void)selectElement
{
	[UIView animateWithDuration:0.6 animations:^{
			//[self show];
		[[self layer] setBackgroundColor:[[UIColor yellowColor] CGColor]];
	}];
}

-(void)deselectElement
{
	[UIView animateWithDuration:0.6 animations:^{
		[[self layer] setBackgroundColor:[[UIColor clearColor] CGColor]];
	}];
}

@end