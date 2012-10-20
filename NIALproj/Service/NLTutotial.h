//
//  NLTutotial.h
//  NIALproj
//
//  Created by Nikita Popov on 11.08.12.
//  Copyright (c) 2012 Alexey Goncharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLTutotial : UIView <UIScrollViewDelegate>
{
  UIScrollView* scrollView;
  UIPageControl* pageControl;
  //UIImageView* finger;
  NSMutableArray* fingers;
  NSMutableArray* firstPageObjects, *secondPageObjects, *thirdPageObjects;
  NSMutableArray* pages;
}

@end
