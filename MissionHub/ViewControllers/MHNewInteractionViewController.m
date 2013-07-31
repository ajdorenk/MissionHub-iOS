//
//  MHNewInteractionViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/9/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//


#import "MHNewInteractionViewController.h"
#import "MHInteraction+Helper.h"
#import "MHAPI.h"


//TODO:The sizing for this view controller needs to be adjusted on the storyboard for the iPad. This might be another place in which a popover would be better for the iPad.

@interface MHNewInteractionViewController ()

-(MHGenericListViewController *)initiatorsList;
-(MHGenericListViewController *)receiversList;
-(UIPickerView *)interactionTypePicker;
-(UIPickerView *)visibilityPicker;
-(UIDatePicker *)timestampPicker;

-(void)updateInterface;
-(void)updateInterfaceForInitiators;
-(void)updateInterfaceForInteractionType;
-(void)updateInterfaceForReceiver;
-(void)updateInterfaceForVisibility;
-(void)updateInterfaceForTimestamp;
-(void)updateInterfaceForComment;

-(void)chooseInitiator:(id)sender;
-(void)chooseInteractionType:(id)sender;
-(void)chooseReceiver:(id)sender;
-(void)chooseVisibility:(id)sender;
-(void)chooseDate:(id)sender;

-(void)timestampChanged:(UIDatePicker *)sender;
-(void)doneWithInteractionType:(id)sender;
-(void)doneWithVisibility:(id)sender;
-(void)doneWithDate:(id)sender;
-(void)doneWithComment:(id)sender;

-(void)clearPickers;

-(void)backToMenu:(id)sender;

@end

@implementation MHNewInteractionViewController

@synthesize doneWithInteractionTypeButton, doneWithVisibilityButton, doneWithDateButton, doneWithCommentButton, saveButton;

@synthesize interaction				= _interaction;
@synthesize interactionTypeArray	= _interactionTypeArray;
@synthesize visibilityArray			= _visibilityArray;

//buttons in storyboard
@synthesize initiator, interactionType, receiver, visibility, dateTime, comment, originalCommentFrame = _originalCommentFrame;
//lazy loaded lists/pickers for each type
@synthesize _initiatorsList, _interactionTypePicker, _receiversList, _visibilityPicker, _timestampPicker;

#pragma mark - initialization

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {

	[self clearPickers];
	
	[super viewDidDisappear:animated];
	
}

-(void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.comment setDelegate:self];
	
    self.interaction = [MHInteraction newObjectFromFields:nil];
	
	NSString *orgName = ([[[[MHAPI sharedInstance] currentUser] currentOrganization] name] ? [[[[MHAPI sharedInstance] currentUser] currentOrganization] name] : @"");
	
	self.visibilityArray = [NSMutableArray arrayWithArray:@[
							@{@"value": @"everyone",		@"title": @"Everyone"},
							@{@"value": @"parent",			@"title": [NSString stringWithFormat:@"Everyone in Parent of %@", orgName]}, //TODO: on login grab the name of the parent org and use it here
							@{@"value": @"organization",	@"title": [NSString stringWithFormat:@"Everyone in %@", orgName]},
							@{@"value": @"admins",			@"title": [NSString stringWithFormat:@"Admins in %@", orgName]},
							@{@"value": @"me",				@"title": @"Only Me"}
							]];
	
	self.interactionTypeArray = [NSMutableArray arrayWithArray:
								 ([[[[MHAPI sharedInstance] currentUser] currentOrganization] interactionTypes] ?
																[[[[[MHAPI sharedInstance] currentUser] currentOrganization] interactionTypes] allObjects] :
																@[])];
	[self.interactionTypeArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"i18n" ascending:YES]]];
	
    
    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
    
    
    UIImage* saveImage = [UIImage imageNamed:@"MH_Mobile_Button_Save_72.png"];
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [save setImage:saveImage forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveInteraction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
	
	UIImage* doneImage = [UIImage imageNamed:@"MH_Mobile_Button_Done_72.png"];
	
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [done setImage:doneImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneWithInteractionType:) forControlEvents:UIControlEventTouchUpInside];
    self.doneWithInteractionTypeButton = [[UIBarButtonItem alloc] initWithCustomView:done];
	
	done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [done setImage:doneImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneWithVisibility:) forControlEvents:UIControlEventTouchUpInside];
	self.doneWithVisibilityButton = [[UIBarButtonItem alloc] initWithCustomView:done];
	
	done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [done setImage:doneImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneWithDate:) forControlEvents:UIControlEventTouchUpInside];
	self.doneWithDateButton = [[UIBarButtonItem alloc] initWithCustomView:done];
	
	done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [done setImage:doneImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneWithComment:) forControlEvents:UIControlEventTouchUpInside];
	self.doneWithCommentButton = [[UIBarButtonItem alloc] initWithCustomView:done];
	
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.saveButton, nil]];
    
    
	//TODO:The initiator button label needs to be preset to the current user's name and the receiver needs to be preset if the interaction button is pressed from a profile, (as opposed to being pressed from the contact list).
	
    UIImage *whiteButton = [UIImage imageNamed:@"Searchbar_background.png"];
    
    [self.initiator setTintColor:[UIColor clearColor]];
    [self.initiator.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14.0]];
    [self.initiator setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    [self.initiator setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.initiator setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [self.initiator setBackgroundColor:[UIColor clearColor]];
    [self.initiator.layer setBorderWidth:1.0];
    [self.initiator.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1] CGColor]];
    [self.initiator addTarget:self action:@selector(chooseInitiator:) forControlEvents:UIControlEventTouchUpInside];
	
    [self.interactionType setTintColor:[UIColor clearColor]];
	[self.interactionType.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14.0]];
	[self.interactionType setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.interactionType setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [self.interactionType setBackgroundColor:[UIColor clearColor]];
    [self.interactionType.layer setBorderWidth:1.0];
    [self.interactionType.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    [self.interactionType addTarget:self action:@selector(chooseInteractionType:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.receiver setTintColor:[UIColor clearColor]];
	[self.receiver.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14.0]];
	[self.receiver setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.receiver setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [self.receiver setBackgroundColor:[UIColor clearColor]];
    [self.receiver.layer setBorderWidth:1.0];
    [self.receiver.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    [self.receiver addTarget:self action:@selector(chooseReceiver:) forControlEvents:UIControlEventTouchUpInside];
	
    [self.visibility setTintColor:[UIColor clearColor]];
	[self.visibility.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14.0]];
	[self.visibility setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.visibility setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [self.visibility setBackgroundColor:[UIColor clearColor]];
    [self.visibility.layer setBorderWidth:1.0];
    [self.visibility.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    [self.visibility addTarget:self action:@selector(chooseVisibility:) forControlEvents:UIControlEventTouchUpInside];
	
    [self.dateTime setTintColor:[UIColor clearColor]];
	[self.dateTime.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:18.0]];
	[self.dateTime setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.dateTime setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [self.dateTime setBackgroundColor:[UIColor clearColor]];
    [self.dateTime.layer setBorderWidth:1.0];
    [self.dateTime.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    [self.dateTime addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    
	self.comment.font					= [UIFont fontWithName:@"Arial-ItalicMT" size:14.0];
	self.comment.textColor				= [UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1];
    self.comment.layer.backgroundColor	= [[UIColor whiteColor] CGColor];
    self.comment.layer.borderColor		= [[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.comment.layer.borderWidth		= 1.0f;
	self.comment.returnKeyType			= UIReturnKeyDone;
	self.comment.clearButtonMode		= UITextFieldViewModeNever;
    
    self.originalCommentFrame = self.comment.frame;
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
	[self updateInterface];
	
}

#pragma mark - accessor methods/model methods

-(void)updateWithInteraction:(MHInteraction *)interaction {
	
	self.interaction = interaction;
	
	[self updateInterface];
	
}

-(void)saveInteraction {
	
	
	
}

#pragma mark - update UI methods

-(void)updateInterface {
	
	[self updateInterfaceForInitiators];
	[self updateInterfaceForInteractionType];
	[self updateInterfaceForReceiver];
	[self updateInterfaceForVisibility];
	[self updateInterfaceForTimestamp];
	[self updateInterfaceForComment];
	
}

-(void)updateInterfaceForInitiators {
	
	NSString *textForInitiatorButton = @"";
	
	if ([self.interaction.initiators count] == 1) {
		
		textForInitiatorButton = [[[self.interaction.initiators allObjects] objectAtIndex:0] fullName];
		
	}
	
	if ([self.interaction.initiators count] > 1) {
		
		textForInitiatorButton = [NSString stringWithFormat:@"%@ [+%d]", [[[self.interaction.initiators allObjects] objectAtIndex:0] fullName], [self.interaction.initiators count] - 1];
		
	}
    
    [self.initiator setTitle:textForInitiatorButton forState:UIControlStateNormal];
	
}

-(void)updateInterfaceForInteractionType {
	
	if ([self.interaction type]) {
		
		NSString *name = [[self.interaction type] name];
		NSString *icon = [[self.interaction type] icon];
		
		[self.interactionType setTitle:(name ? name : @"") forState:UIControlStateNormal];
		
		if (icon) {
			self.interactionTypeIcon.hidden			= NO;
			[self.interactionTypeIcon setImage:[UIImage imageNamed:icon]];
		} else {
			self.interactionTypeIcon.hidden			= YES;
		}
		
		
	} else {
		
		self.interactionTypeIcon.hidden			= YES;
		self.interactionType.titleLabel.text	= @"";
		
	}
	
}

-(void)updateInterfaceForReceiver {
	
	NSString *textForReceiverButton = @"";
	
	if (self.interaction.receiver) {
		
		textForReceiverButton = [self.interaction.receiver fullName];
		
	}
    
    [self.initiator setTitle:textForReceiverButton forState:UIControlStateNormal];
	
}

-(void)updateInterfaceForVisibility {
	
	if ([self.interaction privacy_setting]) {
		
		__block NSString *visibilityString = @"";
		
		[self.visibilityArray enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger index, BOOL *stop) {
			
			NSString *value = [object objectForKey:@"value"];
			NSString *title = [object objectForKey:@"title"];
			
			if ([value isEqualToString:[self.interaction privacy_setting]]) {
				visibilityString = title;
				*stop = YES;
			}
			
		}];
		
		[self.visibility setTitle:visibilityString forState:UIControlStateNormal];
		
	} else {
		
		[self.visibility setTitle:@"" forState:UIControlStateNormal];
		
	}
	
}

-(void)updateInterfaceForTimestamp {
	
	NSDate *date = self.interaction.timestamp;
	
	if (date) {
		
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		
		dateFormatter.dateFormat = @"dd MMM yyyy                   hh:mm a";
		
		[self.dateTime setTitle: [dateFormatter stringFromDate:date] forState: UIControlStateNormal];
		
	}
	
}

-(void)updateInterfaceForComment {
	
	NSString *commentString = [self.interaction comment];
	
	if (commentString) {
		
		self.comment.text = commentString;
		
	}
	
}

#pragma mark - lazy loaded UI

-(MHGenericListViewController *)initiatorsList {
	
	if (self._initiatorsList == nil) {
		
		self._initiatorsList = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		self._initiatorsList.selectionDelegate = self;
		[self._initiatorsList setListTitle:@"Initiator(s)"];
		//TODO: load list of all people
	}
	
	return self._initiatorsList;
	
}

-(MHGenericListViewController *)receiversList {
	
	if (self._receiversList == nil) {
		
		self._receiversList = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		self._receiversList.selectionDelegate = self;
		[self._receiversList setListTitle:@"Receiver"];
		//TODO: load list of all people
	}
	
	return self._receiversList;
	
}

-(UIPickerView *)interactionTypePicker {
	
	if (self._interactionTypePicker == nil) {
		
		self._interactionTypePicker = [[UIPickerView alloc] init];
		self._interactionTypePicker.delegate = self;
		self._interactionTypePicker.dataSource = self;
		self._interactionTypePicker.showsSelectionIndicator = YES;
		
	}
	
	return self._interactionTypePicker;
	
}

-(UIPickerView *)visibilityPicker {
	
	if (self._visibilityPicker == nil) {
		
		self._visibilityPicker = [[UIPickerView alloc] init];
		self._visibilityPicker.delegate = self;
		self._visibilityPicker.dataSource = self;
		self._visibilityPicker.showsSelectionIndicator = YES;
		
	}
	
	return self._visibilityPicker;
	
}

-(UIDatePicker *)timestampPicker {
	
	if (self._timestampPicker == nil) {
		
		self._timestampPicker = [[UIDatePicker alloc] init];
		[self._timestampPicker addTarget:self action:@selector(timestampChanged:) forControlEvents:UIControlEventValueChanged];
		self._timestampPicker.backgroundColor	= [UIColor blackColor];
		
	}
	
	return self._timestampPicker;
	
}

//TODO:The lists for choosing the initiator(s), interaction, receiver, and visibility are currently all empty. I wasn't quite sure where to put this, but somehow the options need to be loaded when the generic list is pushed onto the view.
#pragma mark - launch UI to choose value

-(void)chooseInitiator:(id)sender{
    
    [self.navigationController pushViewController:[self initiatorsList] animated:YES];
    
}


-(void)chooseInteractionType:(id)sender {
    
	[self.view addSubview:[self interactionTypePicker]];
	
	__block CGRect pickerFrame = [self interactionTypePicker].frame;
	
	[self interactionTypePicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
													CGRectGetMaxY(self.view.frame),
													CGRectGetWidth(pickerFrame),
													CGRectGetHeight(pickerFrame));
	
	[UIView animateWithDuration:0.2 animations:^{
		
		[self interactionTypePicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
														CGRectGetMaxY(self.view.frame) - CGRectGetHeight(pickerFrame),
														CGRectGetWidth(pickerFrame),
														CGRectGetHeight(pickerFrame));
		
	}];
	
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.doneWithInteractionTypeButton, nil]];
    
}


-(void)chooseReceiver:(id)sender {
    
    [self.navigationController pushViewController:[self receiversList] animated:YES];

}


-(void)chooseVisibility:(id)sender {

    [self.view addSubview:[self visibilityPicker]];
	
	__block CGRect pickerFrame = [self visibilityPicker].frame;
	
	[self visibilityPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
													CGRectGetMaxY(self.view.frame),
													CGRectGetWidth(pickerFrame),
													CGRectGetHeight(pickerFrame));
	
	[UIView animateWithDuration:0.2 animations:^{
		
		[self visibilityPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
														CGRectGetMaxY(self.view.frame) - CGRectGetHeight(pickerFrame),
														CGRectGetWidth(pickerFrame),
														CGRectGetHeight(pickerFrame));
		
	}];
	
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.doneWithVisibilityButton, nil]];
	
}

-(void)chooseDate:(id)sender {
	
	[self.view addSubview:[self timestampPicker]];
	
	__block CGRect pickerFrame = [self timestampPicker].frame;
	
	[self timestampPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
											   CGRectGetMaxY(self.view.frame),
											   CGRectGetWidth(pickerFrame),
											   CGRectGetHeight(pickerFrame));
	
	[UIView animateWithDuration:0.2 animations:^{
		
		[self timestampPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
												   CGRectGetMaxY(self.view.frame) - CGRectGetHeight(pickerFrame),
												   CGRectGetWidth(pickerFrame),
												   CGRectGetHeight(pickerFrame));
		
	}];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.doneWithDateButton, nil]];
    
}

-(void)backToMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - respond to choices

-(void)timestampChanged:(UIDatePicker *)sender {
	
	self.interaction.timestamp = [sender date];
	
	[self updateInterfaceForTimestamp];
	
}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	if ([object isKindOfClass:[MHPerson class]]) {
	
		MHPerson *person = (MHPerson *)object;
		
		[self.navigationController popViewControllerAnimated:YES];
		
		if ([viewController isEqual:[self initiatorsList]]) {
			
			[self.interaction addInitiatorsObject:person];
			[self updateInterfaceForInitiators];
			
		} else if ([viewController isEqual:[self receiversList]]) {
			
			[self.interaction setReceiver:person];
			[self updateInterfaceForReceiver];
			
		}
		
	}
	
}

#pragma mark - Picker view data source

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 0;
	
	if ([pickerView isEqual:[self visibilityPicker]]) {
		
		numRows = [self.visibilityArray count];
		
	} else if ([pickerView isEqual:[self interactionTypePicker]]) {
		
		numRows = [self.interactionTypeArray count];
		
	}
	
    return numRows;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
    NSString *title;
    
	if ([pickerView isEqual:[self visibilityPicker]]) {
		
		NSDictionary *visibilityObject = [self.visibilityArray objectAtIndex:row];
		
		title = [visibilityObject objectForKey:@"title"];
		
	} else if ([pickerView isEqual:[self interactionTypePicker]]) {
		
		id object = [self.interactionTypeArray objectAtIndex:row];
		
		if ([object isKindOfClass:[MHInteractionType class]]) {
			
			title = [(MHInteractionType *)object name];
			
		}
		
	}
	
    return title;
	
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	int sectionWidth = self.view.frame.size.width - 20;
	
	return sectionWidth;
	
}

// Handle the selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
	if ([pickerView isEqual:[self visibilityPicker]]) {
		
		NSDictionary *visibilityObject = [self.visibilityArray objectAtIndex:row];
		
		self.interaction.privacy_setting = [visibilityObject objectForKey:@"value"];
		
		[self updateInterfaceForVisibility];
		
	} else if ([pickerView isEqual:[self interactionTypePicker]]) {
		
		id object = [self.interactionTypeArray objectAtIndex:row];
		
		if ([object isKindOfClass:[MHInteractionType class]]) {
			
			self.interaction.type = (MHInteractionType *)object;
			
		}
		
		[self updateInterfaceForInteractionType];
		
	}
	
}

//TODO:When the comment box moves up for the iPad, it actually moves to far up so that the top is not visible and it's not sized properly so it's also too short. I think this should be easy to fix if you just change the height differently based on whether it's an iPad or iPhone.

-(void)doneWithInteractionType:(id)sender {
	
	__block UIView *pickerView			= [self interactionTypePicker];
	__block CGRect pickerFrame	= pickerView.frame;
	
	[UIView animateWithDuration:0.2 animations:^{
		
		pickerView.frame = CGRectMake(CGRectGetMinX(pickerFrame),
												  CGRectGetMaxY(self.view.frame),
												  CGRectGetWidth(pickerFrame),
												  CGRectGetHeight(pickerFrame));
		
		[self clearPickers];
		
	}];
	
}

-(void)doneWithVisibility:(id)sender {
	
	__block UIView *pickerView			= [self visibilityPicker];
	__block CGRect pickerFrame	= pickerView.frame;
	
	[UIView animateWithDuration:0.2 animations:^{
		
		pickerView.frame = CGRectMake(CGRectGetMinX(pickerFrame),
												  CGRectGetMaxY(self.view.frame),
												  CGRectGetWidth(pickerFrame),
												  CGRectGetHeight(pickerFrame));
		
		[self clearPickers];
		
	}];
	
}

-(void)doneWithDate:(id)sender {
	
	__block UIView *pickerView			= [self timestampPicker];
	__block CGRect pickerFrame	= pickerView.frame;
	
	[UIView animateWithDuration:0.2 animations:^{
		
		pickerView.frame = CGRectMake(CGRectGetMinX(pickerFrame),
												  CGRectGetMaxY(self.view.frame),
												  CGRectGetWidth(pickerFrame),
												  CGRectGetHeight(pickerFrame));
		
		[self clearPickers];
		
	}];
	
}

-(void)doneWithComment:(id)sender {
	
	[self clearPickers];
	
}

-(void)clearPickers {
	
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
	
	if ([[self interactionTypePicker] superview]) {
		[[self interactionTypePicker] removeFromSuperview];
	}
	
	if ([[self visibilityPicker] superview]) {
		[[self visibilityPicker] removeFromSuperview];
	}
	
	if ([[self timestampPicker] superview]) {
		[[self timestampPicker] removeFromSuperview];
	}
	
	[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.saveButton, nil]];
	
}

-(void)keyboardWillShow:(NSNotification *)notification {

    CGRect newRect				= CGRectZero;
	NSDictionary* keyboardInfo	= [notification userInfo];
    NSValue* keyboardFrameValue	= [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	CGRect keyboardFrame		= [keyboardFrameValue CGRectValue];
    self.originalCommentFrame	= self.comment.frame;
	
    //Down size your text view
	newRect.size.width	= self.view.frame.size.width;
    newRect.size.height = CGRectGetMinY(keyboardFrame);
	
	[UIView beginAnimations:nil context:nil];
	
    self.comment.frame = newRect;
	
    [UIView commitAnimations];
	
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.doneWithCommentButton, nil]];
	
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    // Resize your textview when keyboard is going to hide
    [UIView setAnimationBeginsFromCurrentState:YES];
	
    self.comment.frame = self.originalCommentFrame;
	
    [UIView commitAnimations];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
