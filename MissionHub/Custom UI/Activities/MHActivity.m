//
//  MHActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//
// Derived from https://github.com/romaonthego/REActivityViewController
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "MHActivity.h"
#import "MHActivityViewController.h"
#import "MHAllObjects.h"
#import "DejalActivityView.h"

NSString * const MHActivityTypeDefault	= @"com.missionhub.mhactivity.type.default";

@interface MHActivity ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *activityItems;

@end

@implementation MHActivity

@synthesize title			= _title;
@synthesize image			= _image;
@synthesize activityItems	= _activityItems;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image {
	
    self = [super init];
    
	if (self) {
		
        self.title			= title;
        self.image			= image;
		
    }
    
	return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeDefault;
	
}

- (NSString *)activityTitle {
	
	return self.title;
	
}

- (UIImage *)activityImage {
	
	return self.image;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	return NO;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	self.activityItems	= ( activityItems ? activityItems : @[] );
	
}

- (void)performActivity {
	
}

- (void)activityDidFinish:(BOOL)completed {
	
	MHActivityViewController *activityViewController = (MHActivityViewController *)self.activityViewController;
	
	if ([activityViewController.delegate respondsToSelector:@selector(activityDidFinish:completed:)]) {
		
		[activityViewController.delegate activityDidFinish:self.activityType completed:completed];
		
	}
	
}

#pragma mark - Helper methods

- (void)returnPeopleFromArray:(NSArray *)array withCompletionBlock:(void (^)(NSArray *peopleList))onCompletion {
	
	if (array.count) {
		
		if ([array[0] isKindOfClass:[MHAllObjects class]]) {
			
			[DejalBezelActivityView activityViewForView:self.activityViewController.parentViewController.view withLabel:@"Loading People..."].showNetworkActivityIndicator	= YES;
			
			MHAllObjects *allPeople	= array[0];
			
			__weak typeof(self)weakSelf = self;
			[allPeople getPeopleListWithSuccessBlock:^(NSArray *peopleList) {
				
				[DejalBezelActivityView removeViewAnimated:YES];
				
				onCompletion(peopleList);
				
			} failBlock:^(NSError *error) {
				
				[DejalBezelActivityView removeViewAnimated:YES];
				
				NSString *message				= [NSString stringWithFormat:@"We were unable to complete this action because we couldn't retrieve everyone you selected. Please try again. If the problem persists please contact support@mission.com"];
				NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
																 code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
				
				[MHErrorHandler presentError:presentationError];
				
				[weakSelf activityDidFinish:NO];
				
			}];
			
		} else {
			
			onCompletion(array);
			
		}
		
	} else {
		
			onCompletion(@[]);
		
	}
	
}

@end
