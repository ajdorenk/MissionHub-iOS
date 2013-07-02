//
//  MHPerson.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/13/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//



@interface MHPerson : NSObject

@property (nonatomic, strong) NSString *name; // name of Person
@property (nonatomic, strong) NSString *gender; // Person gender
@property (nonatomic, strong) NSString *profilePicturePath; // image filename of Person

@end



@interface MHPersonCell : UITableViewCell
/*
{

    IBOutlet UILabel *name;// name of Person
    IBOutlet UILabel *gender;// Person gender
    IBOutlet UIImageView *imageFile; // image filename of Person

    UIImageView *nameBackgroundView = (UIImageView *)[cell viewWithTag:103];
    nameBackgroundView.layer.borderColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0].CGColor;
    nameBackgroundView.layer.borderWidth = 1.0;
    

}
*/

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *gender;
@property (nonatomic, strong) IBOutlet UIImageView *profilePicture;
@property (nonatomic, strong) IBOutlet UIButton *checkbox;
@property (nonatomic, strong) IBOutlet UIView *nameBackgroundView;

-(void)populateCell:(MHPersonCell *)personCell withPerson:(MHPerson *)person;




@end