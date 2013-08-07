//
//  MHPerson.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/13/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//


#import "MHPerson+Helper.h"
#import "MHCheckbox.h"

@protocol MHPersonCellDelegate;

@interface MHPersonCell : UITableViewCell <MHCheckboxDelegate> {

	id<MHPersonCellDelegate> cellDelegate;
	MHPerson *_person;
	NSIndexPath *_indexPath;
	NSString *_fieldName;
    
}

@property (nonatomic, strong) id<MHPersonCellDelegate> cellDelegate;
@property (nonatomic, strong) MHPerson *person;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *gender;
@property (nonatomic, strong) IBOutlet UIImageView *profilePicture;
@property (nonatomic, strong) IBOutlet MHCheckbox *checkbox;
@property (nonatomic, strong) IBOutlet UIView *nameBackgroundView;

-(void)populateWithPerson:(MHPerson *)person forField:(MHPersonSortFields)sortField atIndexPath:(NSIndexPath *)indexPath;

@end


@protocol MHPersonCellDelegate <NSObject>
@optional
-(void)cell:(MHPersonCell *)cell didSelectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath;
-(void)cell:(MHPersonCell *)cell didDeselectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath;

@end