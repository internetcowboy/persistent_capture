//
//  PCVideoController.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 2/19/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCVideoController : NSObject

-(NSDictionary *) obtainVideoDictionaryForWeek: (NSString *)albumName;
-(NSString *)returnDateForDayOfTheWeek: (NSString *)dayOfTheWeek;

@end
