//
//  MHQuestion.h
//  MissionHub
//
//  Created by Michael Harrison on 6/28/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"


@interface MHQuestion : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * style;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * object_name;
@property (nonatomic, retain) NSString * attribute_name;
@property (nonatomic, retain) NSNumber * web_only;
@property (nonatomic, retain) NSString * trigger_words;
@property (nonatomic, retain) NSString * notify_via;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSSet *survey;

@end
