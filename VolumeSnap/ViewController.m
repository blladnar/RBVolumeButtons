//
//  ViewController.m
//  VolumeSnap
//
//  Created by Randall Brown on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#import "RBVolumeButtons.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeStealingButton;
@property (nonatomic, assign) NSUInteger counter;
@property (nonatomic, assign, getter = isStealing) BOOL stealing;

@end

@implementation ViewController

@synthesize buttonStealer = _buttonStealer;
@synthesize counterLabel = counterLabel;
@synthesize counter = counter;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.changeStealingButton setTitle:NSLocalizedString(@"Start stealing", nil) forState:UIControlStateNormal];
    
    counter = 0;

    self.buttonStealer = [[RBVolumeButtons alloc] init];
    __weak typeof(self) weakSelf = self;
    self.buttonStealer.upBlock = ^{
        weakSelf.counter++;
        [weakSelf.counterLabel setText:[NSString stringWithFormat:@"%i", weakSelf.counter]];
    };
    self.buttonStealer.downBlock = ^{
        weakSelf.counter--;
        [weakSelf.counterLabel setText:[NSString stringWithFormat:@"%i", weakSelf.counter]];
    };
}

- (void)viewDidUnload
{
    counterLabel = nil;
    self.buttonStealer = nil;
    [self setChangeStealingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)changeStealing:(id)sender
{
    if ([self isStealing])
    {
        [self.buttonStealer stopStealingVolumeButtonEvents];
        [self.changeStealingButton setTitle:NSLocalizedString(@"Start stealing", nil) forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonStealer startStealingVolumeButtonEvents];
        [self.changeStealingButton setTitle:NSLocalizedString(@"Stop stealing", nil) forState:UIControlStateNormal];
    }

    self.stealing = !self.stealing;
}

@end
