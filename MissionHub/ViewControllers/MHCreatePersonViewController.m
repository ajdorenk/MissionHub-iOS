//
//  MHCreatePersonViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHCreatePersonViewController.h"
#import "MHAPI.h"
#import "MHOrganization+Helper.h"
#import "MHToolbar.h"

CGFloat const MHCreatePersonViewControllerMarginVertical			= 20.0;
CGFloat const MHCreatePersonViewControllerViewMarginHorizontal		= 20.0f;
CGFloat const MHCreatePersonViewControllerViewMarginVertical		= 10.0f;
CGFloat const MHCreatePersonViewControllerLabelMarginTop			= 2.0f;
CGFloat const MHCreatePersonViewControllerLabelHeight				= 21.0f;
CGFloat const MHCreatePersonViewControllerTextFieldMarginTop		= 0.0f;
CGFloat const MHCreatePersonViewControllerTextFieldHeight			= 22.0f;
CGFloat const MHCreatePersonViewControllerGenderWidth				= 135.0f;

@interface MHCreatePersonViewController ()

- (void)configureTextField:(MHTextField *)textField;

- (void)savePerson:(id)sender;
- (void)backToMenu:(id)sender;
- (MHPhoneNumber *)phoneNumber;
- (MHEmailAddress *)emailAddress;
- (MHAddress *)address;
- (MHOrganizationalPermission *)organizationalPermissionLevel;

- (void)removePhoneNumberIfEmpty;
- (void)removeEmailAddressIfEmpty;
- (void)removeAddressIfEmpty;

- (void)changePermissionLevelTo:(NSInteger)level;
- (void)changeGenderTo:(NSInteger)genderId;

- (IBAction)genderDidChange:(UISegmentedControl *)genderControl;
- (IBAction)permissionLevelDidChange:(UISegmentedControl *)permissionLevelControl;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

- (void)done:(id)sender;
- (void)clearKeyboard;

- (void)updateLayout;
- (void)updateBarButtons;
- (void)replaceBarButtons;

- (void)updateInterface;
- (void)updateGender;
- (void)updatePermissionLevel;

@end

@implementation MHCreatePersonViewController

@synthesize createPersonDelegate	= _createPersonDelegate;

@synthesize person					= _person;

@synthesize scrollView;
@synthesize oldSize					= _oldSize;
@synthesize originalContentFrame	= _originalContentFrame;
@synthesize originalContentOffset	= _originalContentOffset;
@synthesize activeTextField			= _activeTextField;

@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize phone;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize state;
@synthesize country;
@synthesize zip;
@synthesize gender;
@synthesize permissionLevel;

@synthesize saveButton	= _saveButton;
@synthesize doneButton	= _doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[self updateBarButtons];
	[self updateLayout];
	
}

-(void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
}

-(void)viewWillDisappear:(BOOL)animated {
	
	[self clearKeyboard];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification
												  object:nil];
	
	[super viewWillDisappear:animated];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	if (!self.person) {
		
		self.person = [MHPerson newObjectFromFields:nil];
		
	}

    [self replaceBarButtons];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.saveButton, nil]];
	
	[self configureTextField:self.firstName];
	[self configureTextField:self.lastName];
	[self configureTextField:self.email];
	[self configureTextField:self.phone];
	[self configureTextField:self.address1];
	[self configureTextField:self.address2];
	[self configureTextField:self.city];
	[self configureTextField:self.state];
	[self configureTextField:self.country];
	[self configureTextField:self.zip];

}

- (void)configureTextField:(MHTextField *)textField {
	
	textField.textInset				= UIEdgeInsetsMake(2, 10, 0, 0);
	textField.editingTextInset		= UIEdgeInsetsMake(2, 10, 0, 0);
	textField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    textField.layer.borderColor		= [[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1] CGColor];
    textField.layer.borderWidth		= 1.0f;
	textField.textColor				= [UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1];
	textField.font					= [UIFont fontWithName:@"Arial-ItalicMT" size:14.0];
	textField.delegate				= self;
	
}

- (void)updateWithPerson:(MHPerson *)person {
	
	self.person = person;
	
	[self updateInterface];
	
}

- (void)updateLayout {
	
	self.scrollView.frame			= self.view.frame;
	
	self.firstNameLabel.frame			= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerViewMarginVertical,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.firstName.frame				= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.firstNameLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.lastNameLabel.frame			= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.firstName.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.lastName.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.lastNameLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.genderLabel.frame				= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.lastName.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.gender.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.genderLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 MHCreatePersonViewControllerGenderWidth,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.emailLabel.frame				= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.gender.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.email.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.emailLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.phoneLabel.frame				= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.email.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.phone.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.phoneLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.address1Label.frame			= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.phone.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.address1.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.address1Label.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.address2Label.frame			= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.address1.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.address2.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.address2Label.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.cityLabel.frame				= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.address2.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.city.frame						= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.cityLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.stateLabel.frame				= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.city.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.state.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.stateLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.countryLabel.frame				= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.state.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.country.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.countryLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.zipLabel.frame					= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.country.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.zip.frame						= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.zipLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.permissionLevelLabel.frame		= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.zip.frame) + MHCreatePersonViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerLabelHeight);
	self.permissionLevel.frame			= CGRectMake(MHCreatePersonViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.permissionLevelLabel.frame) + MHCreatePersonViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHCreatePersonViewControllerViewMarginHorizontal,
													 MHCreatePersonViewControllerTextFieldHeight);
	
	self.scrollView.contentSize		= CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.permissionLevel.frame) + MHCreatePersonViewControllerMarginVertical);
	self.scrollView.contentOffset	= CGPointZero;
	
	if (CGRectGetHeight(self.view.frame) > self.scrollView.contentSize.height) {
		
		self.scrollView.scrollEnabled	= NO;
		
	} else {
		
		self.scrollView.scrollEnabled	= YES;
		
	}
	
	[self clearKeyboard];
	
	self.navigationItem.rightBarButtonItem	= self.saveButton;
	
}

- (void)updateBarButtons {
	
	//replace the right button that is already there
	if ([self.navigationItem.rightBarButtonItem isEqual:self.saveButton]) {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.saveButton;
		
	} else if ([self.navigationItem.rightBarButtonItem isEqual:self.doneButton]) {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.doneButton;
		
	} else {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.saveButton;
		
	}
	
}

- (void)replaceBarButtons {
	
	//replace the left button
	self.navigationItem.leftBarButtonItem	= [MHToolbar barButtonWithStyle:MHToolbarStyleBack target:self selector:@selector(backToMenu:) forBar:self.navigationController.navigationBar];
	
	//create all the other buttons for later use
    self.saveButton							= [MHToolbar barButtonWithStyle:MHToolbarStyleSave target:self selector:@selector(savePerson:) forBar:self.navigationController.navigationBar];
	self.doneButton							= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(done:) forBar:self.navigationController.navigationBar];
	
}

- (void)updateInterface {
	
	self.firstName.text = self.person.first_name	? self.person.first_name	:	@"";
	self.lastName.text	= self.person.last_name		? self.person.last_name		:	@"";
	self.email.text		= [self emailAddress].email ? [self emailAddress].email :	@"";
	self.phone.text		= [self phoneNumber].number ? [self phoneNumber].number :	@"";
	self.address1.text	= [self address].address1	? [self address].address1	:	@"";
	self.address2.text	= [self address].address2	? [self address].address2	:	@"";
	self.city.text		= [self address].city		? [self address].city		:	@"";
	self.state.text		= [self address].state		? [self address].state		:	@"";
	self.country.text	= [self address].country	? [self address].country	:	@"";
	self.zip.text		= [self address].zip		? [self address].zip		:	@"";
	
	[self updateGender];
	[self updatePermissionLevel];
	
}

- (void)updateGender {
	
	NSInteger selection = 0;
	
	if (self.person.gender) {
		
		if ([self.person.gender caseInsensitiveCompare:@"Female"] == NSOrderedSame) {
			selection = 1;
		} else if ([self.person.gender caseInsensitiveCompare:@"Male"] == NSOrderedSame) {
			selection = 0;
		}
		
	}
	
	[self changeGenderTo:selection];
	self.gender.selectedSegmentIndex = selection;
	
}

- (void)updatePermissionLevel {
	
	NSInteger selection = 2;
	
	if (self.person.permissionLevel) {
		
		switch ([self.person.permissionLevel.permission_id integerValue]) {
				
			case MHPermissionLevelRemoteIdAdmin:
				
				selection = 0;
				
				break;
			case MHPermissionLevelRemoteIdUser:
				
				selection = 1;
				
				break;
			case MHPermissionLevelRemoteIdNoPermissions:
				
				selection = 2;
				
				break;
				
			default:
				
				selection = 2;
				
				break;
		}
		
	}
	
	[self changePermissionLevelTo:selection];
	self.permissionLevel.selectedSegmentIndex = selection;
	
}

- (void)savePerson:(id)sender {
	
	NSError *error;
	
	[self removeAddressIfEmpty];
	[self removeEmailAddressIfEmpty];
	[self removePhoneNumberIfEmpty];
	
	self.saveButton.enabled = NO;
	
	if ([self.person validateForServerCreate:&error]) {
		
		[[MHAPI sharedInstance] createPerson:self.person withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			MHPerson *person = [result objectAtIndex:0];
			
			if ([self.createPersonDelegate respondsToSelector:@selector(controller:didCreatePerson:)]) {
				
				[self.createPersonDelegate controller:self didCreatePerson:person];
				
			}
			
			self.saveButton.enabled = YES;
			
			[self.navigationController popViewControllerAnimated:YES];
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {
			
			[MHErrorHandler presentError:error];
			
			self.saveButton.enabled = YES;
			
		}];
		
	} else {
		
		[MHErrorHandler presentError:error];
		
		self.saveButton.enabled = YES;
		
	}
	
}

- (void)backToMenu:(id)sender {
	
    [self.navigationController popViewControllerAnimated:YES];
	
}

- (MHPhoneNumber *)phoneNumber {
	
	MHPhoneNumber *phoneNumber;
	
	if ([self.person.phoneNumbers count] > 0) {
		
		phoneNumber = [[self.person.phoneNumbers allObjects] objectAtIndex:0];
		
	} else {
		
		phoneNumber = [MHPhoneNumber newObjectFromFields:@{@"primary": @1}];
		[self.person addPhoneNumbersObject:phoneNumber];
		
	}
	
	return phoneNumber;
	
}

- (void)removePhoneNumberIfEmpty {
	
	MHPhoneNumber *phoneNumber;
	
	if ([self.person.phoneNumbers count] > 0) {
		
		phoneNumber = [[self.person.phoneNumbers allObjects] objectAtIndex:0];
		
		if ( phoneNumber && !phoneNumber.number.length ) {
			
			[self.person removePhoneNumbersObject:phoneNumber];
			
		}
		
	}
	
}

- (MHEmailAddress *)emailAddress {
	
	MHEmailAddress *emailAddress;
	
	if ([self.person.emailAddresses count] > 0) {
		
		emailAddress = [[self.person.emailAddresses allObjects] objectAtIndex:0];
		
	} else {
		
		emailAddress = [MHEmailAddress newObjectFromFields:@{@"primary": @1}];
		[self.person addEmailAddressesObject:emailAddress];
		
	}
	
	return emailAddress;
	
}

- (void)removeEmailAddressIfEmpty {
	
	MHEmailAddress *emailAddress;
	
	if ([self.person.emailAddresses count] > 0) {
		
		emailAddress = [[self.person.emailAddresses allObjects] objectAtIndex:0];
		
		if ( emailAddress && !emailAddress.email.length ) {
			
			[self.person removeEmailAddressesObject:emailAddress];
			
		}
		
	}
	
}

- (MHAddress *)address {
	
	MHAddress *address;
	
	if ([self.person.addresses count] > 0) {
		
		address = [[self.person.addresses allObjects] objectAtIndex:0];
		
	} else {
		
		address = [MHAddress newObjectFromFields:@{@"address_type": @"current"}];
		[self.person addAddressesObject:address];
		
	}
	
	return address;
	
}

- (void)removeAddressIfEmpty {
	
	MHAddress *address;
	
	if ([self.person.addresses count] > 0) {
		
		address = [[self.person.addresses allObjects] objectAtIndex:0];
		
		if ( address &&
			!address.address1.length &&
			!address.address2.length &&
			!address.city.length &&
			!address.state.length &&
			!address.country.length &&
			!address.zip.length
			) {
			
			[self.person removeAddressesObject:address];
			
		}
		
	}
	
}

- (MHOrganizationalPermission *)organizationalPermissionLevel {
	
	if (!self.person.permissionLevel) {
		
		self.person.permissionLevel = [MHOrganizationalPermission newObjectFromFields:nil];
		
		self.person.permissionLevel.permission		= [[MHAPI sharedInstance].currentUser.currentOrganization permissionLevelWithRemoteID:MHPermissionLevelRemoteIdNoPermissions];
		self.person.permissionLevel.permission_id	= self.person.permissionLevel.permission.remoteID;
		self.person.permissionLevel.created_at		= [NSDate date];
		self.person.permissionLevel.updated_at		= [NSDate date];
		self.person.permissionLevel.start_date		= [NSDate date];
		
	}
	
	return self.person.permissionLevel;
	
}

- (void)changePermissionLevelTo:(NSInteger)level {
	
	switch (level) {
		case 0:
			[self organizationalPermissionLevel].permission		= [[MHAPI sharedInstance].currentUser.currentOrganization permissionLevelWithRemoteID:MHPermissionLevelRemoteIdAdmin];
			break;
		case 1:
			[self organizationalPermissionLevel].permission		= [[MHAPI sharedInstance].currentUser.currentOrganization permissionLevelWithRemoteID:MHPermissionLevelRemoteIdUser];
			break;
			
		default:
			[self organizationalPermissionLevel].permission		= [[MHAPI sharedInstance].currentUser.currentOrganization permissionLevelWithRemoteID:MHPermissionLevelRemoteIdNoPermissions];
			break;
	}
																   
	[self organizationalPermissionLevel].permission_id	= [self organizationalPermissionLevel].permission.remoteID;
	
}

- (void)changeGenderTo:(NSInteger)genderId {
	
	switch (genderId) {
		case 0:
			self.person.gender = @"Male";
			break;
		case 1:
			self.person.gender = @"Female";
			break;
			
		default:
			self.person.gender = @"Male";
			break;
	}
	
}

- (IBAction)genderDidChange:(UISegmentedControl *)genderControl {

	[self changeGenderTo:genderControl.selectedSegmentIndex];
	
}

- (IBAction)permissionLevelDidChange:(UISegmentedControl *)permissionLevelControl {
	
	[self changePermissionLevelTo:permissionLevelControl.selectedSegmentIndex];
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	self.activeTextField		= textField;
	
}

-(void)keyboardWillShow:(NSNotification *)notification {
	
    //CGPoint newContentOffset	= self.scrollView.contentOffset;
	//CGSize newContentSize		= self.scrollView.contentSize;
	__block CGRect newRect		= CGRectZero;
	NSDictionary* keyboardInfo	= [notification userInfo];
    NSValue* keyboardFrameValue	= [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	CGRect keyboardFrame		= [keyboardFrameValue CGRectValue];
    self.originalContentFrame	= self.scrollView.frame;
	
    //Down size your text view
	newRect.size.width	= CGRectGetWidth(self.view.frame);
    newRect.size.height = CGRectGetHeight(self.view.frame) - CGRectGetHeight(keyboardFrame);
	
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		
		self.scrollView.frame = newRect;
		
	} completion:nil];
	
	self.originalContentOffset	= self.scrollView.contentOffset;
	
	if (CGRectGetMaxY(self.activeTextField.frame) > CGRectGetHeight(self.scrollView.frame) + self.scrollView.contentOffset.y) {
		
		CGPoint newContentOffset	= self.scrollView.contentOffset;
		newContentOffset.y			= CGRectGetMaxY(self.activeTextField.frame) - ( CGRectGetHeight(keyboardFrame) * 0.5 );
		[self.scrollView setContentOffset:newContentOffset animated:YES];
		
	}
	
	[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.doneButton, nil]];
	
}

- (void)keyboardWillHide:(NSNotification *)notification {
	
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		
		self.scrollView.frame			= self.originalContentFrame;
		[self.scrollView setContentOffset:self.originalContentOffset animated:YES];
		
	} completion:nil];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	
	if ([textField isEqual:self.firstName]) {
		
		self.person.first_name		= textField.text;
		
	} else if ([textField isEqual:self.lastName]) {
		
		self.person.last_name		= textField.text;
		
	} else if ([textField isEqual:self.email]) {
		
		[self emailAddress].email	= textField.text;
		
	} else if ([textField isEqual:self.phone]) {
		
		[self phoneNumber].number	= textField.text;
		
	} else if ([textField isEqual:self.address1]) {
		
		[self address].address1		= textField.text;
		
	} else if ([textField isEqual:self.address2]) {
		
		[self address].address2		= textField.text;
		
	} else if ([textField isEqual:self.city]) {
		
		[self address].city			= textField.text;
		
	} else if ([textField isEqual:self.state]) {
		
		[self address].state		= textField.text;
		
	} else if ([textField isEqual:self.country]) {
		
		[self address].country		= textField.text;
		
	} else if ([textField isEqual:self.zip]) {
		
		[self address].zip			= textField.text;
		
	}
	
	[self.scrollView setContentOffset:self.originalContentOffset animated:YES];
	
	self.activeTextField			= nil;
	
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    [self clearKeyboard];
    
    return NO;
}

-(void)done:(id)sender {
	
	[self clearKeyboard];
	
}

-(void)clearKeyboard {
	
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
	
	[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.saveButton, nil]];
	
}

#pragma mark - orientation methods

- (NSUInteger)supportedInterfaceOrientations {
	
    return UIInterfaceOrientationMaskAll;
	
}

- (BOOL)shouldAutorotate {
	
    return YES;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	
    return YES;
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self updateBarButtons];
	[self updateLayout];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
