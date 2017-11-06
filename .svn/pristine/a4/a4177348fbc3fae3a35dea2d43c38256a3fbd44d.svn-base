//
//  DCDataBase.h
//  InstFit
//
//  Created by Bitaxon-mac on 16/6/16.
//  Copyright © 2016年 administrator-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@class DCFriendTrendsEntity;
@interface DCDataBase : NSObject{
    FMDatabase *mDB;
}
/*
+(DCDataBase *)sharedDatabase;

-(NSInteger)countOfTableName:(NSString *)tableName;
-(BOOL)existsDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSString *)nameValue;
-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSArray *)valueArray;
-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withString:(NSString *)valueSting;
-(void)updateTable:(NSString *)table widthValueName:(NSString *)name withVale:(NSString *)value ofSearchName:(NSString *)searchName ofSearchValue:(NSString *)searchValue;

//好友
-(void)insertItemWithFriendList:(DCUserInformationEntity *)entity;
-(void)updateFriendList:(NSString *)imUsername WithValue:(NSDate *)value;
-(void)friendList;
-(void)readDataFriendList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished;
-(void)deleteFriendList:(NSString *)imUsername;
-(void)deleteAllFriendList;


//模糊搜索
-(void)setFriendListSelectDBName:(NSString *)name andSearchName:(NSString *)searchName andType:(NSInteger)type andFinished:(void(^)(NSMutableArray *ary))finished;
//精确查找
-(void)setFriendListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished;

//更新
-(void)setUpdateSql:(NSString *)table andDBName:(NSString *)dbName andNewNmae:(NSString *)newNmae;

//改变
-(void)setChange:(NSString *)table andDBOldName:(NSString *)dbOldName andOldName:(NSString *)odrName andDBNewName:(NSString *)dbNewName andNewName:(NSString *)newName;


//手环运动数据
-(void)insertItemWithMotionList:(DCFriendTrendsEntity *)entity;
//根据date修改data (数据更新)
-(void)updateMotionList:(NSString *)date andDateValue:(NSString *)dataValue;
-(void)motionList;
-(void)readDataMotionList:(NSString *)date andFinished:(void(^)(NSMutableArray *ary))finished;
-(void)readDataMotionList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished;
-(void)deleteMotionList:(NSString *)date andFinished:(void(^)(BOOL isYes))finished;
-(void)deleteAllMotionList;


//手环心率数据
-(void)insertItemWithHeartRateList:(DCFriendTrendsEntity *)entity;
-(void)updateHeartRateList:(NSString *)date andDateValue:(NSString *)dataValue;
-(void)heartRateList;
-(void)readDataHeartRateList:(NSString *)date andFinished:(void(^)(NSMutableArray *ary))finished;
-(void)readDataHeartRateList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished;
-(void)deleteHeartRateList:(NSString *)data andFinished:(void(^)(BOOL isYes))finished;
-(void)deleteAllHeartRateList;


//手环汇总数据
-(void)insertItemWithSummaryList:(DCFriendTrendsEntity *)entity;
-(void)updateSummaryList:(NSString *)date andDateValue:(NSString *)dataValue;
-(void)summaryList;
-(void)readDataSummaryList:(NSString *)date andFinished:(void(^)(NSMutableArray *ary))finished;
-(void)readDataSummaryList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished;
-(void)deleteSummaryList:(NSString *)data andFinished:(void(^)(BOOL isYes))finished;
-(void)deleteAllSummaryList;

//图片缓存
-(void)insertItemWithImageList:(DCFriendTrendsEntity *)entity;
-(NSData *)redImageList;

*/
@end
