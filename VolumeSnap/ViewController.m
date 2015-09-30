//
//  ViewController.m
//  VolumeSnap
//
//  Created by Randall Brown on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "RBVolumeButtons.h"

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _counter = 0;

    self.buttonStealer = [[[RBVolumeButtons alloc] init] autorelease];
    self.buttonStealer.upBlock = ^{
        _counter++;
        [_counterLabel setText:[NSString stringWithFormat:@"%td", _counter]];
    };
    self.buttonStealer.downBlock = ^{
        _counter--;
        [_counterLabel setText:[NSString stringWithFormat:@"%td", _counter]];
    };
}

- (void)viewDidUnload
{
    [_counterLabel release];
    _counterLabel = nil;
    self.buttonStealer = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [_counterLabel release];
    [super dealloc];
}

- (IBAction)startStealing:(id)sender
{
    [self.buttonStealer startStealingVolumeButtonEvents];
}

- (IBAction)stopStealing:(id)sender
{
    [self.buttonStealer stopStealingVolumeButtonEvents];
}

@end
