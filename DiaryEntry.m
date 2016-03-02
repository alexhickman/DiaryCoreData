//
//  DiaryEntry.m
//  DiaryCoreData
//
//  Created by Hickman on 2/27/16.
//  Copyright © 2016 Hickman. All rights reserved.
//

#import "DiaryEntry.h"


@implementation DiaryEntry

// Insert code here to add functionality to your managed object subclass

- (NSString *)sectionName
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
