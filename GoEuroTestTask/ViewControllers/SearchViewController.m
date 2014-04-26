//
//  SearchViewController.m
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 4/26/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "SearchViewController.h"
#import <ReactiveCocoa.h>
#import "GoEuroModel.h"
#import <ABCalendarPicker.h>
#import <INTULocationManager.h>
#import <MLPAutoCompleteTextFieldDataSource.h>
#import <MLPAutoCompleteTextField.h>
#import "PersistentData.h"
#import <NSManagedObject+MagicalFinders.h>
#import <NSManagedObjectContext+MagicalThreading.h>
#import <NSManagedObjectContext+MagicalSaves.h>

@interface MLPAutoCompleteTextField()

- (NSArray*)autoCompleteSuggestions;
- (void)setAutoCompleteSuggestions:(NSArray*)array;

@end

@interface SearchViewController () <UITextFieldDelegate, ABCalendarPickerDelegateProtocol,
                                    MLPAutoCompleteTextFieldDataSource>

@property (nonatomic, weak) IBOutlet ABCalendarPicker *calendarPicker;

@property (nonatomic, strong) PersistentData *persistentData;
@property (nonatomic, strong) GoEuroModel *goEuroModel;

@end

@implementation SearchViewController
{
    CLLocation *location;
    
    PersistentData *_persistentData;
    
    NSDateFormatter *dateFormatter;
    
    GoEuroModel *_goEuroModel;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    }
    
    return self;
}

// lazy loading of persistentData
- (PersistentData*)persistentData
{
    if (!_persistentData)
    {
        _persistentData = [PersistentData MR_findFirst];
        
        if (!_persistentData)
        {
            _persistentData = [PersistentData persistentData];
        }
    }
    
    return _persistentData;
}

// lazy loading of goEuroModel
- (GoEuroModel*)goEuroModel
{
    if (!_goEuroModel)
    {
        _goEuroModel = [GoEuroModel new];
    }
    
    return _goEuroModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.persistentData.lastDate)
    {
        dateTextField.text = [dateFormatter stringFromDate:self.persistentData.lastDate];
        [self.calendarPicker setHighlightedAndSectedDate:self.persistentData.lastDate
                                                animated:NO];
    }
    
    fromTextField.autoCompleteDataSource = self;
    fromTextField.autoCompleteTableCellBackgroundColor = [UIColor lightGrayColor];
    fromTextField.reverseAutoCompleteSuggestionsBoldEffect = YES;
    fromTextField.sortAutoCompleteSuggestionsByClosestMatch = NO;
    fromTextField.autoCompleteFontSize = 14;
    
    toTextField.autoCompleteDataSource = self;
    toTextField.autoCompleteTableCellBackgroundColor = [UIColor lightGrayColor];
    toTextField.reverseAutoCompleteSuggestionsBoldEffect = YES;
    toTextField.sortAutoCompleteSuggestionsByClosestMatch = NO;
    toTextField.autoCompleteFontSize = 14;
    
    // use ReactiveCocoa to observe changes in textfields to enable/disable search button
    RAC(searchButton, enabled) = [RACSignal combineLatest:@[RACObserve(fromTextField, text),
                                                            RACObserve(toTextField, text),
                                                            RACObserve(dateTextField, text)]
                                                   reduce:^id(NSString *fromText,
                                                              NSString *toText,
                                                              NSString *date){
                                                       return @(([fromText length] && [toText length] && [date length]));
                                                   }];
    
    self.calendarPicker.delegate = self;
    
    // create dummyView to hide keyboar for data textfield.
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    dateTextField.inputView = dummyView;
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 
                                                 self.persistentData.latitude = @(currentLocation.coordinate.latitude);
                                                 self.persistentData.longitude = @(currentLocation.coordinate.longitude);
                                                 
                                                 [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
                                                 
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 
                                             }
                                             else {
                                                 
                                             }
                                         }];
}

- (IBAction)searchButtonTapped
{
    [[[UIAlertView alloc] initWithTitle:@"Search is not yet implemented"
                               message:nil
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - UITextFieldDelegate's method

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == dateTextField)
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.calendarPicker.alpha = 1.f;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == dateTextField)
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.calendarPicker.alpha = 0.f;
        }];
    }
    
    if (textField == fromTextField)
    {
        [fromTextField setAutoCompleteSuggestions:nil];
    }
    
    if (textField == toTextField)
    {
        [toTextField setAutoCompleteSuggestions:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == fromTextField)
    {
        fromTextField.text = ([[fromTextField autoCompleteSuggestions] count]) ? [[[fromTextField autoCompleteSuggestions] objectAtIndex:0] autocompleteString] : fromTextField.text;
    }
    
    if (textField == toTextField)
    {
        toTextField.text = ([[toTextField autoCompleteSuggestions] count]) ? [[[toTextField autoCompleteSuggestions] objectAtIndex:0] autocompleteString] : toTextField.text;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - ABCalendarPicker delegate and dataSource

- (void)calendarPicker:(ABCalendarPicker *)calendarPicker
          dateSelected:(NSDate *)date
             withState:(ABCalendarPickerState)state
{
    self.persistentData.lastDate = date;
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    dateTextField.text = [dateFormatter stringFromDate:self.persistentData.lastDate];
}

#pragma mark - MLPAutoCompleteTextFieldDataSource's methods

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void(^)(NSArray *suggestions))handler
{
    [self.goEuroModel findPlacesForSearchTerm:string
                             withSuccessBlock:^(NSArray *places) {
                            handler(places);
                        } onFailure:^(NSError *error) {
                            
                    }];
}

@end
