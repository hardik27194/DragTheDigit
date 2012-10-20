//
//  NLSound.h
//  NIALproj
//
//  Created by Alexey Goncharov on 13.08.12.
//  Copyright (c) 2012 Alexey Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum {
	SoundTypeClick,
	SoundTypeAlert,
	SoundTypeWrong,
	SoundTypeFlip,
	SoundTypeTimer,
	SoundTypeEndTime,
	SoundTypeGameOver
} SoundType;

@interface NLSound : NSObject

+ (void)playSound:(SoundType)soundType;


@end
