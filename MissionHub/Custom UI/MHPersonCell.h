//
//  MHPerson.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/13/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//


#import "MHPerson+Helper.h"

@protocol MHPersonCellDelegate;

@interface MHPersonCell : UITableViewCell

@property (nonatomic, weak) id<MHPersonCellDelegate> cellDelegate;
@property (nonatomic, strong) MHPerson *person;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configure;
- (void)populateWithPerson:(MHPerson *)person forField:(MHPersonSortFields)sortField withSelection:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath;

@end


@protocol MHPersonCellDelegate <NSObject>
@optional
- (void)cell:(MHPersonCell *)cell didSelectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath;
- (void)cell:(MHPersonCell *)cell didDeselectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath;

@end