//
//  MHLocationManager.h
//  GeoFence
//
//  Created by Michael Burks on 1/30/15.
//  Copyright (c) 2015 Michael Burks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MHLocationManagerDelegate <NSObject>

- (void)updateLocationWithLatitude:(double)lat longitude:(double)lon;

@end


@interface MHLocationManager : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *geofences;

@property (weak, nonatomic) id <MHLocationManagerDelegate> delegate;

+ (id)sharedManager;

@end
