//
//  MHGenericCell.h
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBlankCheckbox.h"

@protocol MHGenericCellDelegate;

@interface MHGenericCell : UITableViewCell <MHCheckboxDelegate>

@property (nonatomic, weak) id<MHGenericCellDelegate>	cellDelegate;
@property (nonatomic, strong) NSIndexPath				*indexPath;
@property (nonatomic, strong) id						object;
@property (nonatomic, weak) IBOutlet UILabel			*label;
@property (nonatomic, weak) IBOutlet MHBlankCheckbox	*checkmark;

-(void)populateWithTitle:(NSString *)text forObject:(id)object andSelected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MHGenericCellDelegate <NSObject>
@optional
-(void)cell:(MHGenericCell *)cell didSelectPerson:(id)object atIndexPath:(NSIndexPath *)indexPath;
-(void)cell:(MHGenericCell *)cell didDeselectPerson:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end
