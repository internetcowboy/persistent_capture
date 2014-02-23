//
//  PCVideoController.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 2/19/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCVideoController.h"
#import "PCIOController.h"

@implementation PCVideoController



#pragma mark video file information lookups

-(NSString *)returnDateForDayOfTheWeek: (NSString *)dayOfTheWeek {

    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSWeekCalendarUnit
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval];
    
    //find date for day requested
    NSArray *keys = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    for (int i=0;i<=[keys count]-1;i++)  {
        
        if ([keys[i] isEqualToString:dayOfTheWeek]) {
            return [self getDate:startOfTheWeek daysAhead:i];
        }
       
    }
    
    return @"notfound";
    
}

-(NSDictionary *) obtainVideoDictionaryForWeek: (NSString *)albumName {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSWeekCalendarUnit
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval];
    
    //startOfWeek holds now the first day of the week, according to locale (monday vs. sunday)
    /*NSLog(@"interval : %f", interval);
     NSLog(@"%@", startOfTheWeek);
     NSLog(@"%@", endOfWeek);*/
            //init every day of the week for the album
        NSArray *keys = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
        NSMutableArray *objects=[[NSMutableArray alloc] init];
        for (int i=0;i<=[keys count]-1;i++)  {
            
            //does video exist for day
            NSString *fnlPth = [NSString stringWithFormat:@"%@/%@/video_%@.mov", albumName, keys[i], [self getDate:startOfTheWeek daysAhead:i]];
            NSString *videoCreated = [self doesVideoExistForDay:fnlPth];
            NSString *dateOfWeekForDay = [self getDate:startOfTheWeek daysAhead:i];
            NSArray *thisDay = [NSArray arrayWithObjects:dateOfWeekForDay, fnlPth, videoCreated, nil];
            [objects addObject:thisDay];
            
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
            
   
    return dictionary;
}


-(NSString *) doesVideoExistForDay: (NSString *)dateString {
    
    //construct path of the file
    NSString *subDirectory = [NSString stringWithFormat:@"%@", dateString];
    NSString *documentsDirectory = [[PCIOController new] documentDirectory];
    NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:subDirectory];
    
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:videoPath];
    if (isFileExist) {
        return @"true";
    } else {
        return @"false";
    }
    
}
- (NSString *) getDate:(NSDate *)fromDate daysAhead:(NSUInteger)days
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *previousDate = [calendar dateByAddingComponents:dateComponents
                                                     toDate:fromDate
                                                    options:0];
    
    NSString *dateFormatted = [self formatDate:previousDate];
    return dateFormatted;
}

-(NSString *) formatDate:(NSDate *)date {
    
    //create the date
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd-yyyy";
    NSString *dateFormatted = [formatter stringFromDate:date] ;
    
    return dateFormatted;
    
}


@end
