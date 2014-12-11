//
//  RBVolumeButtons.h
//  VolumeSnap
//
//  Created by Randall Brown on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ButtonBlock)();

@interface RBVolumeButtons : NSObject
{}

@property (nonatomic, copy) ButtonBlock upBlock;
@property (nonatomic, copy) ButtonBlock downBlock;
@property (nonatomic, readonly) float launchVolume;
@property (nonatomic, readonly, strong) UIView *volumeView;

-(void)startStealingVolumeButtonEvents;
-(void)stopStealingVolumeButtonEvents;

@end
