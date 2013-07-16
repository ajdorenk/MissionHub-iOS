//
//  MHCreatePersonViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCreatePersonViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField* firstName;
@property (nonatomic, strong) IBOutlet UITextField* lastName;
@property (nonatomic, strong) IBOutlet UITextField* email;
@property (nonatomic, strong) IBOutlet UITextField* phone;
@property (nonatomic, strong) IBOutlet UITextField* address1;
@property (nonatomic, strong) IBOutlet UITextField* address2;
@property (nonatomic, strong) IBOutlet UITextField* city;
@property (nonatomic, strong) IBOutlet UITextField* zip;
@property (nonatomic, strong) IBOutlet UISegmentedControl* maleFemaleControl;




@end
