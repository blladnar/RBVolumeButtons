//
//  ViewController.h
//  VolumeSnap
//
//  Created by Randall Brown on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RBVolumeButtons;

@interface ViewController : UIViewController
{
    float _launchVolume;
    IBOutlet UILabel *_counterLabel;
    int _counter;
}

@property (nonatomic, retain) RBVolumeButtons *buttonStealer;

- (IBAction)startStealing:(id)sender;
- (IBAction)stopStealing:(id)sender;

@end
