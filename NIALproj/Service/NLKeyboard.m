#import "NLKeyboard.h"
#import "Constants.h"
#import "NLElementView.h"
#import "NLProgress.h"
#import <QuartzCore/QuartzCore.h>

#define buttonsPositions 47//680
#define globalAccuracy 2.5

@implementation NLKeyboard
@synthesize buttons;
@synthesize magnetArray;
@synthesize changebleObjects;
@synthesize clearObjects;
@synthesize typeOfKeyboard;
@synthesize currentlyMoving;
@synthesize backPoints;
@synthesize arrayOfTouches;
@synthesize currentlyAddingResult;
@synthesize currentlyAddingSecondNumber;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
			// Initialization code
	}
	return self;
}

-(id) initKeyboardWithType:(KeyboardType)type andMagnetArray:(NSArray*)array
{
	CGRect temp = [[UIScreen mainScreen] bounds];
	if(temp.size.height>temp.size.width)
			{
		float x = temp.size.width;
		temp.size.width = temp.size.height;
		temp.size.height = x;
			}
	self = [self initWithFrame:CGRectMake(0, 633, 1024, 135)];
	if(self)
  {
		self.backgroundColor = [UIColor clearColor];
		
    UIImageView* keyboardUnderpage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KeyboardUnderpage.jpg"]];
    keyboardUnderpage.frame = CGRectMake(-2, self.frame.size.height - 135, 1026, 135);
    [self addSubview:keyboardUnderpage];
    
		self.multipleTouchEnabled = YES;
		
		clearObjects = [[NSMutableArray alloc] init];
		currentlyMoving = [[NSMutableArray alloc] init];
		backPoints = [[NSMutableArray alloc] init];
		arrayOfTouches = [[NSMutableArray alloc] init];
		
		currentlyAddingSecondNumber = NO;
    
		[self rebuildWithChangableArray:array];
		
		[self changeKeyboardType:type];
    typeOfKeyboard = type;
		
  }
	return self;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (int i=0; i<[touches count]; ++i) {
    if ([arrayOfTouches containsObject:[[touches allObjects] objectAtIndex:i]]) {
      int j = [arrayOfTouches indexOfObject:[[touches allObjects] objectAtIndex:i]];
      [UIView animateWithDuration:0.5 animations:^{
        [[currentlyMoving objectAtIndex:j] setAlpha:0];
      }completion:^(BOOL finished){
        [[currentlyMoving objectAtIndex:j] removeFromSuperview];
        [currentlyMoving removeObjectAtIndex:j];
        [backPoints removeObjectAtIndex:j];
        [arrayOfTouches removeObjectAtIndex:j];
      }];
    }
  }
}

-(BOOL)checkRangeOfTouch:(CGPoint)touch nearCenter:(id)object withAccuracy:(NSInteger) acc
{
	CGPoint center = [object center];
	if ((touch.x-center.x)*(touch.x-center.x) + (touch.y-center.y)*(touch.y-center.y) < acc*acc) {
		return YES;
	}
	return NO;
}
-(BOOL)checkRangeOfTouch:(CGPoint)touch nearDot:(CGPoint)dot withAccuracy:(NSInteger)acc
{
	if ((touch.x-dot.x)*(touch.x-dot.x) + (touch.y-dot.y)*(touch.y-dot.y) < acc*acc) {
		return YES;
	}
	return NO;
}

-(CGPoint)getClosestInMagnetArrayTo:(CGPoint)point
{
	CGPoint result = CGPointZero;
	for(NSValue* temp in magnetArray)
			{
		if ([self checkRangeOfTouch:point nearDot:[temp CGPointValue] withAccuracy:[[changebleObjects objectAtIndex:0]frame].size.width]) {
			if ((result.x-point.x)*(result.x-point.x)+(result.y-point.y)*(result.y-point.y)>
					([temp CGPointValue].x-point.x)*([temp CGPointValue].x-point.x)+([temp CGPointValue].y-point.y)*([temp CGPointValue].y-point.y)) {
				result = [temp CGPointValue];
			}
		}
			}
	return result;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(int j=0;j<[touches count];++j){
		NLElementView* tempView = nil;
		CGPoint velocity;
		for (int k=0; k<[arrayOfTouches count]; ++k) {
			if ([[touches allObjects] objectAtIndex:j]==[arrayOfTouches objectAtIndex:k]) {
				tempView = [currentlyMoving objectAtIndex:k];
				[currentlyMoving removeObject:tempView];
				[arrayOfTouches removeObjectAtIndex:k];
				velocity = [[backPoints objectAtIndex:k] CGPointValue];
				[backPoints removeObjectAtIndex:k];
			}
		}
		if (tempView) {
			int tempi2=-1;
			if (![[tempView getText] isEqualToString:[[buttons objectAtIndex:[buttons count]-1] getText]]) {
				CGPoint temp = [self getClosestInMagnetArrayTo:[[[touches allObjects] objectAtIndex:j] locationInView:self]];
				if (!CGPointEqualToPoint(temp,CGPointZero) &&
            [[changebleObjects objectAtIndex:[magnetArray indexOfObject:[NSValue valueWithCGPoint:temp]]] _type] == [tempView _type]) {
          if(tempView._type==ElementTypeSign)
          {
            NSString* tempFuckingSign = [[changebleObjects objectAtIndex:[magnetArray indexOfObject:[NSValue valueWithCGPoint:temp]]] _text];
            if ((([tempFuckingSign isEqualToString:@"<"]||
                 [tempFuckingSign isEqualToString:@">"]||
                 [tempFuckingSign isEqualToString:@"="])&&
                ([tempView._label.text isEqualToString:@"<"]||
                 [tempView._label.text isEqualToString:@">"]||
                 [tempView._label.text isEqualToString:@"="]))||
                (([tempFuckingSign isEqualToString:@"+"]||
                  [tempFuckingSign isEqualToString:@"-"])&&
                 ([tempView._label.text isEqualToString:@"-"]||
                  [tempView._label.text isEqualToString:@"+"]))) {
              velocity = temp;
            }
          }
          else velocity = temp;
        }
			}
			if (![[tempView getText] isEqualToString:[[buttons objectAtIndex:[buttons count]-1] getText]]) for (int i=0; i<[magnetArray count]; ++i) {
				if (CGPointEqualToPoint([[magnetArray objectAtIndex:i] CGPointValue], velocity)) {
							 tempi2 = i;
							 break;
						 }
			}
			NLElementView* tempLabel = nil;//[[NLElementView alloc]init];
			NSString* temptext = nil;
			if (tempi2>=0) {
				tempLabel =  [changebleObjects objectAtIndex:tempi2];
				if ([tempLabel._answer length]==1&&![[tempLabel getText] isEqualToString:@"0"]&&tempView._type==ElementTypeNumber) {
					temptext = [tempLabel._answer stringByAppendingString:[tempView getText]];
				}
				else {
					temptext = [tempView getText];
				}
			}
      if (!tempLabel||(tempLabel&&currentlyAddingSecondNumber)) {
        [UIView animateWithDuration:0.6 animations:^{
          [tempView setCenter:velocity];
            [tempView hide];
        } completion:^(BOOL finished){
          [tempView removeFromSuperview];
        }];
      }
      else if(!currentlyAddingSecondNumber) if ([temptext length] == 1||([[currentlyAddingResult._label text] isEqualToString:@"0"])) {
					///////
        [tempView removeFromSuperview];
				[[tempLabel superview] addSubview:tempView];
        [tempView setCenter:[[tempLabel superview] convertPoint:[tempView center]
                                        fromView:[self superview]]];
        velocity = [self convertPoint:velocity toView:[tempLabel superview]];
        tempLabel._answer = temptext;
        if([[currentlyAddingResult._label text] isEqualToString:@"0"]) {
          NSString* temptext1 = [temptext substringFromIndex:1];
          tempLabel._answer = temptext1;
        }
        currentlyAddingResult = tempView;
        [UIView animateWithDuration:0.6 animations:^{
          [tempView setCenter:velocity];
          if (!tempLabel) {
            [tempView hide];
          }
        } completion:^(BOOL finished){
            [tempLabel setTextTo:temptext animation:NO];
            if (!currentlyAddingSecondNumber)
            {
              [tempView removeFromSuperview];
              currentlyAddingResult = nil;
            }
            if([[currentlyAddingResult._label text] isEqualToString:@"0"]) {
              NSString* temptext1 = [temptext substringFromIndex:1];
              [tempLabel setTextTo:temptext1 animation:NO];
            }
        }];
      }
      else {
        currentlyAddingSecondNumber = YES;
        [tempView removeFromSuperview];
				[[tempLabel superview] addSubview:tempView];
        [tempView setCenter:[[tempLabel superview] convertPoint:[tempView center]
                                                       fromView:[self superview]]];
        velocity = [self convertPoint:velocity toView:[tempLabel superview]];
        UILabel* above = [[UILabel alloc] initWithFrame:tempView._label.frame];
        [above setCenter:tempView.center];
        [above setBackgroundColor:[UIColor clearColor]];
        [above setText:tempView._label.text];
        [above setFont:[tempView._label font]];
        [above setTextAlignment:UITextAlignmentCenter];
        [[tempLabel superview] addSubview:above];
					///////
        [tempView._label setAlpha:0];
				tempLabel._answer = temptext;
        if (currentlyAddingResult)
        {
          [tempLabel._label setAlpha:0];
        }
        
        [UIView animateWithDuration:0.6 animations:^{
          [tempView hide];
          CGPoint neededPlace = velocity;
          neededPlace.x+=21;
          [tempView setCenter:velocity];
          [above setCenter:neededPlace];
          neededPlace = tempLabel._label.center;
          neededPlace.x-=21;
          [tempLabel._label setCenter:neededPlace];
          if (currentlyAddingResult) {
            CGPoint moveLeft = [currentlyAddingResult._label center];
            moveLeft.x-=21;
            [currentlyAddingResult._label setCenter:moveLeft];
          }
        } completion:^(BOOL finished){
          [tempLabel._label setAlpha:1];
          [tempLabel setTextTo:temptext animation:NO];
          [tempView removeFromSuperview];
          [above removeFromSuperview];
          CGPoint neededPlace = tempLabel._label.center;
          neededPlace.x+=21;
          [tempLabel._label setCenter:neededPlace];
          [currentlyAddingResult removeFromSuperview];
          currentlyAddingResult = nil;
          currentlyAddingSecondNumber = NO;
        }];
      
      }
		}
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (int i=0; i<[touches count]; ++i) {
		for(int k=0;k<[arrayOfTouches count];++k){
			
			if([arrayOfTouches objectAtIndex:k] == [[touches allObjects] objectAtIndex:i])
				[UIView animateWithDuration:0.1 animations:^{
					[[currentlyMoving objectAtIndex:k] setCenter:[[[touches allObjects] objectAtIndex:i] locationInView:[self superview]]];
        }];
      
			for (int j=0; j<[changebleObjects count]; ++j) {
				if ([self checkRangeOfTouch:[[[touches allObjects] objectAtIndex:i] locationInView:self]
														nearDot:[[magnetArray objectAtIndex:j] CGPointValue]
											 withAccuracy:[[changebleObjects objectAtIndex:j] frame].size.width/globalAccuracy]&&
						![[[changebleObjects objectAtIndex:j] getText] isEqualToString:@""]&&
						[[[currentlyMoving objectAtIndex:k] getText] isEqualToString:[[buttons objectAtIndex:[buttons count]-1] getText]]) {
						////////////
					[[changebleObjects objectAtIndex:j] set_answer:@""];
					[[changebleObjects objectAtIndex:j] setTextTo:@"" animation:YES];
				}
			}
		}
	}
}

/*-(BOOL)compareCGPoint:(CGPoint)first toCGPoint:(CGPoint)second
{
	if (first.x==second.x&&first.y==second.y) {
		return YES;
	}
	return NO;
}*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (int j=0; j<[touches count]; ++j) {
		int closestButton = -1;
    CGPoint touch = [[[touches allObjects] objectAtIndex:j] locationInView:self];
    for (int i=0; i<[buttons count]; ++i) {
			if ([self checkRangeOfTouch:touch nearCenter:[buttons objectAtIndex:i] withAccuracy:[[buttons objectAtIndex:i] frame].size.width]) {
				if (closestButton!=-1) {
          CGPoint test1 = [[buttons objectAtIndex:closestButton] center];
          CGPoint test2 = [[buttons objectAtIndex:i] center];
          if ((touch.x-test1.x)*(touch.x-test1.x) + (touch.y-test1.y)*(touch.y-test1.y)>
              (touch.x-test2.x)*(touch.x-test2.x) + (touch.y-test2.y)*(touch.y-test2.y)) {
            closestButton=i;
          }
        }
        else closestButton = i;
			}
    }
    if (closestButton>=0) {
      [arrayOfTouches addObject:[[touches allObjects] objectAtIndex:j]];
      CGPoint temp = [[[touches allObjects] objectAtIndex:j] locationInView:self];
      temp = [self convertPoint:temp toView:[self superview]];
      NLElementView* tempView = [NLElementView elementWithElement:[buttons objectAtIndex:closestButton] editable:YES];
      [backPoints addObject:[NSValue valueWithCGPoint:[self convertPoint:[[buttons objectAtIndex:closestButton] center]
                                                                  toView:[self superview]]]];
      [currentlyMoving addObject:tempView];
      [tempView setCenter:[self convertPoint:[[buttons objectAtIndex:closestButton] center]
                                      toView:[self superview]]];
      [[self superview] addSubview:tempView];
      [UIView animateWithDuration:0.1 animations:^{
        [tempView setCenter:temp];
      }];
    }
	}
}

-(void) rebuildWithChangableArray:(NSArray*)array
{
	changebleObjects = array;
	magnetArray = [[NSMutableArray alloc] init];
	for (int i=0; i<[changebleObjects count]; ++i) {
		/*CGPoint temp1 = [[changebleObjects objectAtIndex:i] center];
		temp1.x += [UIScreen mainScreen].bounds.size.height/2-kViewCenterX;
		temp1.y += 100;*/
    CGPoint temp1 = [self convertPoint:[[changebleObjects objectAtIndex:i] center] fromView:[[changebleObjects objectAtIndex:i] superview]];
		[magnetArray addObject:[NSValue valueWithCGPoint:temp1]];
	}
	[clearObjects removeAllObjects];
	[UIView animateWithDuration:0.6 animations:^{
	}];
}

-(void) changeKeyboardType:(KeyboardType)type
{
  if ((typeOfKeyboard!=type && (type==KeyboardTypeSigns||typeOfKeyboard==KeyboardTypeSigns)) || !buttons) {
	CGRect temp = [[UIScreen mainScreen] bounds];
	if(temp.size.height>temp.size.width)
  {
		float x = temp.size.width;
		temp.size.width = temp.size.height;
		temp.size.height = x;
  }
  [UIView animateWithDuration:0.3 animations:^{
    for (int i=0; i<[buttons count]; ++i) {
      [[buttons objectAtIndex:i] setAlpha:0];
    }
  } completion:^(BOOL finished) {
    for (int i=0; i<[buttons count]; ++i) {
      [[buttons objectAtIndex:i] removeFromSuperview];
    }
    buttons = nil;
    int count;
    
    count = 15;
    buttons = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i=0; i<10; ++i) {
      NLElementView* templabel = [[NLElementView alloc] initWithType:ElementTypeNumber andText:[NSString stringWithFormat:@"%i",i] andOrigin:CGPointMake(i*temp.size.width/14 +20,buttonsPositions-30) andEditable:YES];
      [buttons addObject:templabel];
      //[self addSubview:templabel];
    }
    for (int i=0; i<2; ++i) {
      NLElementView* templabel = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"" andOrigin:CGPointMake(10*temp.size.width/14+50, buttonsPositions - 30 + i*(kSign + 2)) andEditable:YES];
      [buttons addObject:templabel];
      //[self addSubview:templabel];
    }
    typeOfKeyboard = KeyboardTypePlusMinus;
    [[buttons objectAtIndex:10] setTextTo:@"+" animation:NO];
    [[buttons objectAtIndex:11] setTextTo:@"-" animation:NO];
    for (int i=0; i<3; ++i) {
      NLElementView* templabel = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"" andOrigin:CGPointMake(temp.size.width*10/12+(kSign+5)*i-20 +3, buttonsPositions-30) andEditable:YES];
      [buttons addObject:templabel];
      //[self addSubview:templabel];
    }
    [[buttons objectAtIndex:12] setTextTo:@">" animation:NO];
    [[buttons objectAtIndex:13] setTextTo:@"<" animation:NO];
    [[buttons objectAtIndex:14] setTextTo:@"=" animation:NO];
    
    
    
    
    
    
    /*
    if(type == KeyboardTypeNumbers || type == KeyboardTypePlusMinus)
    {
      count = 12;
      buttons = [[NSMutableArray alloc] initWithCapacity:count]; //1-10
      for (int i=0; i<count-2; ++i) {
        NLElementView* templabel = [[NLElementView alloc] initWithType:ElementTypeNumber andText:[NSString stringWithFormat:@"%i",i] andOrigin:CGPointMake(i*temp.size.width/(count+1) +20,buttonsPositions-30) andEditable:YES];
        [buttons addObject:templabel];
        //[self addSubview:templabel];
      }
      typeOfKeyboard = KeyboardTypeNumbers;
			
      if (type == KeyboardTypePlusMinus||YES) {
        //int i = count - 1;
        //count += 2;
        //buttons = [[NSMutableArray alloc] initWithCapacity:count];  //+-?
        for (int i=0; i<2; ++i) {
          NLElementView* templabel = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"" andOrigin:CGPointMake(10*temp.size.width/(count+1)+50, buttonsPositions - 30 + i*(kSign + 5)) andEditable:YES];
          [buttons addObject:templabel];
          //[self addSubview:templabel];
			
        }
        typeOfKeyboard = KeyboardTypePlusMinus;
        [[buttons objectAtIndex:10] setTextTo:@"+" animation:NO];
        [[buttons objectAtIndex:11] setTextTo:@"-" animation:NO];
      }
    }
    if (type == KeyboardTypeSigns) {
      count=4;
      buttons = [[NSMutableArray alloc] initWithCapacity:count];  //<>=
      for (int i=0; i<count-1; ++i) {
        NLElementView* templabel = [[NLElementView alloc] initWithType:ElementTypeSign andText:@"" andOrigin:CGPointMake((i+1)*temp.size.width/(count+1)-kSign/2, buttonsPositions) andEditable:YES];
        [buttons addObject:templabel];
        //[self addSubview:templabel];
      }
      [[buttons objectAtIndex:0] setTextTo:@">" animation:NO];
      [[buttons objectAtIndex:1] setTextTo:@"<" animation:NO];
      [[buttons objectAtIndex:2] setTextTo:@"=" animation:NO];
      typeOfKeyboard = KeyboardTypeSigns;
    }*/
    if (!buttons) {
      NSLog(@"wrong keyboard type");
      return;
    }
    else {
      if (type == KeyboardTypePlusMinus) count = 11;
      NLElementView* templabel;
//      if (type == KeyboardTypeSigns) templabel = [[NLElementView alloc] initWithType:ElementTypeEraser andText:@"" andOrigin:CGPointMake((count-1)*temp.size.width/count+1, buttonsPositions) andEditable:YES];
      /*else*/ templabel = [[NLElementView alloc] initWithType:ElementTypeEraser andText:@"" andOrigin:CGPointMake(11*temp.size.width/12 - 75, buttonsPositions+25) andEditable:YES];
      [buttons addObject:templabel];
      for (NLElementView* tempAddButton in buttons) {
        [tempAddButton setAlpha:0];
        [self addSubview:tempAddButton];
        [UIView animateWithDuration:0.3 animations:^ {
          [tempAddButton setAlpha:1];
        }];
      }
    }
  }];
  }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end