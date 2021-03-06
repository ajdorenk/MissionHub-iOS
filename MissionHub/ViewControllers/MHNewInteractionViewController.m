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
#import "MHToolbar.h"
#import "MHGoogleAnalyticsTracker.h"
#import "MHTextView.h"

NSString * const MHGoogleAnalyticsTrackerCreateInteractionScreenName	= @"Create Interaction";
NSString * const MHGoogleAnalyticsTrackerCreateInteractionSaveButtonTap	= @"save";
NSString * const MHGoogleAnalyticsTrackerCreateInteractionBackButtonTap	= @"back";
NSString * const MHGoogleAnalyticsTrackerCreateInteractionCancelButtonTap= @"cancel";

CGFloat const MHNewInteractionViewControllerViewMarginHorizontal		= 20.0f;
CGFloat const MHNewInteractionViewControllerViewMarginVertical			= 10.0f;
CGFloat const MHNewInteractionViewControllerLabelMarginTop				= 2.0f;
CGFloat const MHNewInteractionViewControllerLabelHeight					= 21.0f;
CGFloat const MHNewInteractionViewControllerButtonMarginTop				= 0.0f;
CGFloat const MHNewInteractionViewControllerButtonHeight				= 29.0f;
CGFloat const MHNewInteractionViewControllerInteractionTypeIconMargin	= 5.0f;
CGFloat const MHNewInteractionViewControllerInteractionTypeIconHeight	= MHNewInteractionViewControllerButtonHeight - 2 * MHNewInteractionViewControllerInteractionTypeIconMargin;
CGFloat const MHNewInteractionViewControllerInteractionTypeIconWidth	= MHNewInteractionViewControllerInteractionTypeIconHeight;
CGFloat const MHNewInteractionViewControllerTextFieldMarginTop			= MHNewInteractionViewControllerButtonMarginTop;
CGFloat const MHNewInteractionViewControllerTextFieldHeight				= 95.0f;

//TODO:The sizing for this view controller needs to be adjusted on the storyboard for the iPad. This might be another place in which a popover would be better for the iPad.

@interface MHNewInteractionViewController ()

@property (nonatomic, strong) UIBarButtonItem				*doneWithInteractionTypeButton;
@property (nonatomic, strong) UIBarButtonItem				*doneWithVisibilityButton;
@property (nonatomic, strong) UIBarButtonItem				*doneWithDateButton;
@property (nonatomic, strong) UIBarButtonItem				*doneWithCommentButton;
@property (nonatomic, strong) UIBarButtonItem				*saveButton;
@property (nonatomic, assign, readwrite) BOOL				isSaving;

@property (nonatomic, strong) NSMutableArray				*interactionTypeArray;
@property (nonatomic, strong) NSMutableArray				*visibilityArray;
@property (nonatomic, strong) NSMutableArray				*suggestions;
@property (nonatomic, strong) NSMutableArray				*selectionsFromParent;

@property (nonatomic, weak) IBOutlet UIScrollView			*scrollView;
@property (nonatomic, weak) IBOutlet UILabel				*initiatorLabel;
@property (nonatomic, weak) IBOutlet UIButton				*initiator;
@property (nonatomic, weak) IBOutlet UILabel				*interactionTypeLabel;
@property (nonatomic, weak) IBOutlet UIButton				*interactionType;
@property (nonatomic, weak) IBOutlet UIImageView			*interactionTypeIcon;
@property (nonatomic, weak) IBOutlet UILabel				*receiverLabel;
@property (nonatomic, weak) IBOutlet UIButton				*receiver;
@property (nonatomic, weak) IBOutlet UILabel				*visibilityLabel;
@property (nonatomic, weak) IBOutlet UIButton				*visibility;
@property (nonatomic, weak) IBOutlet UILabel				*dateTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton				*dateTime;
@property (nonatomic, weak) IBOutlet UILabel				*commentLabel;
@property (nonatomic, weak) IBOutlet UITextView				*comment;
@property (nonatomic, assign) CGRect						originalCommentFrame;
@property (nonatomic, assign) CGPoint						originalContentOffset;

@property (nonatomic, strong, readonly) MHGenericListViewController	*initiatorsList;
@property (nonatomic, strong, readonly) UIPickerView				*interactionTypePicker;
@property (nonatomic, strong, readonly) MHGenericListViewController	*receiversList;
@property (nonatomic, strong, readonly) UIPickerView				*visibilityPicker;
@property (nonatomic, strong, readonly) UIDatePicker				*timestampPicker;

-(void)updateBarButtons;
-(void)updateLayout;
-(void)replaceBarButtons;

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

@synthesize currentPopoverController		= _currentPopoverController;

@synthesize interaction						= _interaction;

@synthesize doneWithInteractionTypeButton	= _doneWithInteractionTypeButton;
@synthesize doneWithVisibilityButton		= _doneWithVisibilityButton;
@synthesize doneWithDateButton				= _doneWithDateButton;
@synthesize doneWithCommentButton			= _doneWithCommentButton;
@synthesize saveButton						= _saveButton;

@synthesize interactionTypeArray			= _interactionTypeArray;
@synthesize visibilityArray					= _visibilityArray;
@synthesize suggestions						= _suggestions;
@synthesize selectionsFromParent			= _selectionsFromParent;

//buttons in storyboard
@synthesize scrollView						= _scrollView;
@synthesize initiator						= _initiator;
@synthesize interactionType					= _interactionType;
@synthesize interactionTypeIcon				= _interactionTypeIcon;
@synthesize receiver						= _receiver;
@synthesize visibility						= _visibility;
@synthesize dateTime						= _dateTime;
@synthesize comment							= _comment;
@synthesize originalCommentFrame			= _originalCommentFrame;
@synthesize originalContentOffset			= _originalContentOffset;

@synthesize initiatorLabel					= _initiatorLabel;
@synthesize interactionTypeLabel			= _interactionTypeLabel;
@synthesize receiverLabel					= _receiverLabel;
@synthesize visibilityLabel					= _visibilityLabel;
@synthesize dateTimeLabel					= _dateTimeLabel;
@synthesize commentLabel					= _commentLabel;

//lazy loaded lists/pickers for each type
@synthesize initiatorsList					= _initiatorsList;
@synthesize interactionTypePicker			= _interactionTypePicker;
@synthesize receiversList					= _receiversList;
@synthesize visibilityPicker				= _visibilityPicker;
@synthesize timestampPicker					= _timestampPicker;

#pragma mark - initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
        // Custom initialization
    }
    
	return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
    
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	if (self.currentPopoverController && !(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
		
		self.navigationController.navigationBar.backgroundColor	= [UIColor whiteColor];
		
	}
	
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
	
	[[MHGoogleAnalyticsTracker sharedInstance] sendScreenViewWithScreenName:MHGoogleAnalyticsTrackerCreateInteractionScreenName];
	
}

-(void)viewWillDisappear:(BOOL)animated {

	[self clearPickers];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
	[super viewWillDisappear:animated];
	
}

-(void)viewDidLoad {
	
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets)]) {
		[self setAutomaticallyAdjustsScrollViewInsets:NO];
	}
	
	self.originalContentOffset	= self.scrollView.contentOffset;
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.originalContentOffset	= CGPointMake(self.originalContentOffset.x, -CGRectGetHeight(self.navigationController.navigationBar.frame));
		}
	
	} else {
		
		NSInteger statusBarHeight	= 0.0;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			statusBarHeight			= -20;
		}
		
		self.originalContentOffset	= CGPointMake(self.originalContentOffset.x, statusBarHeight - CGRectGetHeight(self.navigationController.navigationBar.frame));
		
	}
    
    self.comment.delegate	= self;
	
	if (!self.interaction) {
		
		self.interaction = [MHInteraction newObjectFromFields:nil];
		
	}
	
	self.suggestions = [NSMutableArray arrayWithArray:@[[MHAPI sharedInstance].currentUser]];
	
	NSString *orgName = ([[[[MHAPI sharedInstance] currentUser] currentOrganization] name] ? [[[[MHAPI sharedInstance] currentUser] currentOrganization] name] : @"");
	
	self.visibilityArray = [NSMutableArray arrayWithArray:@[
//							@{@"value": [MHInteraction stringForPrivacySetting:MHInteractionPrivacySettingEveryone],		@"title": @"Everyone"},
//							@{@"value": [MHInteraction stringForPrivacySetting:MHInteractionPrivacySettingParent],			@"title": [NSString stringWithFormat:@"Everyone in Parent of %@", orgName]}, //TODO: on login grab the name of the parent org and use it here
							@{@"value": [MHInteraction stringForPrivacySetting:MHInteractionPrivacySettingOrganization],	@"title": [NSString stringWithFormat:@"Everyone in %@", orgName]},
							@{@"value": [MHInteraction stringForPrivacySetting:MHInteractionPrivacySettingAdmins],			@"title": [NSString stringWithFormat:@"Admins in %@", orgName]},
							@{@"value": [MHInteraction stringForPrivacySetting:MHInteractionPrivacySettingMe],				@"title": @"Only Me"}
							]];
	
	self.interactionTypeArray = [NSMutableArray arrayWithArray:
								 ([[[[MHAPI sharedInstance] currentUser] currentOrganization] interactionTypes] ?
																[[[[[MHAPI sharedInstance] currentUser] currentOrganization] interactionTypes] allObjects] :
																@[])];
	[self.interactionTypeArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
	
    
    [self updateBarButtons];
    
    self.navigationItem.rightBarButtonItem	= self.saveButton;
	
    UIImage *whiteButton = [[UIImage imageNamed:@"MH_Mobile_Topbar_Background.png"]
							resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];;
    
    [self.initiator setTintColor:[UIColor clearColor]];
    [self.initiator.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14.0]];
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
	[self.dateTime.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14.0]];
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
	self.comment.returnKeyType			= UIReturnKeyDefault;
    
    self.originalCommentFrame = self.comment.frame;
	
	[self updateInterface];
	
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
	
	[super didMoveToParentViewController:parent];
	
	if (!parent) {
	
		[self clearInteraction];
		
	}
	
}

#pragma mark - accessor methods/model methods

-(void)updateWithInteraction:(MHInteraction *)interaction andSelections:(NSArray *)selections {
	
	if (self.navigationController.viewControllers.count > 1) {
		
		[self.navigationController popToRootViewControllerAnimated:NO];
		
	}
	
	self.interaction = interaction;
	[self setSelections:selections];
	
	[self updateInterface];
	
}

-(void)setSelections:(NSArray *)selections {
	
	self.selectionsFromParent = [NSMutableArray arrayWithArray:selections];
	
}

-(void)saveInteraction {
	
	NSError *error;
	
	self.saveButton.enabled = NO;
	self.isSaving = YES;
	
	if ([self.interaction validateForServerCreate:&error]) {
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] createInteraction:self.interaction withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			if ([weakSelf.createInteractionDelegate respondsToSelector:@selector(controller:didCreateInteraction:)]) {
				
				[weakSelf.createInteractionDelegate controller:weakSelf didCreateInteraction:weakSelf.interaction];
				
			}
			
			weakSelf.saveButton.enabled = YES;
			
			if (weakSelf.currentPopoverController) {
				
				[weakSelf.currentPopoverController dismissPopoverAnimated:YES];
				weakSelf.currentPopoverController	= nil;
				
			} else {
				
				[weakSelf.navigationController popViewControllerAnimated:YES];
				
			}
			
			self.isSaving = NO;
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {
			
			[MHErrorHandler presentError:error];
			
			weakSelf.saveButton.enabled = YES;
			self.isSaving = NO;
			
		}];
		
		[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerCreateInteractionScreenName
																  category:MHGoogleAnalyticsCategoryButton
																	action:MHGoogleAnalyticsActionTap
																	 label:MHGoogleAnalyticsTrackerCreateInteractionSaveButtonTap
																	 value:@1];
		
	} else {
		
		[MHErrorHandler presentError:error];
		
		self.saveButton.enabled = YES;
		
		[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerCreateInteractionScreenName
																  category:MHGoogleAnalyticsCategoryButton
																	action:MHGoogleAnalyticsActionTap
																	 label:MHGoogleAnalyticsTrackerCreateInteractionSaveButtonTap
																	 value:@0];
		
	}
	
}

-(void)clearInteraction {
	
	if (!self.isSaving) {
		
		self.interaction.type			= [[[MHAPI sharedInstance].currentOrganization interactionTypes] findWithRemoteID:@1];
		self.interaction.comment		= @"";
		self.interaction.privacy_setting = [MHInteraction stringForPrivacySetting:MHInteractionPrivacySettingOrganization];
		self.interaction.timestamp		= [NSDate date];
		self.interaction.created_at		= [NSDate date];
		self.interaction.updated_at		= [NSDate date];
		
		self.interaction.receiver		= nil;
		self.interaction.creator		= [MHAPI sharedInstance].currentUser;
		self.interaction.updater		= [MHAPI sharedInstance].currentUser;
		[self.interaction removeInitiators:self.interaction.initiators];
		[self.interaction addInitiatorsObject:[MHAPI sharedInstance].currentUser];
		
	}
	
}

#pragma mark - update UI methods

- (void)updateLayout {
	
	self.scrollView.frame				= self.view.frame;
	
	self.initiatorLabel.frame			= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerViewMarginVertical,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerLabelHeight);
	self.initiator.frame				= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.initiatorLabel.frame) + MHNewInteractionViewControllerButtonMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerButtonHeight);
	
	self.interactionTypeLabel.frame		= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.initiator.frame) + MHNewInteractionViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerLabelHeight);
	self.interactionType.frame			= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.interactionTypeLabel.frame) + MHNewInteractionViewControllerButtonMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerButtonHeight);
	self.interactionTypeIcon.frame		= CGRectMake(CGRectGetMaxX(self.interactionType.frame) - MHNewInteractionViewControllerInteractionTypeIconMargin - MHNewInteractionViewControllerInteractionTypeIconWidth,
													 CGRectGetMinY(self.interactionType.frame) + MHNewInteractionViewControllerInteractionTypeIconMargin,
													 MHNewInteractionViewControllerInteractionTypeIconWidth,
													 MHNewInteractionViewControllerInteractionTypeIconHeight);
	
	self.receiverLabel.frame			= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.interactionType.frame) + MHNewInteractionViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerLabelHeight);
	self.receiver.frame					= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.receiverLabel.frame) + MHNewInteractionViewControllerButtonMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerButtonHeight);
	
	self.visibilityLabel.frame			= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.receiver.frame) + MHNewInteractionViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerLabelHeight);
	self.visibility.frame				= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.visibilityLabel.frame) + MHNewInteractionViewControllerButtonMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerButtonHeight);
	
	self.dateTimeLabel.frame			= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.visibility.frame) + MHNewInteractionViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerLabelHeight);
	self.dateTime.frame					= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.dateTimeLabel.frame) + MHNewInteractionViewControllerButtonMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerButtonHeight);
	
	self.commentLabel.frame				= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.dateTime.frame) + MHNewInteractionViewControllerLabelMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerLabelHeight);
	
	
	
	self.comment.frame					= CGRectMake(MHNewInteractionViewControllerViewMarginHorizontal,
													 CGRectGetMaxY(self.commentLabel.frame) + MHNewInteractionViewControllerTextFieldMarginTop,
													 CGRectGetWidth(self.scrollView.frame) - 2 * MHNewInteractionViewControllerViewMarginHorizontal,
													 MHNewInteractionViewControllerTextFieldHeight);
	
	self.scrollView.contentSize			= CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.comment.frame) + MHNewInteractionViewControllerViewMarginVertical);
	
	self.navigationItem.rightBarButtonItem	= self.saveButton;
	
	[self clearPickers];
	
	self.interactionTypePicker.frame	= CGRectMake(CGRectGetMinX(self.interactionTypePicker.frame),
													 CGRectGetMinY(self.interactionTypePicker.frame),
													 CGRectGetWidth(self.scrollView.frame),
													 CGRectGetHeight(self.interactionTypePicker.frame)
													 );
	
	self.visibilityPicker.frame	= CGRectMake(CGRectGetMinX(self.visibilityPicker.frame),
													 CGRectGetMinY(self.visibilityPicker.frame),
													 CGRectGetWidth(self.scrollView.frame),
													 CGRectGetHeight(self.visibilityPicker.frame)
													 );
	
	self.timestampPicker.frame	= CGRectMake(CGRectGetMinX(self.timestampPicker.frame),
													 CGRectGetMinY(self.timestampPicker.frame),
													 CGRectGetWidth(self.scrollView.frame),
													 CGRectGetHeight(self.timestampPicker.frame)
													 );
	
}

-(void)updateBarButtons {
	
	//replace the right button that is already there
	if ([self.navigationItem.rightBarButtonItem isEqual:self.saveButton]) {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.saveButton;
		
	} else if ([self.navigationItem.rightBarButtonItem isEqual:self.doneWithInteractionTypeButton]) {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.doneWithInteractionTypeButton;
		
	} else if ([self.navigationItem.rightBarButtonItem isEqual:self.doneWithVisibilityButton]) {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.doneWithVisibilityButton;
		
	} else if ([self.navigationItem.rightBarButtonItem isEqual:self.doneWithDateButton]) {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.doneWithDateButton;
		
	} else if ([self.navigationItem.rightBarButtonItem isEqual:self.doneWithCommentButton]) {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.doneWithCommentButton;
		
	} else {
		
		[self replaceBarButtons];
		self.navigationItem.rightBarButtonItem		= self.saveButton;
		
	}
	
}

- (void)replaceBarButtons {
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		
		//replace the left button
		if (self.currentPopoverController) {
			
			self.navigationItem.leftBarButtonItem		= [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMenu:)];
			
			//create all the other buttons for later use
			self.saveButton								= [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveInteraction)];
			self.doneWithInteractionTypeButton			= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithInteractionType:)];
			self.doneWithVisibilityButton				= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithVisibility:)];
			self.doneWithDateButton						= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithDate:)];
			self.doneWithCommentButton					= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithComment:)];
			
		} else {
			
			self.navigationItem.leftBarButtonItem		= [MHToolbar barButtonWithStyle:MHToolbarStyleBack target:self selector:@selector(backToMenu:) forBar:self.navigationController.navigationBar];
		
			//create all the other buttons for later use
			self.saveButton = [MHToolbar barButtonWithStyle:MHToolbarStyleSave target:self selector:@selector(saveInteraction) forBar:self.navigationController.navigationBar];
			self.doneWithInteractionTypeButton			= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithInteractionType:) forBar:self.navigationController.navigationBar];
			self.doneWithVisibilityButton				= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithVisibility:) forBar:self.navigationController.navigationBar];
			self.doneWithDateButton						= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithDate:) forBar:self.navigationController.navigationBar];
			self.doneWithCommentButton					= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithComment:) forBar:self.navigationController.navigationBar];
			
		}
		
	} else {
	
		//replace the left button
		if (self.currentPopoverController) {
			
			self.navigationItem.leftBarButtonItem		= [MHToolbar barButtonWithStyle:MHToolbarStyleCancel target:self selector:@selector(backToMenu:) forBar:self.navigationController.navigationBar];
			
		} else {
			
			self.navigationItem.leftBarButtonItem		= [MHToolbar barButtonWithStyle:MHToolbarStyleBack target:self selector:@selector(backToMenu:) forBar:self.navigationController.navigationBar];
			
		}
		
		//create all the other buttons for later use
		self.saveButton = [MHToolbar barButtonWithStyle:MHToolbarStyleSave target:self selector:@selector(saveInteraction) forBar:self.navigationController.navigationBar];
		self.doneWithInteractionTypeButton			= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithInteractionType:) forBar:self.navigationController.navigationBar];
		self.doneWithVisibilityButton				= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithVisibility:) forBar:self.navigationController.navigationBar];
		self.doneWithDateButton						= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithDate:) forBar:self.navigationController.navigationBar];
		self.doneWithCommentButton					= [MHToolbar barButtonWithStyle:MHToolbarStyleDone target:self selector:@selector(doneWithComment:) forBar:self.navigationController.navigationBar];
		
	}
	
}

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
		
		textForInitiatorButton = [NSString stringWithFormat:@"%@ +%u", [[[self.interaction.initiators allObjects] objectAtIndex:0] fullName], [self.interaction.initiators count] - 1];
		
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
    
    [self.receiver setTitle:textForReceiverButton forState:UIControlStateNormal];
	
}

-(void)updateInterfaceForVisibility {
	
	if ([self.interaction privacy_setting]) {
		
		__block NSString *visibilityString = @"";
		
		__weak __typeof(&*self)weakSelf = self;
		[self.visibilityArray enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger index, BOOL *stop) {
			
			NSString *value = object[@"value"];
			NSString *title = object[@"title"];
			
			if ([value isEqualToString:[weakSelf.interaction privacy_setting]]) {
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
		
		dateFormatter.dateFormat = @"dd MMM yyyy - hh:mm a";
		
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
	
	if (_initiatorsList == nil) {
		
		[self willChangeValueForKey:@"initiatorsList"];
		_initiatorsList						= [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"initiatorsList"];
		
		_initiatorsList.selectionDelegate	= self;
		_initiatorsList.multipleSelection	= YES;
		_initiatorsList.listTitle			= @"Initiator(s)";
		[_initiatorsList setDataArray:[MHAPI sharedInstance].initialPeopleList forRequestOptions:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]];
		
	}
	
	return _initiatorsList;
	
}

-(MHGenericListViewController *)receiversList {
	
	if (_receiversList == nil) {
		
		[self willChangeValueForKey:@"receiversList"];
		_receiversList						= [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"receiversList"];
		
		_receiversList.selectionDelegate	= self;
		_receiversList.multipleSelection	= NO;
		_receiversList.listTitle			= @"Receiver";
		[_receiversList setDataArray:[MHAPI sharedInstance].initialPeopleList forRequestOptions:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]];
		
	}
	
	return _receiversList;
	
}

-(UIPickerView *)interactionTypePicker {
	
	if (_interactionTypePicker == nil) {
		
		[self willChangeValueForKey:@"interactionTypePicker"];
		_interactionTypePicker							= [[UIPickerView alloc] init];
		[self didChangeValueForKey:@"interactionTypePicker"];
		
		_interactionTypePicker.delegate					= self;
		_interactionTypePicker.dataSource				= self;
		_interactionTypePicker.showsSelectionIndicator	= YES;
		
	}
	
	return _interactionTypePicker;
	
}

-(UIPickerView *)visibilityPicker {
	
	if (_visibilityPicker == nil) {
		
		[self willChangeValueForKey:@"visibilityPicker"];
		_visibilityPicker							= [[UIPickerView alloc] init];
		[self didChangeValueForKey:@"visibilityPicker"];
		
		_visibilityPicker.delegate					= self;
		_visibilityPicker.dataSource				= self;
		_visibilityPicker.showsSelectionIndicator	= YES;
		
	}
	
	return _visibilityPicker;
	
}

-(UIDatePicker *)timestampPicker {
	
	if (_timestampPicker == nil) {
		
		[self willChangeValueForKey:@"timestampPicker"];
		_timestampPicker = [[UIDatePicker alloc] init];
		[self didChangeValueForKey:@"timestampPicker"];
		
		[_timestampPicker addTarget:self action:@selector(timestampChanged:) forControlEvents:UIControlEventValueChanged];
		
	}
	
	return _timestampPicker;
	
}

#pragma mark - launch UI to choose value

-(void)chooseInitiator:(id)sender {
    
	NSSet *suggestions = [NSSet setWithArray:self.suggestions];
	
	[[self initiatorsList] setSuggestions:suggestions andSelections:self.interaction.initiators];
    [self.navigationController pushViewController:[self initiatorsList] animated:YES];
    
}


-(void)chooseInteractionType:(id)sender {
	
	[self clearPickers];
    
	__block NSInteger selectedRow = 0;
	MHInteractionType *type = self.interaction.type;
	
	if (type) {
		
		[self.interactionTypeArray enumerateObjectsUsingBlock:^(id typeObject, NSUInteger row, BOOL *stop) {
			
			if ([type isEqualToModel:typeObject]) {
				
				selectedRow = row;
				*stop		= YES;
				
			}
			
		}];
		
	}
	
	[self.view addSubview:[self interactionTypePicker]];
	
	[[self interactionTypePicker] selectRow:selectedRow inComponent:0 animated:NO];
	
	__block CGRect pickerFrame = [self interactionTypePicker].frame;
	
	[self interactionTypePicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
													CGRectGetMaxY(self.view.frame),
													CGRectGetWidth(pickerFrame),
													CGRectGetHeight(pickerFrame));
	
	__weak __typeof(&*self)weakSelf = self;
	[UIView animateWithDuration:0.2 animations:^{
		
		[weakSelf interactionTypePicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
														CGRectGetMaxY(weakSelf.view.frame) - CGRectGetHeight(pickerFrame),
														CGRectGetWidth(pickerFrame),
														CGRectGetHeight(pickerFrame));
		
	}];
	
    self.navigationItem.rightBarButtonItem	= self.doneWithInteractionTypeButton;
    
}


-(void)chooseReceiver:(id)sender {
    
	NSMutableSet *suggestions	= [NSMutableSet setWithArray:self.suggestions];
	[suggestions addObjectsFromArray:self.selectionsFromParent];
	
	[[self receiversList] setSuggestions:suggestions andSelectionObject:self.interaction.receiver];
    [self.navigationController pushViewController:[self receiversList] animated:YES];

}


-(void)chooseVisibility:(id)sender {
	
	[self clearPickers];
	
	__block NSInteger selectedRow = 0;

	__weak __typeof(&*self)weakSelf = self;
	[self.visibilityArray enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger row, BOOL *stop) {
		
		NSString *value = [object objectForKey:@"value"];
		
		if ([value isEqualToString:[weakSelf.interaction privacy_setting]]) {
			selectedRow = row;;
			*stop = YES;
		}
		
	}];
	
    [self.view addSubview:[self visibilityPicker]];
	
	[[self visibilityPicker] selectRow:selectedRow inComponent:0 animated:NO];
	
	__block CGRect pickerFrame = [self visibilityPicker].frame;
	
	[self visibilityPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
													CGRectGetMaxY(self.view.frame),
													CGRectGetWidth(pickerFrame),
													CGRectGetHeight(pickerFrame));
	
	[UIView animateWithDuration:0.2 animations:^{
		
		[weakSelf visibilityPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
														CGRectGetMaxY(weakSelf.view.frame) - CGRectGetHeight(pickerFrame),
														CGRectGetWidth(pickerFrame),
														CGRectGetHeight(pickerFrame));
		
	}];
	
    self.navigationItem.rightBarButtonItem	= self.doneWithVisibilityButton;
	
}

-(void)chooseDate:(id)sender {
	
	[self clearPickers];
	
	[self.view addSubview:[self timestampPicker]];
	
	[[self timestampPicker] setDate:self.interaction.timestamp];
	
	__block CGRect pickerFrame = [self timestampPicker].frame;
	
	[self timestampPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
											   CGRectGetMaxY(self.view.frame),
											   CGRectGetWidth(pickerFrame),
											   CGRectGetHeight(pickerFrame));
	
	__weak __typeof(&*self)weakSelf = self;
	[UIView animateWithDuration:0.2 animations:^{
		
		[weakSelf timestampPicker].frame = CGRectMake(CGRectGetMinX(pickerFrame),
												   CGRectGetMaxY(weakSelf.view.frame) - CGRectGetHeight(pickerFrame),
												   CGRectGetWidth(pickerFrame),
												   CGRectGetHeight(pickerFrame));
		
	}];
    
    self.navigationItem.rightBarButtonItem	= self.doneWithDateButton;
    
}

-(void)backToMenu:(id)sender {
	
	if (self.currentPopoverController) {
		
		[self.currentPopoverController dismissPopoverAnimated:YES];
		self.currentPopoverController	= nil;
		
		[self clearInteraction];
		
		[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerCreateInteractionScreenName
																	 label:MHGoogleAnalyticsTrackerCreateInteractionCancelButtonTap];
		
	} else {
		
		[self.navigationController popViewControllerAnimated:YES];
		
		[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerCreateInteractionScreenName
																	 label:MHGoogleAnalyticsTrackerCreateInteractionBackButtonTap];
		
	}
	
}

#pragma mark - respond to choices

-(void)timestampChanged:(UIDatePicker *)sender {
	
	self.interaction.timestamp = [sender date];
	
	[self updateInterfaceForTimestamp];
	
}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	if ([object isKindOfClass:[MHPerson class]]) {
	
		MHPerson *person = (MHPerson *)object;
		
		if ([viewController isEqual:[self receiversList]]) {
			
			[self.navigationController popViewControllerAnimated:YES];
			
			[self.interaction setReceiver:person];
			[self updateInterfaceForReceiver];
			
		}
		
	}
	
}

- (void)list:(MHGenericListViewController *)viewController didChangeObjectStateFrom:(MHGenericListObjectState)fromState toState:(MHGenericListObjectState)toState forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	if ([object isKindOfClass:[MHPerson class]]) {
		
		MHPerson *person = (MHPerson *)object;
		
		if ([viewController isEqual:[self initiatorsList]]) {
		
			if (toState == MHGenericListObjectStateSelectedAll) {
				
				[self.interaction addInitiatorsObject:person];
				
			}
			
			if (toState == MHGenericListObjectStateSelectedNone) {
				
				[self.interaction removeInitiatorsObject:person];
				
			}
			
			[self updateInterfaceForInitiators];
			
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

-(void)doneWithInteractionType:(id)sender {
	
	__block UIView *pickerView			= [self interactionTypePicker];
	__block CGRect pickerFrame	= pickerView.frame;
	
	__weak __typeof(&*self)weakSelf = self;
	[UIView animateWithDuration:0.2 animations:^{
		
		pickerView.frame = CGRectMake(CGRectGetMinX(pickerFrame),
												  CGRectGetMaxY(weakSelf.view.frame),
												  CGRectGetWidth(pickerFrame),
												  CGRectGetHeight(pickerFrame));
		
		[weakSelf clearPickers];
		
	}];
	
}

-(void)doneWithVisibility:(id)sender {
	
	__block UIView *pickerView			= [self visibilityPicker];
	__block CGRect pickerFrame	= pickerView.frame;
	
	__weak __typeof(&*self)weakSelf = self;
	[UIView animateWithDuration:0.2 animations:^{
		
		pickerView.frame = CGRectMake(CGRectGetMinX(pickerFrame),
												  CGRectGetMaxY(weakSelf.view.frame),
												  CGRectGetWidth(pickerFrame),
												  CGRectGetHeight(pickerFrame));
		
		[weakSelf clearPickers];
		
	}];
	
}

-(void)doneWithDate:(id)sender {
	
	__block UIView *pickerView			= [self timestampPicker];
	__block CGRect pickerFrame	= pickerView.frame;
	
	__weak __typeof(&*self)weakSelf = self;
	[UIView animateWithDuration:0.2 animations:^{
		
		pickerView.frame = CGRectMake(CGRectGetMinX(pickerFrame),
												  CGRectGetMaxY(weakSelf.view.frame),
												  CGRectGetWidth(pickerFrame),
												  CGRectGetHeight(pickerFrame));
		
		[weakSelf clearPickers];
		
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
	
	self.navigationItem.rightBarButtonItem	= self.saveButton;
	
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	if ([[self interactionTypePicker] superview]) {
		[[self interactionTypePicker] removeFromSuperview];
	}
	
	if ([[self visibilityPicker] superview]) {
		[[self visibilityPicker] removeFromSuperview];
	}
	
	if ([[self timestampPicker] superview]) {
		[[self timestampPicker] removeFromSuperview];
	}
	
	if (!self.currentPopoverController) {
		
		CGFloat naviagtionBarHeight	= 0.0;
		
		if (!(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)) {
			
			naviagtionBarHeight	= CGRectGetHeight(self.navigationController.navigationBar.frame) + 20.0;
			
		}
		
		[self.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(self.commentLabel.frame) - MHNewInteractionViewControllerLabelMarginTop - naviagtionBarHeight) animated:YES];
		
		self.scrollView.scrollEnabled	= NO;
		
	}
	
    self.navigationItem.rightBarButtonItem	= self.doneWithCommentButton;
	
}

- (void)textViewDidChange:(UITextView *)textView {
	
	if ([textView isEqual:self.comment]) {
		
		self.interaction.comment		= self.comment.text;
		
	}
	
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
	self.interaction.comment		= self.comment.text;
	
	if (!self.currentPopoverController) {
		
		self.scrollView.scrollEnabled	= YES;
		
		[self.scrollView setContentOffset:self.originalContentOffset animated:YES];
		
	}
    
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
	
	[self updateLayout];
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	[self updateBarButtons];
	
}

#pragma mark - popover methods

- (CGSize)contentSizeForViewInPopover {
	
	return CGSizeMake(320.0, 568);
	
}

#pragma mark - memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
