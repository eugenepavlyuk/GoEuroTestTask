//
//  SearchViewController.h
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 4/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPAutoCompleteTextField;

@interface SearchViewController : UIViewController
{
    IBOutlet MLPAutoCompleteTextField *fromTextField;
    IBOutlet MLPAutoCompleteTextField *toTextField;
    
    IBOutlet UITextField *dateTextField;
    
    IBOutlet UIButton *searchButton;
}

- (IBAction)searchButtonTapped;

@end
