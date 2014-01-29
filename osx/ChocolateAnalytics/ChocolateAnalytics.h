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

+ (id)instance;
- (void)initWithTrackingId:(NSString *)trackingId;
- (void)track:(NSString *)keyPath withValue:(id)value;

@end
