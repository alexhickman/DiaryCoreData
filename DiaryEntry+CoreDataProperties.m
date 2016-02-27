//
//  DiaryEntry+CoreDataProperties.m
//  DiaryCoreData
//
//  Created by Hickman on 2/27/16.
//  Copyright © 2016 Hickman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DiaryEntry+CoreDataProperties.h"

@implementation DiaryEntry (CoreDataProperties)

@dynamic date;
@dynamic body;
@dynamic image;
@dynamic location;
@dynamic mood;

- (NSString *)sectionName
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
