//
//  MHTextField.h
//  MissionHub
//
//  Created by Michael Harrison on 7/31/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHTextField : UITextField {
	
	UIEdgeInsets _textInset;
	UIEdgeInsets _editingTextInset;
	
}

@property (nonatomic, assign) UIEdgeInsets textInset;
@property (nonatomic, assign) UIEdgeInsets editingTextInset;

@end
