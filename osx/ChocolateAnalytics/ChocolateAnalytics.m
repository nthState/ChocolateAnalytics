//
//  ChocolateAnalytics.m
//  ChocolateAnalytics
//
//  Created by davisc on 28/01/2014.
//  Copyright (c) 2014 nthState. All rights reserved.
//

#warning How do we handle data build up?

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
        _eventLimit = 20;
        _errorCount = 0;
        _trackedEvents = [[NSMutableArray alloc] init];
        _timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _processQueue = dispatch_queue_create("com.nthState.ChocolateAnalytics", DISPATCH_QUEUE_CONCURRENT);
        _uniqueId = [[NSUUID UUID] UUIDString];
        [self tick];
    }
    return self;
}

- (void)track:(NSString *)category withKeyPath:(NSString *)keyPath andValue:(id)value
{
    dispatch_barrier_async(_processQueue, ^{
        
        NSDictionary *dic = @{
                              @"uniqueId": _uniqueId,
                              @"category": category,
                              @"keyPath": keyPath,
                              @"value": value
                              };
        
        [_trackedEvents addObject:dic];
        
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
     If it fails, try again 3 times. Then just back off for a bit.
     
     */
    __block BOOL shouldTick = TRUE;
    __weak id localSelf = self;
    dispatch_barrier_async(_processQueue, ^{
        
        NSUInteger top = [_trackedEvents count] >= _eventLimit ? _eventLimit : [_trackedEvents count];
        
        NSRange range = NSMakeRange(0, top);
        NSArray *subset = [_trackedEvents subarrayWithRange:range];
        BOOL sent = [localSelf sendSubSet:subset];
        if (sent)
        {
            [_trackedEvents removeObjectsInRange:range];
            _errorCount = 0;
        } else {
            _errorCount++;
            if (_errorCount == 3)
            {
                shouldTick = FALSE;
            }
        }
        
    });
    
    if (shouldTick == FALSE)
    {
        [self tryAgainLater];
    } else {
        [self tick];
    }
}

- (void)tryAgainLater
{
    /*
     
     Keep backing off the retry
     
     */
    __weak id localSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 60 * _errorCount * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [localSelf tick];
    });
}

- (BOOL)sendSubSet:(NSArray *)subset
{
    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:_trackedEvents];
    
    NSError *jsonError = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:jsonData
                                                       options:0
                                                         error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return [self post:data json:jsonString];
}

- (BOOL)post:(NSData *)jsonData json:(NSString *)jsonString
{
    NSError *error = nil;
    NSURL *nsurl = [NSURL URLWithString:kAPI_BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:kAPI_TIMEOUT];
    [request setHTTPMethod:@""];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:jsonString forHTTPHeaderField:@"json"];
    [request setHTTPBody:jsonData];
    
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (error != nil)
    {
        NSLog(@"Url: %@ error: %@", kAPI_BASE_URL, [error localizedDescription]);
        return FALSE;
    }
    
    return TRUE;

}

@end
