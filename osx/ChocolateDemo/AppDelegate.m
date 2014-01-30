//
//  AppDelegate.m
//  ChocolateDemo
//
//  Created by davisc on 29/01/2014.
//  Copyright (c) 2014 nthState. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[ChocolateAnalytics instance] initWithTrackingId:@"my-id"];
    
    
    for (int i = 0; i < 25; i++)
    {
        [[ChocolateAnalytics instance] track:@"a.b.c" withValue:[NSString stringWithFormat:@"%d", i]];
    }
}

@end
