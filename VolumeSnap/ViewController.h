//
//  ViewController.h
//  VolumeSnap
//
//  Created by Randall Brown on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class RBVolumeButtons;

@interface ViewController : UIViewController
{
   float launchVolume;
   RBVolumeButtons *_buttonStealer;
}

@property (strong) RBVolumeButtons *buttonStealer;

- (IBAction)changeStealing:(id)sender;

@end
