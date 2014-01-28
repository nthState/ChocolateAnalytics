//
//  ChocolateAnalytics.h
//  ChocolateAnalytics
//
//  Created by davisc on 28/01/2014.
//  Copyright (c) 2014 nthState. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAPI_BASE_URL;
extern int const kAPI_TIMEOUT;

@interface ChocolateAnalytics : NSObject

@property (strong, nonatomic) NSString *trackingId;
@property (assign, nonatomic) float schedule;
@property (assign, nonatomic) int eventLimit;
@property (assign, nonatomic) int errorCount;
@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) NSMutableArray *trackedEvents;
@property (strong, nonatomic) dispatch_source_t timer_ticker;
@property (strong, nonatomic) dispatch_queue_t timerQueue;
@property (strong, nonatomic) dispatch_queue_t processQueue;

+ (id)instance;
- (id)initWithTrackingId:(NSString *)trackingId;
- (void)track:(NSString *)category withKeyPath:(NSString *)keyPath andValue:(id)value;

@end
