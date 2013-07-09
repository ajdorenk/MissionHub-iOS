//
//  MHNewInteractionViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/9/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHNewInteractionViewController : UIViewController


@property (nonatomic, strong) IBOutlet UIButton *initiator;
@property (nonatomic, strong) IBOutlet UIButton *interaction;
@property (nonatomic, strong) IBOutlet UIButton *receiver;
@property (nonatomic, strong) IBOutlet UIButton *visibility;
@property (nonatomic, strong) IBOutlet UIButton *dateTime;
@property (nonatomic, strong) IBOutlet UITextField *comment;


@end
