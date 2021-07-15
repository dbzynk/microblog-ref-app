//
//  test.m
//  HiPlace
//
//  Created by Ali Mert Özhayta on 25.06.2021.
//

#import <Foundation/Foundation.h>

@interface MyClassObjectiveC : NSObject
// '+' means static -> MyClassObjectiveC.convertToString
+(NSString *)convertToString:(NSNumber *)value;

// '-' means an instance of class -> MyClassObjectiveC().convertToString
//-(NSString *)convertToString:(NSNumber *)value;

@end


@implementation MyClassObjectiveC

+ (NSString *)convertToString:(NSNumber *)value {
    if (value == nil) {
        return nil;
    } else{
        return [value stringValue];
    };
}

@end
