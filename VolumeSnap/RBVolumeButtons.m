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
@end

@implementation RBVolumeButtons

@synthesize upBlock;
@synthesize downBlock;
@synthesize launchVolume;

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

   
   if( volume > [(RBVolumeButtons*)inClientData launchVolume] )
   {
      [(RBVolumeButtons*)inClientData volumeUp];
   }
   else if( volume < [(RBVolumeButtons*)inClientData launchVolume] )
   {
      [(RBVolumeButtons*)inClientData volumeDown];
   }

}

-(void)volumeDown
{
   AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, self);
   
   [[MPMusicPlayerController applicationMusicPlayer] setVolume:launchVolume];
   
   [self performSelector:@selector(initializeVolumeButtonStealer) withObject:self afterDelay:0.1];
   
   
   if( self.downBlock )
   {
      self.downBlock();
   }
}

-(void)volumeUp
{
   AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, self);
   
   [[MPMusicPlayerController applicationMusicPlayer] setVolume:launchVolume];
   
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
      AudioSessionInitialize(NULL, NULL, NULL, NULL);
      AudioSessionSetActive(YES);
      
      launchVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];
      hadToLowerVolume = launchVolume == 1.0;
      hadToRaiseVolume = launchVolume == 0.0;
      justEnteredForeground = NO;
      if( hadToLowerVolume )
      {
         [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.95];
         launchVolume = 0.95;
         
      }
      
      if( hadToRaiseVolume )
      {
         [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.05];
         launchVolume = 0.05;
      }
      
      CGRect frame = CGRectMake(0, -100, 10, 0);
      MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:frame] autorelease];
      [volumeView sizeToFit];
      [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:volumeView];
      
      [self initializeVolumeButtonStealer];
      
      
      [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
         [self stopStealingVolumeButtonEvents];
      }];
      
      
      [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
         if( ! justEnteredForeground )
         {
            [self startStealingVolumeButtonEvents];
         }
         justEnteredForeground = NO;
      }];
      
      
      [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
         justEnteredForeground = YES;
         [self startStealingVolumeButtonEvents];
         
         
      }];
      
   }
   return self;
}

-(void)startStealingVolumeButtonEvents
{
   AudioSessionInitialize(NULL, NULL, NULL, NULL);
   AudioSessionSetActive(YES);
   [self initializeVolumeButtonStealer];
   launchVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];
   hadToLowerVolume = launchVolume == 1.0;
   hadToRaiseVolume = launchVolume == 0.0;
   if( hadToLowerVolume )
   {
      [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.95];
      launchVolume = 0.95;
   }
   
   if( hadToRaiseVolume )
   {
      [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.1];
      launchVolume = 0.1;
   }
}

-(void)stopStealingVolumeButtonEvents
{
   AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, self);
   
   if( hadToLowerVolume )
   {
      [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
   }
   
   if( hadToRaiseVolume )
   {
      [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
   }
   AudioSessionSetActive(NO);
}

-(void)dealloc
{
   if( hadToLowerVolume )
   {
      [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
   }
   
   if( hadToRaiseVolume )
   {
      [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
   }
   [super dealloc];
}

-(void)initializeVolumeButtonStealer
{
   AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, self);
}

@end
