//
//  RBVolumeButtons.m
//  VolumeSnap
//
//  Created by Randall Brown on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RBVolumeButtons.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RBVolumeButtons()
-(void)initializeVolumeButtonStealer;
-(void)volumeDown;
-(void)volumeUp;
-(void)startStealingVolumeButtonEvents;
-(void)stopStealingVolumeButtonEvents;

@property BOOL isStealingVolumeButtons;
@property BOOL suspended;
@property (nonatomic, strong) UIView *volumeView;
@property (nonatomic, readwrite) float launchVolume;

@property (nonatomic) BOOL hadToLowerVolume;
@property (nonatomic) BOOL hadToRaiseVolume;

@end

@implementation RBVolumeButtons

void volumeListenerCallback (
                             void                      *inClientData,
                             AudioSessionPropertyID    inID,
                             UInt32                    inDataSize,
                             const void                *inData
                             );
void volumeListenerCallback (
                             void                      *inClientData,
                             AudioSessionPropertyID    inID,
                             UInt32                    inDataSize,
                             const void                *inData
                             ){
   const float *volumePointer = inData;
   float volume = *volumePointer;

   
   if( volume > [(__bridge RBVolumeButtons*)inClientData launchVolume] )
   {
      [(__bridge RBVolumeButtons*)inClientData volumeUp];
   }
   else if( volume < [(__bridge RBVolumeButtons*)inClientData launchVolume] )
   {
      [(__bridge RBVolumeButtons*)inClientData volumeDown];
   }

}

-(void)volumeDown
{
   AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self));
   
   [[MPMusicPlayerController applicationMusicPlayer] setVolume:self.launchVolume];
   
   [self performSelector:@selector(initializeVolumeButtonStealer) withObject:self afterDelay:0.1];
   
   
   if( self.downBlock )
   {
      self.downBlock();
   }
}

-(void)volumeUp
{
   AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self));
   
   [[MPMusicPlayerController applicationMusicPlayer] setVolume:self.launchVolume];
   
   [self performSelector:@selector(initializeVolumeButtonStealer) withObject:self afterDelay:0.1];
   

      if( self.upBlock )
      {
         self.upBlock();
      }

}

-(id)init
{
   self = [super init];
   if( self )
   {
      self.isStealingVolumeButtons = NO;
      self.suspended = NO;

      CGRect frame = CGRectMake(0, -10, 1, 1);
      self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
   }
   return self;
}

-(void)startStealingVolumeButtonEvents
{
	NSAssert([[NSThread currentThread] isMainThread], @"This must be called from the main thread");
	
	if(self.isStealingVolumeButtons) {
		return;
	}
    
    self.isStealingVolumeButtons = YES;
	
	AudioSessionInitialize(NULL, NULL, NULL, NULL);

	UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
	AudioSessionSetProperty (
							 kAudioSessionProperty_AudioCategory,
							 sizeof (sessionCategory),
							 &sessionCategory
							 );
	
	AudioSessionSetActive(YES);
	
	if (!self.volumeView.superview) {
		[[[[UIApplication sharedApplication] windows] objectAtIndex:0] insertSubview:self.volumeView atIndex:0];
	}

	self.launchVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];
	BOOL hadToLowerVolume = self.launchVolume >= 1.0;
	BOOL hadToRaiseVolume = self.launchVolume <= 0.0;
	
    // Avoid flashing the volume indicator
    if (hadToLowerVolume || hadToRaiseVolume)
    {
		double delayInSeconds = 0.01;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if( hadToLowerVolume )
            {
                [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.95];
                self.launchVolume = 0.95;
            }
            
            if( hadToRaiseVolume )
            {
                [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.05];
                self.launchVolume = 0.05;
            }
		});
    }
	self.hadToLowerVolume = hadToLowerVolume;
	self.hadToRaiseVolume = hadToRaiseVolume;
	
	
	[self initializeVolumeButtonStealer];
	
    if (!self.suspended)
    {
        // Observe notifications that trigger suspend
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(suspendStealingVolumeButtonEvents:)
                                                     name:UIApplicationWillResignActiveNotification     // -> Inactive
                                                   object:nil];
        
        // Observe notifications that trigger resume
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeStealingVolumeButtonEvents:)
                                                     name:UIApplicationDidBecomeActiveNotification      // <- Active
                                                   object:nil];
    }
}

- (void)suspendStealingVolumeButtonEvents:(NSNotification *)notification
{
    if(self.isStealingVolumeButtons)
    {
        self.suspended = YES; // Call first!
        [self stopStealingVolumeButtonEvents];
    }
}

- (void)resumeStealingVolumeButtonEvents:(NSNotification *)notification
{
    if(self.suspended)
    {
        [self startStealingVolumeButtonEvents];
        self.suspended = NO; // Call last!
    }
}

-(void)stopStealingVolumeButtonEvents
{
   NSAssert([[NSThread currentThread] isMainThread], @"This must be called from the main thread");
   
   if(!self.isStealingVolumeButtons)
   {
      return;
   }
    
    // Stop observing all notifications
    if (!self.suspended)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
   
   AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self));
   
   if (!self.suspended)
   {
      if( self.hadToLowerVolume )
      {
         [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
      }
   
      if( self.hadToRaiseVolume )
      {
         [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
      }
   }
   
   
   AudioSessionSetActive(NO);
   
   self.isStealingVolumeButtons = NO;
}

-(void)dealloc
{
   [self.volumeView removeFromSuperview];
   self.volumeView = nil;

   self.suspended = NO;
   [self stopStealingVolumeButtonEvents];
    
}

-(void)initializeVolumeButtonStealer
{
   AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)(self));
}

@end

