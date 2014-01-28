//
//  ChocolateAnalytics.m
//  ChocolateAnalytics
//
//  Created by davisc on 28/01/2014.
//  Copyright (c) 2014 nthState. All rights reserved.
//

#import "ChocolateAnalytics.h"

NSString * const kAPI_BASE_URL = @"http://127.0.01:8010/v1/en-gb/tracker";
int const kAPI_TIMEOUT = 60.0;

@implementation ChocolateAnalytics

+ (id)instance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)initWithTrackingId:(NSString *)trackingId;
{
    self = [super init];
    if (self)
    {
        _trackingId = trackingId;
        _trackedEvents = [[NSMutableArray alloc] init];
        _timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _processQueue = dispatch_queue_create("com.nthState.ChocolateAnalytics", DISPATCH_QUEUE_CONCURRENT);
        [self tick];
    }
    return self;
}

- (void)track:(NSString *)category withKeyPath:(NSString *)keyPath andValue:(id)value
{
    dispatch_barrier_async(_processQueue, ^{
        
    });
}

- (void)tick
{
    __weak id localSelf = self;
    _timer_ticker = dispatch_source_create(
                                           DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                           _timerQueue);
    dispatch_source_set_timer(_timer_ticker,
                              dispatch_time(DISPATCH_TIME_NOW, _schedule * NSEC_PER_SEC),
                              DISPATCH_TIME_FOREVER, 0);
    dispatch_source_set_event_handler(_timer_ticker, ^{
        dispatch_source_cancel(_timer_ticker);
        
        [localSelf processAndStartAgain];
        
    });
    dispatch_resume(_timer_ticker);
}

- (void)processAndStartAgain
{
    /*
     
     Take x entries, process and remove from queue(trackedEvents)
     
     */
    __weak id localSelf = self;
    dispatch_barrier_async(_processQueue, ^{
        
        NSArray *subset = [_trackedEvents subarrayWithRange:NSMakeRange(0, 20)];
        [localSelf sendSubSet:subset];
        
    });
    
    [self tick];
}

- (void)sendSubSet:(NSArray *)subset
{
    //NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:_trackedEvents];
}

- (NSData *)post:(NSData *)data
{
    NSError *error = nil;
    NSURL *nsurl = [NSURL URLWithString:kAPI_BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:kAPI_TIMEOUT];
    [request setHTTPMethod:@""];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *jsonError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:0
                                                         error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [request setValue:jsonString forHTTPHeaderField:@"json"];
    [request setHTTPBody:jsonData];
    
    
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (error != nil)
    {
        NSLog(@"Url: %@ error: %@", kAPI_BASE_URL, [error localizedDescription]);
    }
    
    return responseData;

}

@end
