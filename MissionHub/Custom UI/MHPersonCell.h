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

@interface MHPersonCell : UITableViewCell <MHCheckboxDelegate>

@property (nonatomic, weak) id<MHPersonCellDelegate> cellDelegate;
@property (nonatomic, strong) MHPerson *person;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *field;
@property (nonatomic, weak) IBOutlet UIImageView *profilePicture;
@property (nonatomic, weak) IBOutlet MHCheckbox *checkbox;
@property (nonatomic, weak) IBOutlet UIView *nameBackgroundView;

- (void)configure;
-(void)populateWithPerson:(MHPerson *)person forField:(MHPersonSortFields)sortField withSelection:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath;

@end


@protocol MHPersonCellDelegate <NSObject>
@optional
-(void)cell:(MHPersonCell *)cell didSelectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath;
-(void)cell:(MHPersonCell *)cell didDeselectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath;

@end