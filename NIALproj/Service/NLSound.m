//
//  NLSound.m
//  NIALproj
//
//  Created by Alexey Goncharov on 13.08.12.
//  Copyright (c) 2012 Alexey Goncharov. All rights reserved.
//

#import "NLSound.h"

@implementation NLSound

+ (void)playSound:(SoundType)soundType {
	NSString *effect;
	switch (soundType) {
		case SoundTypeClick:
			effect = @"SoundClick";
			break;
		case SoundTypeAlert:
			effect = @"SoundAlert";
			break;
		case SoundTypeWrong:
			effect = @"SoundFail";
			break;
		case SoundTypeFlip:
			effect = @"SoundFlip";
			break;
		case SoundTypeTimer:
			effect = @"SoundCount";
			break;
		case SoundTypeEndTime:
			effect = @"SoundEndTime";
			break;
		case SoundTypeGameOver:
			effect = @"SoundGameOver";
			break;
		default:
			break;
	}
	NSString *type = @"mp3";
	SystemSoundID soundID;
	NSString *path = [[NSBundle mainBundle]pathForResource:effect ofType:type];
	NSURL *url = [NSURL fileURLWithPath:path];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
	AudioServicesPlaySystemSound(soundID);

}


@end
