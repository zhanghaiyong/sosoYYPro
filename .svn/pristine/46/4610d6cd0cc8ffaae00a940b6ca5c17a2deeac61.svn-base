//
//  DCDataBase.m
//  InstFit
//
//  Created by Bitaxon-mac on 16/6/16.
//  Copyright © 2016年 administrator-mac. All rights reserved.
//

#import "DCDataBase.h"

@implementation DCDataBase
/*
+(DCDataBase *)sharedDatabase{
    static DCDataBase *gl_database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gl_database=[[DCDataBase alloc]init];
    });
    return gl_database;
}

-(id)init{
    if(self = [super init]){
        NSString *path = [DCDataBase filePath:@"InstFitData.db"];
        mDB=[FMDatabase databaseWithPath:path];
        if([mDB open])
            [self createTable];
    }
    return self;
}
 
+(NSString *)filePath:(NSString *)fileName{
    NSString *path=NSHomeDirectory();
    path=[path stringByAppendingPathComponent:@"Library/Caches"];
    NSFileManager *fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:path]){
        if(fileName && [fileName length]!=0)
            path=[path stringByAppendingPathComponent:fileName];
        return path;
    }
    return nil;
}

-(void)createTable{
    NSArray *tableArray=[NSArray arrayWithObjects:@"CREATE TABLE IF NOT EXISTS FriendList( serial integer PRIMARY KEY AUTOINCREMENT,mobile TEXT(1024),email TEXT(1024),time Date(1024),nick_name TEXT(1024),sex TEXT(1024),head_img TEXT(1024),signature TEXT(1024),friend_uuid TEXT(1024),is_remark TEXT(1024),friend_remark TEXT(1024))",@"CREATE TABLE IF NOT EXISTS MotionList( serial integer PRIMARY KEY AUTOINCREMENT,mMotionType TEXT(1024),mTimestamp TEXT(1024),mDuration TEXT(1024),mSteps TEXT(1024),mDistance TEXT(1024),mElev TEXT(1024),mCalories TEXT(1024),mAscent TEXT(1024),mDescent TEXT(1024),mMet TEXT(1024),mSleepLevel TEXT(1024),mTemp TEXT(1024),mTime Date(1024),mDate TEXT(1024))",@"CREATE TABLE IF NOT EXISTS HeartRateList( serial integer PRIMARY KEY AUTOINCREMENT,mTimestamp TEXT(1024),mHeartRate TEXT(1024),mDate TEXT(1024),mJudge TEXT(1024))",@"CREATE TABLE IF NOT EXISTS SummaryList( serial integer PRIMARY KEY AUTOINCREMENT,mSteps TEXT(1024),mCalories TEXT(1024),mDistance TEXT(1024),mUserTime TEXT(1024),mDate TEXT(1024),mTime Date(1024))",@"CREATE TABLE IF NOT EXISTS ImageList( serial integer PRIMARY KEY AUTOINCREMENT,imge Data(1024))", nil];
    
    for(NSString *sql in tableArray){
        if([mDB executeUpdate:sql]){
            
        }else{
            NSLog(@"创建表失败%@",[mDB lastErrorMessage]);
        }
    }
}

-(NSInteger)countOfTableName:(NSString *)tableName{
    NSString *sql=[NSString stringWithFormat:@"select count(*) from %@",tableName];
    FMResultSet *result=[mDB executeQuery:sql];
    while ([result next]) {
        return [result intForColumnIndex:0];
    }
    return 0;
}
-(void)updateTable:(NSString *)table widthValueName:(NSString *)name withVale:(NSString *)value ofSearchName:(NSString *)searchName ofSearchValue:(NSString *)searchValue{
    NSString *strSql=[NSString stringWithFormat:@"update %@ set %@ =? where %@=%@",table,name,searchName,searchValue];
    if([mDB executeUpdate:strSql,value]){
        //NSLog(@"sucsess");
    }else{
        //NSLog(@"file");
    }
}

-(BOOL)existsDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSString *)nameValue{
    NSString *sql=[NSString stringWithFormat:@"select * from %@ where %@=?",table,itemName];
    FMResultSet *rs=[mDB executeQuery:sql,nameValue];
    while ([rs next]) {
        return YES;
    }
    return NO;
}
-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSArray *)valueArray{
    for(NSString *value in valueArray){
        if([mDB executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = ?",table,itemName],value]){
            //NSLog(@"sucsess");
        }else{
            //NSLog(@"file");
        }
    }
}
-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withString:(NSString *)valueSting{
    if([mDB executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = ?",table,itemName],valueSting]){
        //NSLog(@"sucsess");
    }else{
        //NSLog(@"file");
    }
}



//好友
-(void)insertItemWithFriendList:(DCUserInformationEntity *)entity{
    NSString *sql=[NSString stringWithFormat:@"insert into FriendList(mobile,email,time,nick_name,sex,head_img,signature,friend_uuid,is_remark,friend_remark) values (?,?,?,?,?,?,?,?,?,?)"];
    if([mDB executeUpdate:sql,entity.mMobile,entity.mEmail,entity.mTime,entity.mNickName,entity.mSex,entity.mHeadImg,entity.mSignature,entity.mFriendUUID,entity.mIsRemark,entity.mFriendRemark]){
    }
    else
        [mDB lastErrorMessage];
}
-(void)updateFriendList:(NSString *)imUsername WithValue:(NSDate *)value{
    NSString *strSql=[NSString stringWithFormat:@"update FriendList set time =%@ where friend_uuid=%@",value,imUsername];
    if([mDB executeUpdate:strSql,value]){
    }else{//NSLog(@"file");
    }
}
-(void)friendList{
    NSString *strSql=[NSString stringWithFormat:@"select * from FriendList order by time desc"];
    if([mDB executeQuery:strSql]){
        //NSLog(@"sucsess");
    }else{
        //NSLog(@"file");
    }
}
-(void)readDataFriendList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished{
    
    NSString *sql=[NSString stringWithFormat:@"select mobile,email,time,nick_name,sex,head_img,signature,friend_uuid,is_remark,friend_remark from FriendList limit %zi,%zi",startIndex,count];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    FMResultSet *result=[mDB executeQuery:sql];
    while ([result next]){
        
        DCUserInformationEntity *entity = [DCUserInformationEntity new];
        entity.mMobile = [result stringForColumn:@"mobile"];
        entity.mEmail = [result stringForColumn:@"email"];
        entity.mNickName = [result stringForColumn:@"nick_name"];
        entity.mSex = [result stringForColumn:@"sex"];
        entity.mHeadImg = [result stringForColumn:@"head_img"];
        entity.mSignature = [result stringForColumn:@"signature"];
        entity.mFriendUUID = [result stringForColumn:@"friend_uuid"];
        entity.mIsRemark = [result stringForColumn:@"is_remark"];
        entity.mFriendRemark = [result stringForColumn:@"friend_remark"];
        entity.mTime = [result dateForColumn:@"time"];
        
        [array addObject:entity];
    }
    
    finished  (array);
}
-(void)deleteFriendList:(NSString *)imUsername{
    [mDB executeUpdate:@"delete from FriendList where friend_uuid = ?",imUsername];
}
-(void)deleteAllFriendList{
    [mDB executeUpdate:@"DELETE FROM FriendList;"];
}

-(void)setFriendListSelectDBName:(NSString *)name andSearchName:(NSString *)searchName andType:(NSInteger)type andFinished:(void(^)(NSMutableArray *ary))finished{
    
    NSString *sql = nil;
    if (type == 0) {
        //搜索开头的
        sql = [NSString stringWithFormat:@"SELECT * FROM FriendList WHERE %@ like '%@%%'",name,searchName];
    }else{
        //搜索包含的
        sql = [NSString stringWithFormat:@"SELECT * FROM FriendList WHERE %@ like '%%%@%%'",name,searchName];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    FMResultSet *result = [mDB executeQuery:sql];
    while ([result next]){
        
        DCUserInformationEntity *entity = [DCUserInformationEntity new];
        
        entity.mMobile = [result stringForColumn:@"mobile"];
        entity.mEmail = [result stringForColumn:@"email"];
        entity.mNickName = [result stringForColumn:@"nick_name"];
        entity.mSex = [result stringForColumn:@"sex"];
        entity.mHeadImg = [result stringForColumn:@"head_img"];
        entity.mSignature = [result stringForColumn:@"signature"];
        entity.mFriendUUID = [result stringForColumn:@"friend_uuid"];
        entity.mIsRemark = [result stringForColumn:@"is_remark"];
        entity.mFriendRemark = [result stringForColumn:@"friend_remark"];
        entity.mTime = [result dateForColumn:@"time"];
        
        [array addObject:entity];
        
    }
    finished (array);
}


//精确查找
-(void)setFriendListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished{
    
    FMResultSet *result = [mDB executeQuery:@"SELECT * FROM FriendList"];
    result = [mDB executeQuery:@"SELECT * FROM FriendList WHERE %@ = ?",name,searchName];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([result next]){
        
        DCUserInformationEntity *entity = [DCUserInformationEntity new];
        
        entity.mMobile = [result stringForColumn:@"mobile"];
        entity.mEmail = [result stringForColumn:@"email"];
        entity.mNickName = [result stringForColumn:@"nick_name"];
        entity.mSex = [result stringForColumn:@"sex"];
        entity.mHeadImg = [result stringForColumn:@"head_img"];
        entity.mSignature = [result stringForColumn:@"signature"];
        entity.mFriendUUID = [result stringForColumn:@"friend_uuid"];
        entity.mIsRemark = [result stringForColumn:@"is_remark"];
        entity.mFriendRemark = [result stringForColumn:@"friend_remark"];
        entity.mTime = [result dateForColumn:@"time"];
        
        [array addObject:entity];
        
    }
    finished (array);
}


-(void)setUpdateSql:(NSString *)table andDBName:(NSString *)dbName andNewNmae:(NSString *)newNmae{
    NSString *updateSql = [[NSString alloc] initWithFormat:@"UPDATE '%@' SET '%@' = '%@'",table,dbName,newNmae];
    
      NSLog(@"nikeNmae == %@",newNmae);
    
    BOOL res = [mDB executeUpdate:updateSql];
    if (!res) {
        NSLog(@"error when update db table");
    } else {
        NSLog(@"success to update db table");
    }
}

-(void)setChange:(NSString *)table andDBOldName:(NSString *)dbOldName andOldName:(NSString *)odrName andDBNewName:(NSString *)dbNewName andNewName:(NSString *)newName {
    
    NSLog(@"nikeNmae == %@",odrName);
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' WHERE '%@' = '%@'",table,dbOldName,odrName,dbNewName,newName];
    BOOL res = [mDB executeUpdate:updateSql];
    if (!res) {
      NSLog(@"error when update db table");
    } else {
       NSLog(@"success to update db table");
    }
}




//手环运动数据
-(void)insertItemWithMotionList:(DCFriendTrendsEntity *)entity{
    NSString *sql=[NSString stringWithFormat:@"insert into MotionList(mMotionType,mTimestamp,mDuration,mSteps,mDistance,mElev,mCalories,mAscent,mDescent,mMet,mSleepLevel,mTemp,mTime,mDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
    if([mDB executeUpdate:sql,entity.mMotionType,entity.mTimestamp,entity.mDuration,entity.mSteps,entity.mDistance,entity.mElev,entity.mCalories,entity.mAscent,entity.mDescent,entity.mMet,entity.mSleepLevel,entity.mTemp,entity.mTime,entity.mDate]){
    }
    else
        [mDB lastErrorMessage];
 
}
//根据date修改data (数据更新)
-(void)updateMotionList:(NSString *)date andDateValue:(NSString *)dataValue{
    NSString *strSql=[NSString stringWithFormat:@"update MotionList set mDate =%@ where mMotionType=%@",date,dataValue];
    if([mDB executeUpdate:strSql,dataValue]){
    }else{//NSLog(@"file");
    }
}
-(void)motionList{
    NSString *strSql=[NSString stringWithFormat:@"select * from MotionList order by mDate desc"];
    if([mDB executeQuery:strSql]){
        //NSLog(@"sucsess");
    }else{
        //NSLog(@"file");
    }
}
-(void)readDataMotionList:(NSString *)date andFinished:(void(^)(NSMutableArray *ary))finished{
    
    FMResultSet *result = [mDB executeQuery:@"SELECT * FROM MotionList"];
    result = [mDB executeQuery:@"SELECT * FROM MotionList WHERE mDate = ?",date];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    while ([result next]){
        DCFriendTrendsEntity *entity = [DCFriendTrendsEntity new];
        
        entity.mMotionType = [result stringForColumn:@"mMotionType"];
        entity.mTimestamp = [result stringForColumn:@"mTimestamp"];
        entity.mDuration = [result stringForColumn:@"mDuration"];
        entity.mSteps = [result stringForColumn:@"mSteps"];
        entity.mDistance = [result stringForColumn:@"mDistance"];
        entity.mElev = [result stringForColumn:@"mElev"];
        entity.mCalories = [result stringForColumn:@"mCalories"];
        entity.mAscent = [result stringForColumn:@"mAscent"];
        entity.mDescent = [result stringForColumn:@"mDescent"];
        entity.mMet = [result stringForColumn:@"mMet"];
        entity.mSleepLevel = [result stringForColumn:@"mSleepLevel"];
        entity.mTemp = [result stringForColumn:@"mTemp"];
        entity.mTime = [result dateForColumn:@"mTime"];
        entity.mDate = [result stringForColumn:@"mDate"];
        [array addObject:entity];
    }
    finished  (array);
 
}
-(void)readDataMotionList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished{
    NSString *sql=[NSString stringWithFormat:@"select mMotionType,mTimestamp,mDuration,mSteps,mDistance,mElev,mCalories,mAscent,mDescent,mMet,mSleepLevel,mTemp,mTime,mDate from MotionList limit %zi,%zi",startIndex,count];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    FMResultSet *result=[mDB executeQuery:sql];
    while ([result next]){
        DCFriendTrendsEntity *entity = [DCFriendTrendsEntity new];
        
        entity.mMotionType = [result stringForColumn:@"mMotionType"];
        entity.mTimestamp = [result stringForColumn:@"mTimestamp"];
        entity.mDuration = [result stringForColumn:@"mDuration"];
        entity.mSteps = [result stringForColumn:@"mSteps"];
        entity.mDistance = [result stringForColumn:@"mDistance"];
        entity.mElev = [result stringForColumn:@"mElev"];
        entity.mCalories = [result stringForColumn:@"mCalories"];
        entity.mAscent = [result stringForColumn:@"mAscent"];
        entity.mDescent = [result stringForColumn:@"mDescent"];
        entity.mMet = [result stringForColumn:@"mMet"];
        entity.mSleepLevel = [result stringForColumn:@"mSleepLevel"];
        entity.mTemp = [result stringForColumn:@"mTemp"];
        entity.mTime = [result dateForColumn:@"mTime"];
        entity.mDate = [result stringForColumn:@"mDate"];
        [array addObject:entity];
    }
    finished  (array);
}
-(void)deleteMotionList:(NSString *)date andFinished:(void(^)(BOOL isYes))finished{
   [mDB executeUpdate:@"delete from MotionList where mDate != ?",date];
    finished(YES);
}
-(void)deleteAllMotionList{
  [mDB executeUpdate:@"DELETE FROM MotionList;"];
}



//心率数据
-(void)insertItemWithHeartRateList:(DCFriendTrendsEntity *)entity{
    NSString *sql=[NSString stringWithFormat:@"insert into HeartRateList(mTimestamp,mHeartRate,mDate,mJudge) values (?,?,?,?)"];
    if([mDB executeUpdate:sql,entity.mTimestamp,entity.mHeartRate,entity.mDate,entity.mJudge]){
    }
    else
        [mDB lastErrorMessage];
}
-(void)updateHeartRateList:(NSString *)date andDateValue:(NSString *)dataValue{
    NSString *strSql=[NSString stringWithFormat:@"update HeartRateList set mTimestamp =%@ where mHeartRate=%@",date,dataValue];
    if([mDB executeUpdate:strSql,dataValue]){
    }else{//NSLog(@"file");
    }
}
-(void)heartRateList{
    NSString *strSql=[NSString stringWithFormat:@"select * from HeartRateList order by mTimestamp desc"];
    if([mDB executeQuery:strSql]){
        //NSLog(@"sucsess");
    }else{
        //NSLog(@"file");
    }
}
-(void)readDataHeartRateList:(NSString *)date andFinished:(void(^)(NSMutableArray *ary))finished{
    FMResultSet *result = [mDB executeQuery:@"SELECT * FROM HeartRateList"];
    result = [mDB executeQuery:@"SELECT * FROM HeartRateList WHERE mDate = ?",date];
    NSMutableArray *array = [[NSMutableArray alloc]init];

    while ([result next]){
        DCFriendTrendsEntity *entity = [DCFriendTrendsEntity new];
        
        entity.mTimestamp = [result stringForColumn:@"mTimestamp"];
        entity.mHeartRate = [result stringForColumn:@"mHeartRate"];
        entity.mDate = [result stringForColumn:@"mDate"];
        entity.mJudge = [result stringForColumn:@"mJudge"];
        [array addObject:entity];
    }
    finished  (array);
}

-(void)readDataHeartRateList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished{
    NSString *sql=[NSString stringWithFormat:@"select mTimestamp,mHeartRate,mDate,mJudge from HeartRateList limit %zi,%zi",startIndex,count];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    FMResultSet *result=[mDB executeQuery:sql];
    while ([result next]){
        DCFriendTrendsEntity *entity = [DCFriendTrendsEntity new];
        
        entity.mTimestamp = [result stringForColumn:@"mTimestamp"];
        entity.mHeartRate = [result stringForColumn:@"mHeartRate"];
        entity.mDate = [result stringForColumn:@"mDate"];
        entity.mJudge = [result stringForColumn:@"mJudge"];
        [array addObject:entity];
    }
    finished  (array);
}
-(void)deleteHeartRateList:(NSString *)data andFinished:(void(^)(BOOL isYes))finished{
   [mDB executeUpdate:@"delete from HeartRateList where mDate != ?",data];
    finished(YES);
}
-(void)deleteAllHeartRateList{
  [mDB executeUpdate:@"DELETE FROM HeartRateList;"];
}






//手环汇总数据
-(void)insertItemWithSummaryList:(DCFriendTrendsEntity *)entity{
    NSString *sql=[NSString stringWithFormat:@"insert into SummaryList(mSteps,mCalories,mDistance,mUserTime,mDate,mTime) values (?,?,?,?,?,?)"];
    if([mDB executeUpdate:sql,entity.mSteps,entity.mCalories,entity.mDistance,entity.mUserTime,entity.mDate,entity.mTime]){
    }
    else
        [mDB lastErrorMessage];
}
-(void)updateSummaryList:(NSString *)date andDateValue:(NSString *)dataValue{
    NSString *strSql=[NSString stringWithFormat:@"update SummaryList set mTime =%@ where mDate=%@",date,dataValue];
    if([mDB executeUpdate:strSql,dataValue]){
    }else{//NSLog(@"file");
    }
}
-(void)summaryList{
    NSString *strSql=[NSString stringWithFormat:@"select * from SummaryList order by mTime desc"];
    if([mDB executeQuery:strSql]){
        //NSLog(@"sucsess");
    }else{
        //NSLog(@"file");
    }
  
}
-(void)readDataSummaryList:(NSString *)date andFinished:(void(^)(NSMutableArray *ary))finished{
    FMResultSet *result = [mDB executeQuery:@"SELECT * FROM SummaryList"];
    result = [mDB executeQuery:@"SELECT * FROM SummaryList WHERE mDate != ?",date];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    while ([result next]){
        DCFriendTrendsEntity *entity = [DCFriendTrendsEntity new];
        
        entity.mSteps = [result stringForColumn:@"mSteps"];
        entity.mCalories = [result stringForColumn:@"mCalories"];
        entity.mDistance = [result stringForColumn:@"mDistance"];
        entity.mUserTime = [result stringForColumn:@"mUserTime"];
        entity.mDate = [result stringForColumn:@"mDate"];
        entity.mTime = [result dateForColumn:@"mTime"];
        [array addObject:entity];

    }
    finished  (array);
 
}
-(void)readDataSummaryList:(NSInteger)startIndex count:(NSInteger)count andFinished:(void(^)(NSMutableArray *ary))finished{
    NSString *sql=[NSString stringWithFormat:@"select mSteps,mCalories,mDistance,mUserTime,mDate,mTime from SummaryList limit %zi,%zi",startIndex,count];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    FMResultSet *result=[mDB executeQuery:sql];
    while ([result next]){
        DCFriendTrendsEntity *entity = [DCFriendTrendsEntity new];
        
        entity.mSteps = [result stringForColumn:@"mSteps"];
        entity.mCalories = [result stringForColumn:@"mCalories"];
        entity.mDistance = [result stringForColumn:@"mDistance"];
        entity.mUserTime = [result stringForColumn:@"mUserTime"];
        entity.mDate = [result stringForColumn:@"mDate"];
        entity.mTime = [result dateForColumn:@"mTime"];
        [array addObject:entity];
    }
    finished  (array);
}
-(void)deleteSummaryList:(NSString *)data andFinished:(void(^)(BOOL isYes))finished{
   [mDB executeUpdate:@"delete from SummaryList where mDate = ?",data];
    finished(YES);
}
-(void)deleteAllSummaryList{
  [mDB executeUpdate:@"DELETE FROM SummaryList;"];
}


//图片缓存
-(void)insertItemWithImageList:(DCFriendTrendsEntity *)entity{

    NSString *sql=[NSString stringWithFormat:@"insert into ImageList(imge) values (?)"];
    if([mDB executeUpdate:sql,entity.mImageData]){
    }
    else
        [mDB lastErrorMessage];
}
-(NSData *)redImageList{
    NSString *sql=[NSString stringWithFormat:@"select imge from ImageList limit %zi,%zi",0,0];
    FMResultSet *result=[mDB executeQuery:sql];
    DCFriendTrendsEntity *entity = [DCFriendTrendsEntity new];
        entity.mImageData = [result dataForColumn:@"imge"];
    return entity.mImageData;
}
*/
@end
