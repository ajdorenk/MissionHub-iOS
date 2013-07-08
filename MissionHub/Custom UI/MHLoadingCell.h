//
//  MHLoadingCell.h
//  MissionHub
//
//  Created by Michael Harrison on 7/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHLoadingCell : UITableViewCell {
	
	UIActivityIndicatorView *_loadingIndicator;
	
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIndicator;

-(id)startLoading;
-(id)stopLoading;

@end
