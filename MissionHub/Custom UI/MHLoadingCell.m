//
//  MHLoadingCell.m
//  MissionHub
//
//  Created by Michael Harrison on 7/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHLoadingCell.h"

@implementation MHLoadingCell

@synthesize loadingIndicator = _loadingIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)startLoading {
	
	[self.loadingIndicator startAnimating];
	
	return self;
}

-(id)stopLoading {
	
	[self.loadingIndicator stopAnimating];
	
	return self;
}

@end
