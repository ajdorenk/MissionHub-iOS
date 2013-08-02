//
//  MHGenericCell.h
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHGenericCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel		*label;
@property (nonatomic, strong) IBOutlet UIImageView	*checkmark;

-(void)populateWithString:(NSString *)text andSelected:(BOOL)selected;

@end
