//
//  MHLocationManager.m
//  GeoFence
//
//  Created by Michael Burks on 1/30/15.
//  Copyright (c) 2015 Michael Burks. All rights reserved.
//

#import "MHLocationManager.h"
#import <UIKit/UIKit.h>

@implementation MHLocationManager

+ (id)sharedManager {
    static MHLocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        //TODO: Limit functionality to Cru staff users?
        
        // Initialize Location Manager
        self.locationManager = [[CLLocationManager alloc] init];
        self.geofences = [NSMutableArray array];
        
        // Configure Location Manager
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusDenied:
                [self.locationManager requestAlwaysAuthorization];
                break;
            default:
                [self.locationManager requestAlwaysAuthorization];
                break;
        }
        
        
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            
            for (CLRegion *reg in self.locationManager.monitoredRegions) {
                [self.locationManager stopMonitoringForRegion:reg];
            }
            
            //TODO: This should get appropriate region based on user -> campus -> geolocation info
            // DEBUG/DEV TEST REGION: Brandeis University
            CLRegion *brandeisRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(42.365685, -71.258595) radius:1600 identifier:@"Brandeis University"];
            // DEBUG/DEV TEST REGION: Olin College
            CLRegion *olinRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(42.291867, -71.264374) radius:1600 identifier:@"Olin College"];
            
            [self.locationManager startMonitoringForRegion:brandeisRegion];
            [self.locationManager startMonitoringForRegion:olinRegion];
            [self.geofences addObject:brandeisRegion];
            [self.geofences addObject:olinRegion];
            
        }
        
        // Location updates are only for showing location info useful for testing. Not necessary for region monitoring functionality; should probably be removed eventually to conserve battery.
//        if ([CLLocationManager locationServicesEnabled]) {
//            [self.locationManager startUpdatingLocation];
//        }
        
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
//    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Entered Region: %@",region.identifier] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    NSLog(@"Entered Region : %@", region.identifier);
    
    //TODO: Implement local notifications for when the app is not running or in the background.
    /*
    //implement local notification:
    UIApplication *app = [UIApplication sharedApplication];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (notification == nil)
        return;
    notification.alertBody = [NSString stringWithFormat:@"Entered Region: %@",region.identifier];
    notification.alertAction = @"OK";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    [app presentLocalNotificationNow:notification];
    */
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

    [[[UIAlertView alloc] initWithTitle:@"Leaving campus" message:[NSString stringWithFormat:@"It appears you've left %@. You should log your interactions before you forget!",region.identifier] delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Ok, sure!", nil] show];
    NSLog(@"Exited Region : %@", region.identifier);
    
    //TODO: Implement local notifications for when the app is not running or in the background.
    //implement local notification:
    UIApplication *app = [UIApplication sharedApplication];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (notification == nil)
        return;
    notification.alertBody = [NSString stringWithFormat:@"It appears you've left %@. You should log your interactions before you forget!",region.identifier];
    notification.alertAction = @"log interactions";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    [app presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
        [[[UIAlertView alloc] initWithTitle:@"LocationManager Failed." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    NSLog(@"LocationManager faild with error: %@", error.description);
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation *loc = [locations objectAtIndex:0];
////    double lat = loc.coordinate.latitude;
////    double lon = loc.coordinate.longitude;
////    [self.delegate updateLocationWithLatitude:lat longitude:lon];
//    NSLog(@"%@",[locations description]);
//}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
}

@end
