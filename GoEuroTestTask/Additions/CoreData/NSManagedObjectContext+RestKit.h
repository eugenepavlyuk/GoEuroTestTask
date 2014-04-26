//
//  NSManagedObjectContext+RestKit.h
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 2/18/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (RestKit)

+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end
