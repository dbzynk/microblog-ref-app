/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGCCloudDBQuery describe how to select objects from AGCCloudDBZone.
 *
 * Author: luominwei [luominwei@huawei.com]
 * Create: 2020-03-17
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AGCCloudDBObject;
@class AGCCloudDBQuery;

/**
 This enum is defined the query policy.
 So if you want to add a new enumeration,
 make sure that the value of these enumerations are the same as the enum.
 
 - AGCCloudDBQueryPolicyLocal: Query from local cache;
 - AGCCloudDBQueryPolicyCloud: Query from cloud server;
 - AGCCloudDBQueryPolicyDefault: Query from cloud server and merge local modification;
 Query from local if query cloud error.
 */
typedef NS_ENUM (NSInteger, AGCCloudDBQueryPolicy) {
    AGCCloudDBQueryPolicyLocal   = 1,
    AGCCloudDBQueryPolicyCloud   = 2,
    AGCCloudDBQueryPolicyDefault = 3
};

/**
 A block used to instantiate AGCCloudDBQuery with specific field info.
 
 @param clazz The Class used to be compared.
 
 @return An AGCCloudDBQuery object.
 */
typedef AGCCloudDBQuery *_Nonnull (^AGCCloudDBQueryBlock) (Class _Nonnull clazz);

/**
 A block used to add filter condition with specific field info.
 
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
typedef AGCCloudDBQuery *_Nonnull (^AGCCloudDBFilterBlock) (NSString *_Nonnull fieldName);

/**
 A block used to add a value filter with specific value and field.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
typedef AGCCloudDBQuery *_Nonnull (^AGCCloudDBValueFilterBlock) (id _Nonnull value, NSString *_Nonnull fieldName);

/**
 A block used to add a list of values to filter condition.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param values A list of values used to be compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
typedef AGCCloudDBQuery *_Nonnull (^AGCCloudDBArrayFilterBlock) (NSArray *_Nonnull values,
                                                                 NSString *_Nonnull fieldName);

/**
 A block used to add a filter condition, limit the number of results.
 
 @param count Limit number.
 
 @return An AGCCloudDBQuery object.
 */
typedef AGCCloudDBQuery *_Nonnull (^AGCCloudDBCountBlock) (int count);

/**
 A block used to add a filter condition, limit the number of results, offset specified number.
 
 @param count Limit number.
 @param offset Offset specified number.
 
 @return An AGCCloudDBQuery object.
 */
typedef AGCCloudDBQuery *_Nonnull (^AGCCloudDBCountOffsetBlock) (int count, int offset);

/**
 A block used to add filter condition with instance of the AGCCloudDBObject or its subclass.
 
 @param object The instance of the AGCCloudDBObject or its subclass.
 
 @return An AGCCloudDBQuery object.
 */
typedef AGCCloudDBQuery *_Nonnull (^AGCCloudDBObjectBlock) (AGCCloudDBObject *_Nonnull object);

@interface AGCCloudDBQuery : NSObject

#pragma mark - initialize

/**
 Instantiate an AGCCloudDBQuery object.
 
 @param clazz The Class used to be compared.
 
 @return An AGCCloudDBQuery object.
 */
+ (nonnull instancetype)where:(nonnull Class)clazz;

/**
 Instantiate an AGCCloudDBQuery object with method chaining.
 
 @return An AGCCloudDBQueryBlock object, used to method chaining.
 */
+ (AGCCloudDBQueryBlock)where;

#pragma mark - condition

/**
 Add EQUAL(==) condition for value.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)equalTo:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add EQUAL(==) condition with method chaining.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)equalTo;

/**
 Add NOT EQUAL(!=) condition for value.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)notEqualTo:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add NOT EQUAL(!=) condition with method chaining.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)notEqualTo;

/**
 Add GREATER(>) condition for value.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)greaterThan:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add GREATER(>) condition with method chaining.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)greaterThan;

/**
 Add GREATER OR EQUAL(>=) condition for value.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)greaterThanOrEqualTo:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add GREATER OR EQUAL(>=) condition with method chaining.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)greaterThanOrEqualTo;

/**
 Add LESS(<) condition for value.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)lessThan:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add LESS(<) condition with method chaining.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)lessThan;

/**
 Add LESS OR EQUAL(<=) to condition for value.
 Value type support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)lessThanOrEqualTo:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add LESS OR EQUAL(<=) condition with method chaining.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)lessThanOrEqualTo;

/**
 Add IN(IN) to condition for value, like 'IN(...)' in SQL statement.
 Value type in NSArray support: NSNumber(AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble)、
 NSString、NSDate、AGCCloudDBText.
 
 @param values The value array of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)inArray:(nonnull NSArray *)values forField:(nonnull NSString *)fieldName;

/**
 Add IN(IN) condition with method chaining, like 'IN(...)' in SQL statement.
 
 @return An AGCCloudDBArrayFilterBlock object, used to method chaining.
 */
- (AGCCloudDBArrayFilterBlock)inArray;

/**
 Add ORDER BY ASC(ORDER BY ASC) condition, like 'ORDER BY ... ASC' in SQL statement.
 
 @param fieldName The name of the field used for order.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)orderByAsc:(nonnull NSString *)fieldName;

/**
 Add ORDER BY ASC(ORDER BY ASC) condition with method chaining, like 'ORDER BY ... ASC' in SQL statement.
 
 @return An AGCCloudDBFilterBlock object, used to method chaining.
 */
- (AGCCloudDBFilterBlock)orderByAsc;

/**
 Add ORDER BY DESC(ORDER BY DESC) condition, like 'ORDER BY ... DESC' in SQL statement.
 
 @param fieldName The name of the field used for order.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)orderByDesc:(nonnull NSString *)fieldName;

/**
 Add ORDER BY DESC(ORDER BY DESC) condition with method chaining, like 'ORDER BY ... DESC' in SQL statement.
 
 @return An AGCCloudDBFilterBlock object, used to method chaining.
 */
- (AGCCloudDBFilterBlock)orderByDesc;

/**
 According to the orderBy condition,
 called OrderByAsc, add startAt(>=) condition, called OrderByDesc, add startAt(<=) condition with AGCCloudDBObject in SQL statement.
 
 @param object The instance of the AGCCloudDBObject used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)startAt:(nonnull AGCCloudDBObject *)object;

/**
 According to the orderBy condition,
 called OrderByAsc, add startAt(>=) condition, called OrderByDesc, add startAt(<=) condition with AGCCloudDBObject in SQL statement.
 
 @return An AGCCloudDBObjectBlock object, used to method chaining
 */
- (AGCCloudDBObjectBlock)startAt;

/**
 According to the orderBy condition,
 called OrderByAsc, add startAfter(>) condition, called OrderByDesc, add startAfter(<) condition with AGCCloudDBObject in SQL statement.
 
 @param object The instance of the AGCCloudDBObject used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)startAfter:(nonnull AGCCloudDBObject *)object;

/**
 According to the orderBy condition,
 called OrderByAsc, add startAfter(>) condition, called OrderByDesc, add startAfter(<) condition with AGCCloudDBObject in SQL statement.
 
 @return An AGCCloudDBObjectBlock object, used to method chaining.
 */
- (AGCCloudDBObjectBlock)startAfter;

/**
 According to the orderBy condition,
 called OrderByAsc, add endAt(<=) condition, called OrderByDesc, add endAt(>=) condition with AGCCloudDBObject in SQL statement.
 
 @param object The instance of the AGCCloudDBObject used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)endAt:(nonnull AGCCloudDBObject *)object;

/**
 According to the orderBy condition,
 called OrderByAsc, add endAt(<=) condition, called OrderByDesc, add endAt(>=) condition with AGCCloudDBObject in SQL statement.
 
 @return An AGCCloudDBObjectBlock object, used to method chaining.
 */
- (AGCCloudDBObjectBlock)endAt;

/**
 According to the orderBy condition,
 called OrderByAsc, add endBefore(<) condition, called OrderByDesc, add endBefore(>) condition with AGCCloudDBObject in SQL statement.
 
 @param object The instance of the AGCCloudDBObject used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)endBefore:(nonnull AGCCloudDBObject *)object;

/**
 According to the orderBy condition,
 called OrderByAsc, add endBefore(<) condition, called OrderByDesc, add endBefore(>) condition with AGCCloudDBObject in SQL statement.
 
 @return An AGCCloudDBObjectBlock object, used to method chaining.
 */
- (AGCCloudDBObjectBlock)endBefore;

/**
 Add LIMIT(LIMIT) condition, like 'LIMIT' in SQL statement.
 
 @param count Limit number.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)limit:(int)count;

/**
 Add LIMIT(LIMIT) condition with method chaining, like 'LIMIT' in SQL statement.
 
 @return An AGCCloudDBCountBlock object, used to method chaining
 */
- (AGCCloudDBCountBlock)limit;

/**
 Add LIMIT OFFSET(LIMIT OFFSET) condition, like 'LIMIT ... OFFSET ...' in SQL statement.
 
 @param count Limit number.
 @param offset Offset number.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)limit:(int)count offset:(int)offset;

/**
 Add LIMIT OFFSET(LIMIT OFFSET) condition with method chaining, like 'LIMIT ... OFFSET ...' in SQL statement.
 
 @return An AGCCloudDBCountOffsetBlock object, used to method chaining.
 */
- (AGCCloudDBCountOffsetBlock)limitOffset;

/**
 Add filter condition, BEGIN WITH specific value, like 'LIKE [pattern]%' in SQL statement.
 Value type support: NSString、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)beginsWith:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add filter condition, BEGIN WITH specific value, for method chaining, like 'LIKE [pattern]%' in SQL statement.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)beginsWith;

/**
 Add filter condition, END WITH specific value, like 'LIKE %[pattern]' in SQL statement.
 Value type support: NSString、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)endsWith:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add filter condition, END WITH specific value, for method chaining, like 'LIKE %[pattern]' in SQL statement.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)endsWith;

/**
 Add ISNULL condition for field, like 'IS NULL' in SQL statement.
 
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)isNull:(nonnull NSString *)fieldName;

/**
 Add ISNULL condition for field, like 'IS NULL' in SQL statement.
 
 @return An AGCCloudDBFilterBlock object, used to method chaining.
 */
- (AGCCloudDBFilterBlock)isNull;

/**
 Add IS NOT NULL condition for field, like 'IS NOT NULL' in SQL statement.
 
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)isNotNull:(nonnull NSString *)fieldName;

/**
 Add IS NOT NULL condition for field, like 'IS NOT NULL' in SQL statement.
 
 @return An AGCCloudDBFilterBlock object, used to method chaining.
 */
- (AGCCloudDBFilterBlock)isNotNull;

/**
 Add filter condition, CONTAINS specific value, like 'LIKE %[pattern]%' in SQL statement.
 Value type support: NSString、AGCCloudDBText.
 
 @param value The value of the field used for being compared.
 @param fieldName The name of the field used for being compared.
 
 @return An AGCCloudDBQuery object.
 */
- (nonnull instancetype)contains:(nonnull id)value forField:(nonnull NSString *)fieldName;

/**
 Add filter condition, CONTAINS specific value, for method chaining, like 'LIKE %[pattern]%' in SQL statement.
 
 @return An AGCCloudDBValueFilterBlock object, used to method chaining.
 */
- (AGCCloudDBValueFilterBlock)contains;

@end

NS_ASSUME_NONNULL_END
