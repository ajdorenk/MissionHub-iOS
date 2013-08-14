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

@interface MHCreatePersonViewController ()

- (void)configureTextField:(MHTextField *)textField;

- (void)savePerson:(id)sender;
- (void)backToMenu:(id)sender;
- (MHPhoneNumber *)phoneNumber;
- (MHEmailAddress *)emailAddress;
- (MHAddress *)address;
- (MHOrganizationalPermission *)organizationalPermissionLevel;

- (void)changePermissionLevelTo:(NSInteger)level;
- (void)changeGenderTo:(NSInteger)genderId;

- (IBAction)genderDidChange:(UISegmentedControl *)genderControl;
- (IBAction)permissionLevelDidChange:(UISegmentedControl *)permissionLevelControl;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

- (void)done:(id)sender;
- (void)clearKeyboard;

- (void)updateInterface;
- (void)updateGender;
- (void)updatePermissionLevel;

@end

@implementation MHCreatePersonViewController

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

    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
    
    
    UIImage* saveImage = [UIImage imageNamed:@"MH_Mobile_Button_Save_72.png"];
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [save setImage:saveImage forState:UIControlStateNormal];
    [save addTarget:self action:@selector(savePerson:) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
	
	UIImage* doneImage = [UIImage imageNamed:@"MH_Mobile_Button_Done_72.png"];
	
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [done setImage:doneImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton = [[UIBarButtonItem alloc] initWithCustomView:done];
    
    
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
	
	if (self.person.gender) {
		
		if ([self.person.gender caseInsensitiveCompare:@"Female"] == NSOrderedSame) {
			[self changeGenderTo:1];
		} else if ([self.person.gender caseInsensitiveCompare:@"Male"] == NSOrderedSame) {
			[self changeGenderTo:0];
		} else {
			[self changeGenderTo:0];
		}
		
	} else {
		[self changeGenderTo:0];
	}
	
}

- (void)updatePermissionLevel {
	
	if (self.person.permissionLevel) {
		
		switch ([self.person.permissionLevel.permission_id integerValue]) {
				
			case MHPermissionLevelRemoteIdAdmin:
				
				[self changePermissionLevelTo:0];
				
				break;
			case MHPermissionLevelRemoteIdUser:
				
				[self changePermissionLevelTo:1];
				
				break;
			case MHPermissionLevelRemoteIdNoPermissions:
				
				[self changePermissionLevelTo:2];
				
				break;
				
			default:
				
				[self changePermissionLevelTo:2];
				
				break;
		}
		
	} else {
		
		
		
	}
	
}

- (void)savePerson:(id)sender {
	
	NSError *error;
	
	if ([self.person validateForServerCreate:&error]) {
		
		[[MHAPI sharedInstance] createPerson:self.person withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			[self.navigationController popViewControllerAnimated:YES];
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {
			
			[MHErrorHandler presentError:error];
			
		}];
		
	} else {
		
		[MHErrorHandler presentError:error];
		
	}
	
}

- (void)backToMenu:(id)sender {
	
    [self.navigationController popViewControllerAnimated:YES];
	
}

- (MHPhoneNumber *)phoneNumber {
	
	MHPhoneNumber *phoneNumber;
	
	if ([self.person.phoneNumbers count]) {
		
		phoneNumber = [[self.person.phoneNumbers allObjects] objectAtIndex:0];
		
	} else {
		
		phoneNumber = [MHPhoneNumber newObjectFromFields:@{@"primary": @1}];
		[self.person addPhoneNumbersObject:phoneNumber];
		
	}
	
	return phoneNumber;
	
}

- (MHEmailAddress *)emailAddress {
	
	MHEmailAddress *emailAddress;
	
	if ([self.person.emailAddresses count]) {
		
		emailAddress = [[self.person.emailAddresses allObjects] objectAtIndex:0];
		
	} else {
		
		emailAddress = [MHEmailAddress newObjectFromFields:@{@"primary": @1}];
		[self.person addEmailAddressesObject:emailAddress];
		
	}
	
	return emailAddress;
	
}

- (MHAddress *)address {
	
	MHAddress *address;
	
	if ([self.person.addresses count]) {
		
		address = [[self.person.addresses allObjects] objectAtIndex:0];
		
	} else {
		
		address = [MHAddress newObjectFromFields:nil];
		[self.person addAddressesObject:address];
		
	}
	
	return address;
	
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
	CGRect newRect				= CGRectZero;
	NSDictionary* keyboardInfo	= [notification userInfo];
    NSValue* keyboardFrameValue	= [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	CGRect keyboardFrame		= [keyboardFrameValue CGRectValue];
    self.originalContentFrame	= self.scrollView.frame;
	
    //Down size your text view
	newRect.size.width	= CGRectGetWidth(self.view.frame);
    newRect.size.height = CGRectGetHeight(self.view.frame) - CGRectGetHeight(keyboardFrame);
	
	[UIView beginAnimations:nil context:nil];
	
    self.scrollView.frame = newRect;
	
    [UIView commitAnimations];
	/*
	self.oldSize				= self.scrollView.frame;
	
	CGFloat newHeight			= ( self.scrollView.contentSize.height + self.scrollView.contentOffset.y < CGRectGetMaxY(self.view.frame) + CGRectGetHeight(keyboardFrame) ? CGRectGetMaxY(self.view.frame) + CGRectGetHeight(keyboardFrame) - self.scrollView.contentOffset.y : self.scrollView.contentSize.height );
	
	newContentSize.height		= newHeight;
    newContentOffset.y			+= CGRectGetMinY(keyboardFrame);
	
	self.scrollView.contentSize	= newContentSize;
	 */
	//[self.scrollView setContentOffset:newContentOffset animated:YES];
	
	self.originalContentOffset	= self.scrollView.contentOffset;
	
	NSLog(@"%f > %f + %f (%f)", CGRectGetMaxY(self.activeTextField.frame), CGRectGetMaxY(self.scrollView.frame), self.scrollView.contentOffset.y, CGRectGetMaxY(self.scrollView.frame) + self.scrollView.contentOffset.y);
	
	if (CGRectGetMaxY(self.activeTextField.frame) > CGRectGetMaxY(self.scrollView.frame) + self.scrollView.contentOffset.y) {
		
		CGPoint newContentOffset	= self.scrollView.contentOffset;
		newContentOffset.y			= CGRectGetMaxY(self.activeTextField.frame) - ( CGRectGetHeight(keyboardFrame) * 0.5 );
		[self.scrollView setContentOffset:newContentOffset animated:YES];
		
	}
	
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.doneButton, nil]];
	
}

- (void)keyboardWillHide:(NSNotification *)notification {
    /*
	CGPoint newContentOffset	= self.scrollView.contentOffset;
	NSDictionary* keyboardInfo	= [notification userInfo];
    NSValue* keyboardFrameValue	= [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	CGRect keyboardFrame		= [keyboardFrameValue CGRectValue];
	
    newContentOffset.y			-= CGRectGetMinY(keyboardFrame);
	
	self.scrollView.contentSize	= self.oldSize;
	[self.scrollView setContentOffset:newContentOffset animated:YES];
	*/
	[UIView setAnimationBeginsFromCurrentState:YES];
	
    self.scrollView.frame = self.originalContentFrame;
	
    [UIView commitAnimations];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
