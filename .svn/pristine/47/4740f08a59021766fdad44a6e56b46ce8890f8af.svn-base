//
//  DCFMDatabaseQueue.m
//  InstFit
//
//  Created by Bitaxon-mac on 16/8/15.
//  Copyright © 2016年 administrator-mac. All rights reserved.
//

#import "DCFMDatabaseQueue.h"

#define SQLTEXT     @"TEXT"

@interface DCFMDatabaseQueue ()

@property(nonatomic,strong) FMDatabaseQueue *queue;

@end

@implementation DCFMDatabaseQueue

 static DCFMDatabaseQueue *gl_database = nil;

+(DCFMDatabaseQueue *)sharedDatabase{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gl_database=[[DCFMDatabaseQueue alloc]init];
    });
    return gl_database;
}

-(id)init {
    
    if(self = [super init]){
        NSString *path = [DCFMDatabaseQueue filePath:@"SosoYYData.db"];
        self.queue =[FMDatabaseQueue databaseQueueWithPath:path];
        if(self.queue)
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
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSArray *tableArray=[NSArray arrayWithObjects:@"CREATE TABLE IF NOT EXISTS WisdomList( serial integer PRIMARY KEY AUTOINCREMENT,mTimestamp TEXT(1024),Goods_Package_ID date(1024),memberID TEXT(1024),userid TEXT(1024),psn TEXT(1024),PreChar TEXT(1024),DrugsBase_Manufacturer TEXT(1024),DrugsBase_ProName TEXT(1024),DrugsBase_DrugName TEXT(1024),DrugsBase_Formulation TEXT(1024),Goods_Unit TEXT(1024),DrugsBase_Specification TEXT(1024),DrugsBase_ApprovalNumber TEXT(1024),stock TEXT(1024),LastTime TEXT(1024),LastTimeString TEXT(1024),HistoryPrice TEXT(1024),SalesVolume TEXT(1024),minPrice TEXT(1024),maxPrice TEXT(1024),priority TEXT(1024),buyNumListStr TEXT(1024),Barcode TEXT(1024),buyCount TEXT(1024),store_Id TEXT(1024),store_Name TEXT(1024),minBuy TEXT(1024),sxrq TEXT(1024),pid TEXT(1024),Price TEXT(1024),sellType TEXT(1024),Product_Pcs TEXT(1024),Product_Pcs_Small TEXT(1024),supplierName TEXT(1024),myStock TEXT(1024),pmid TEXT(1024))",@"CREATE TABLE IF NOT EXISTS WisdomNotBuyList( serial integer PRIMARY KEY AUTOINCREMENT,mTimestamp date(1024),Goods_Package_ID TEXT(1024),memberID TEXT(1024),userid TEXT(1024),psn TEXT(1024),PreChar TEXT(1024),DrugsBase_Manufacturer TEXT(1024),DrugsBase_ProName TEXT(1024),DrugsBase_DrugName TEXT(1024),DrugsBase_Formulation TEXT(1024),Goods_Unit TEXT(1024),DrugsBase_Specification TEXT(1024),DrugsBase_ApprovalNumber TEXT(1024),stock TEXT(1024),LastTime TEXT(1024),LastTimeString TEXT(1024),HistoryPrice TEXT(1024),SalesVolume TEXT(1024),minPrice TEXT(1024),maxPrice TEXT(1024),priority TEXT(1024),buyNumListStr TEXT(1024),Barcode TEXT(1024),buyCount TEXT(1024),store_Id TEXT(1024),store_Name TEXT(1024),minBuy TEXT(1024),sxrq TEXT(1024),pid TEXT(1024),Price TEXT(1024),sellType TEXT(1024),Product_Pcs TEXT(1024),Product_Pcs_Small TEXT(1024),supplierName TEXT(1024),myStock TEXT(1024),pmid TEXT(1024))",@"CREATE TABLE IF NOT EXISTS EliminateWisdomList( serial integer PRIMARY KEY AUTOINCREMENT,mTimestamp date(1024),Goods_Package_ID TEXT(1024),memberID TEXT(1024),userid TEXT(1024),psn TEXT(1024),PreChar TEXT(1024),DrugsBase_Manufacturer TEXT(1024),DrugsBase_ProName TEXT(1024),DrugsBase_DrugName TEXT(1024),DrugsBase_Formulation TEXT(1024),Goods_Unit TEXT(1024),DrugsBase_Specification TEXT(1024),DrugsBase_ApprovalNumber TEXT(1024),stock TEXT(1024),LastTime TEXT(1024),LastTimeString TEXT(1024),HistoryPrice TEXT(1024),SalesVolume TEXT(1024),minPrice TEXT(1024),maxPrice TEXT(1024),priority TEXT(1024),buyNumListStr TEXT(1024),Barcode TEXT(1024),buyCount TEXT(1024),store_Id TEXT(1024),store_Name TEXT(1024),minBuy TEXT(1024),sxrq TEXT(1024),pid TEXT(1024),Price TEXT(1024),sellType TEXT(1024),Product_Pcs TEXT(1024),Product_Pcs_Small TEXT(1024),supplierName TEXT(1024),myStock TEXT(1024),pmid TEXT(1024))", nil];
        
        //        BOOL createTableResult=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT,name text,age integer)"];
        //        if (createTableResult) {
        //            NSLog(@"创建表成功");
        //        }else{
        //            NSLog(@"创建表失败");
        //        }
        
        for(NSString *sql in tableArray){
            if([db executeUpdate:sql]){
                NSLog(@"创建表成功");
            }else{
                NSLog(@"创建表失败%@",[db lastErrorMessage]);
            }
        }
    }];
}


-(void)countOfTableName:(NSString *)tableName andFinished:(void(^)(NSInteger index))finished{
    NSString *sql=[NSString stringWithFormat:@"select count(*) from %@",tableName];
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result=[db executeQuery:sql];
        if ([result next]) {
            while ([result next]) {
                finished ([result intForColumnIndex:0]);
            }
        }else{
            finished(0);
        }
    }];
}


-(void)updateTable:(NSString *)table widthValueName:(NSString *)name withVale:(NSString *)value ofSearchName:(NSString *)searchName ofSearchValue:(NSString *)searchValue{

    NSString *strSql=[NSString stringWithFormat:@"update %@ set %@ =? where %@=%@",table,name,searchName,searchValue];
    [self.queue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:strSql,value]){
            NSLog(@"sucsess");
        }else{
            NSLog(@"file");
        }
    }];
}

-(void)existsDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSString *)nameValue andFinished:(void(^)(BOOL isYes))finished{
    NSString *sql=[NSString stringWithFormat:@"select * from %@ where %@=?",table,itemName];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:sql,nameValue];
        if ([rs next]) {
            while ([rs next]) {
                finished (YES);
            }
        }else{
            finished (NO);
        }
    }];
}

-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSArray *)valueArray{
    
        [self.queue inDatabase:^(FMDatabase *db) {
            for(NSString *value in valueArray){
                
            if([db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = ?",table,itemName],value]){
                NSLog(@"sucsess");
            }else{
                NSLog(@"file");
            }
        }
    }];
}


-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withString:(NSString *)valueSting{
    [self.queue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = ?",table,itemName],valueSting]){
            //NSLog(@"sucsess");
        }else{
            //NSLog(@"file");
        }
    }];
}




#pragma mark - 智慧采购数据

-(void)insertItemWithWisdomList:(STWisdomEntity *)entity{
    NSString *sql=[NSString stringWithFormat:@"insert into WisdomList(mTimestamp,Goods_Package_ID,memberID,userid,psn,PreChar,DrugsBase_Manufacturer,DrugsBase_ProName,DrugsBase_DrugName,DrugsBase_Formulation,Goods_Unit,DrugsBase_Specification,DrugsBase_ApprovalNumber,stock,LastTime,LastTimeString,HistoryPrice,SalesVolume,minPrice,maxPrice,priority,buyNumListStr,Barcode,buyCount,store_Id,store_Name,minBuy,sxrq,pid,Price,sellType,Product_Pcs,Product_Pcs_Small,supplierName,myStock,pmid) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:sql,entity.mTimestamp,entity.Goods_Package_ID,entity.memberID,entity.userid,entity.psn,entity.PreChar,entity.DrugsBase_Manufacturer,entity.DrugsBase_ProName,entity.DrugsBase_DrugName,entity.DrugsBase_Formulation,entity.Goods_Unit,entity.DrugsBase_Specification,entity.DrugsBase_ApprovalNumber,entity.stock,entity.LastTime,entity.LastTimeString,entity.HistoryPrice,entity.SalesVolume,entity.minPrice,entity.maxPrice,entity.priority,entity.buyNumListStr,entity.Barcode,entity.buyCount,entity.store_Id,entity.store_Name,entity.minBuy,entity.sxrq,entity.pid,entity.Price,entity.sellType,entity.Product_Pcs,entity.Product_Pcs_Small,entity.supplierName,entity.myStock,entity.pmid]){
        }
        else
            [db lastErrorMessage];
    }];
}



-(void)updateWisdomList:(NSString *)Goods_Package_ID WithValue:(NSDate *)value{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *strSql=[NSString stringWithFormat:@"update WisdomList set mTimestamp =%@ where Goods_Package_ID=%@",value,Goods_Package_ID];
        if([db executeUpdate:strSql,value]){
        }else{
        }
    }];
}


-(void)setUpdateSql:(NSString *)buyCount goods_Package_ID:(NSString *)Goods_Package_ID finished:(void(^)(BOOL isYes))finished{

    NSString * updateSql = [NSString stringWithFormat:@"update WisdomList set buyCount = '%@' where Goods_Package_ID = '%@'",buyCount,Goods_Package_ID];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            finished(NO);
        } else {
            finished(YES);
        }
    }];
}


-(void)readDataWisdomListToSortByWisdomType:(int)type andFinished:(void(^)(NSMutableArray *ary))finished{

    //DESC降序，ASC生序
    NSString *sqlStr = nil;
    switch (type) {
        case 0://字母排序
            sqlStr = [NSString stringWithFormat:@"SELECT * FROM WisdomList ORDER BY PreChar ASC"];
            break;
        case 1://库存排序
            sqlStr = [NSString stringWithFormat:@"SELECT * FROM WisdomList ORDER BY myStock ASC"];
            break;
        case 2://紧急排序
            sqlStr = [NSString stringWithFormat:@"SELECT * FROM WisdomList ORDER BY priority DESC, myStock ASC"];
            break;
            
        default:
            break;
    }
    
    
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sqlStr];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        while ([result next]){
            
            STWisdomEntity *entity = [STWisdomEntity new];
            
            entity.mTimestamp = [result dateForColumn:@"mTimestamp"];
            entity.Goods_Package_ID = [result stringForColumn:@"Goods_Package_ID"];
            entity.memberID = [result stringForColumn:@"memberID"];
            entity.userid = [result stringForColumn:@"userid"];
            entity.psn = [result stringForColumn:@"psn"];
            entity.PreChar = [result stringForColumn:@"PreChar"];
            entity.DrugsBase_Manufacturer = [result stringForColumn:@"DrugsBase_Manufacturer"];
            entity.DrugsBase_ProName = [result stringForColumn:@"DrugsBase_ProName"];
            entity.DrugsBase_DrugName = [result stringForColumn:@"DrugsBase_DrugName"];
            entity.DrugsBase_Formulation = [result stringForColumn:@"DrugsBase_Formulation"];
            entity.Goods_Unit = [result stringForColumn:@"Goods_Unit"];
            entity.DrugsBase_Specification = [result stringForColumn:@"DrugsBase_Specification"];
            entity.DrugsBase_ApprovalNumber = [result stringForColumn:@"DrugsBase_ApprovalNumber"];
            entity.stock = [result stringForColumn:@"stock"];
            entity.LastTime = [result stringForColumn:@"LastTime"];
            entity.LastTimeString = [result stringForColumn:@"LastTimeString"];
            entity.HistoryPrice = [result stringForColumn:@"HistoryPrice"];
            entity.SalesVolume = [result stringForColumn:@"SalesVolume"];
            entity.minPrice = [result stringForColumn:@"minPrice"];
            entity.maxPrice = [result stringForColumn:@"maxPrice"];
            entity.priority = [result stringForColumn:@"priority"];
            entity.buyNumListStr = [result stringForColumn:@"buyNumListStr"];
            entity.Barcode = [result stringForColumn:@"Barcode"];
            entity.buyCount = [result stringForColumn:@"buyCount"];
            entity.store_Id = [result stringForColumn:@"store_Id"];
            entity.store_Name = [result stringForColumn:@"store_Name"];
            entity.minBuy = [result stringForColumn:@"minBuy"];
            entity.sxrq = [result stringForColumn:@"sxrq"];
            entity.pid = [result stringForColumn:@"pid"];
            entity.Price = [result stringForColumn:@"Price"];
            entity.sellType = [result stringForColumn:@"sellType"];
            entity.Product_Pcs = [result stringForColumn:@"Product_Pcs"];
            entity.Product_Pcs_Small = [result stringForColumn:@"Product_Pcs_Small"];
            entity.supplierName = [result stringForColumn:@"supplierName"];
            entity.myStock = [result stringForColumn:@"myStock"];
            entity.pmid = [result stringForColumn:@"pmid"];
            [array addObject:entity];
        }
        finished  (array);
    }];
}



-(void)deleteWisdomList:(NSString *)Goods_Package_ID andFinished:(void(^)(BOOL isYes))finished{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from WisdomList where Goods_Package_ID == ?",Goods_Package_ID];
        finished(YES);
    }];
}



-(void)deleteAllWisdomList{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM WisdomList;"];
    }];
}




-(void)readWisdomListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished{
    
    [self.queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:@"SELECT * FROM FriendList"];
//        result = [db executeQuery:@"SELECT * FROM FriendList WHERE %@ = ?",name,searchName];
        
        NSString *sqStr = [NSString stringWithFormat:@"select * from WisdomList where name= '%@'", searchName];
        FMResultSet *result = [db executeQuery:sqStr];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        while ([result next]){
            
            STWisdomEntity *entity = [STWisdomEntity new];
            
            entity.mTimestamp = [result dateForColumn:@"mTimestamp"];
            entity.Goods_Package_ID = [result stringForColumn:@"Goods_Package_ID"];
            entity.memberID = [result stringForColumn:@"memberID"];
            entity.userid = [result stringForColumn:@"userid"];
            entity.psn = [result stringForColumn:@"psn"];
            entity.PreChar = [result stringForColumn:@"PreChar"];
            entity.DrugsBase_Manufacturer = [result stringForColumn:@"DrugsBase_Manufacturer"];
            entity.DrugsBase_ProName = [result stringForColumn:@"DrugsBase_ProName"];
            entity.DrugsBase_DrugName = [result stringForColumn:@"DrugsBase_DrugName"];
            entity.DrugsBase_Formulation = [result stringForColumn:@"DrugsBase_Formulation"];
            entity.Goods_Unit = [result stringForColumn:@"Goods_Unit"];
            entity.DrugsBase_Specification = [result stringForColumn:@"DrugsBase_Specification"];
            entity.DrugsBase_ApprovalNumber = [result stringForColumn:@"DrugsBase_ApprovalNumber"];
            entity.stock = [result stringForColumn:@"stock"];
            entity.LastTime = [result stringForColumn:@"LastTime"];
            entity.LastTimeString = [result stringForColumn:@"LastTimeString"];
            entity.HistoryPrice = [result stringForColumn:@"HistoryPrice"];
            entity.SalesVolume = [result stringForColumn:@"SalesVolume"];
            entity.minPrice = [result stringForColumn:@"minPrice"];
            entity.maxPrice = [result stringForColumn:@"maxPrice"];
            entity.priority = [result stringForColumn:@"priority"];
            entity.buyNumListStr = [result stringForColumn:@"buyNumListStr"];
            entity.Barcode = [result stringForColumn:@"Barcode"];
            entity.buyCount = [result stringForColumn:@"buyCount"];
            entity.store_Id = [result stringForColumn:@"store_Id"];
            entity.store_Name = [result stringForColumn:@"store_Name"];
            entity.minBuy = [result stringForColumn:@"minBuy"];
            entity.sxrq = [result stringForColumn:@"sxrq"];
            entity.pid = [result stringForColumn:@"pid"];
            entity.Price = [result stringForColumn:@"Price"];
            entity.sellType = [result stringForColumn:@"sellType"];
            entity.Product_Pcs = [result stringForColumn:@"Product_Pcs"];
            entity.Product_Pcs_Small = [result stringForColumn:@"Product_Pcs_Small"];
            entity.supplierName = [result stringForColumn:@"supplierName"];
            entity.myStock = [result stringForColumn:@"myStock"];
            entity.pmid = [result stringForColumn:@"pmid"];
            [array addObject:entity];
            
        }
        finished (array);
    }];
}




#pragma mark - 智慧采购暂不采购数据

/**
 *智慧采购暂不采购数据插入
 *@param entity   所传数据
 */
-(void)insertItemNotBuyWisdomList:(STWisdomEntity *)entity{
    NSString *sql=[NSString stringWithFormat:@"insert into WisdomNotBuyList(mTimestamp,Goods_Package_ID,memberID,userid,psn,PreChar,DrugsBase_Manufacturer,DrugsBase_ProName,DrugsBase_DrugName,DrugsBase_Formulation,Goods_Unit,DrugsBase_Specification,DrugsBase_ApprovalNumber,stock,LastTime,LastTimeString,HistoryPrice,SalesVolume,minPrice,maxPrice,priority,buyNumListStr,Barcode,buyCount,store_Id,store_Name,minBuy,sxrq,pid,Price,sellType,Product_Pcs,Product_Pcs_Small,supplierName,myStock,pmid) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:sql,entity.mTimestamp,entity.Goods_Package_ID,entity.memberID,entity.userid,entity.psn,entity.PreChar,entity.DrugsBase_Manufacturer,entity.DrugsBase_ProName,entity.DrugsBase_DrugName,entity.DrugsBase_Formulation,entity.Goods_Unit,entity.DrugsBase_Specification,entity.DrugsBase_ApprovalNumber,entity.stock,entity.LastTime,entity.LastTimeString,entity.HistoryPrice,entity.SalesVolume,entity.minPrice,entity.maxPrice,entity.priority,entity.buyNumListStr,entity.Barcode,entity.buyCount,entity.store_Id,entity.store_Name,entity.minBuy,entity.sxrq,entity.pid,entity.Price,entity.sellType,entity.Product_Pcs,entity.Product_Pcs_Small,entity.supplierName,entity.myStock,entity.pmid]){
        }
        else
            [db lastErrorMessage];
    }];
}

/**
 * 根据Goods_Package_ID数据更新
 */
-(void)updateNotBuyWisdomList:(NSString *)Goods_Package_ID WithValue:(NSDate *)value{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *strSql=[NSString stringWithFormat:@"update WisdomNotBuyList set mTimestamp =%@ where Goods_Package_ID=%@",value,Goods_Package_ID];
        if([db executeUpdate:strSql,value]){
        }else{
        }
    }];
}


//读数据
-(void)readDataNotBuyWisdomList:(void(^)(NSMutableArray *ary))finished{
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:@"SELECT * FROM WisdomNotBuyList"];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        while ([result next]){
            
            STWisdomEntity *entity = [STWisdomEntity new];
            
            entity.mTimestamp = [result dateForColumn:@"mTimestamp"];
            entity.Goods_Package_ID = [result stringForColumn:@"Goods_Package_ID"];
            entity.memberID = [result stringForColumn:@"memberID"];
            entity.userid = [result stringForColumn:@"userid"];
            entity.psn = [result stringForColumn:@"psn"];
            entity.PreChar = [result stringForColumn:@"PreChar"];
            entity.DrugsBase_Manufacturer = [result stringForColumn:@"DrugsBase_Manufacturer"];
            entity.DrugsBase_ProName = [result stringForColumn:@"DrugsBase_ProName"];
            entity.DrugsBase_DrugName = [result stringForColumn:@"DrugsBase_DrugName"];
            entity.DrugsBase_Formulation = [result stringForColumn:@"DrugsBase_Formulation"];
            entity.Goods_Unit = [result stringForColumn:@"Goods_Unit"];
            entity.DrugsBase_Specification = [result stringForColumn:@"DrugsBase_Specification"];
            entity.DrugsBase_ApprovalNumber = [result stringForColumn:@"DrugsBase_ApprovalNumber"];
            entity.stock = [result stringForColumn:@"stock"];
            entity.LastTime = [result stringForColumn:@"LastTime"];
            entity.LastTimeString = [result stringForColumn:@"LastTimeString"];
            entity.HistoryPrice = [result stringForColumn:@"HistoryPrice"];
            entity.SalesVolume = [result stringForColumn:@"SalesVolume"];
            entity.minPrice = [result stringForColumn:@"minPrice"];
            entity.maxPrice = [result stringForColumn:@"maxPrice"];
            entity.priority = [result stringForColumn:@"priority"];
            entity.buyNumListStr = [result stringForColumn:@"buyNumListStr"];
            entity.Barcode = [result stringForColumn:@"Barcode"];
            entity.buyCount = [result stringForColumn:@"buyCount"];
            entity.store_Id = [result stringForColumn:@"store_Id"];
            entity.store_Name = [result stringForColumn:@"store_Name"];
            entity.minBuy = [result stringForColumn:@"minBuy"];
            entity.sxrq = [result stringForColumn:@"sxrq"];
            entity.pid = [result stringForColumn:@"pid"];
            entity.Price = [result stringForColumn:@"Price"];
            entity.sellType = [result stringForColumn:@"sellType"];
            entity.Product_Pcs = [result stringForColumn:@"Product_Pcs"];
            entity.Product_Pcs_Small = [result stringForColumn:@"Product_Pcs_Small"];
            entity.supplierName = [result stringForColumn:@"supplierName"];
            entity.myStock = [result stringForColumn:@"myStock"];
            entity.pmid = [result stringForColumn:@"pmid"];
            [array addObject:entity];
        }
        finished  (array);
    }];
}

//根据Goods_Package_ID删除相应的数据
-(void)deleteNotBuyWisdomList:(NSString *)Goods_Package_ID andFinished:(void(^)(BOOL isYes))finished{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from WisdomNotBuyList where Goods_Package_ID == ?",Goods_Package_ID];
        finished(YES);
    }];
}

//删除全部数据
-(void)deleteAllNotBuyWisdomList{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM WisdomNotBuyList;"];
    }];
}

//根据某一字段读取数据
-(void)readNotBuyWisdomListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished{
    [self.queue inDatabase:^(FMDatabase *db) {
        //        FMResultSet *result = [db executeQuery:@"SELECT * FROM FriendList"];
        //        result = [db executeQuery:@"SELECT * FROM FriendList WHERE %@ = ?",name,searchName];
        
        NSString *sqStr = [NSString stringWithFormat:@"select * from WisdomNotBuyList where name= '%@'", searchName];
        FMResultSet *result = [db executeQuery:sqStr];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        while ([result next]){
            
            STWisdomEntity *entity = [STWisdomEntity new];
            
            entity.mTimestamp = [result dateForColumn:@"mTimestamp"];
            entity.Goods_Package_ID = [result stringForColumn:@"Goods_Package_ID"];
            entity.memberID = [result stringForColumn:@"memberID"];
            entity.userid = [result stringForColumn:@"userid"];
            entity.psn = [result stringForColumn:@"psn"];
            entity.PreChar = [result stringForColumn:@"PreChar"];
            entity.DrugsBase_Manufacturer = [result stringForColumn:@"DrugsBase_Manufacturer"];
            entity.DrugsBase_ProName = [result stringForColumn:@"DrugsBase_ProName"];
            entity.DrugsBase_DrugName = [result stringForColumn:@"DrugsBase_DrugName"];
            entity.DrugsBase_Formulation = [result stringForColumn:@"DrugsBase_Formulation"];
            entity.Goods_Unit = [result stringForColumn:@"Goods_Unit"];
            entity.DrugsBase_Specification = [result stringForColumn:@"DrugsBase_Specification"];
            entity.DrugsBase_ApprovalNumber = [result stringForColumn:@"DrugsBase_ApprovalNumber"];
            entity.stock = [result stringForColumn:@"stock"];
            entity.LastTime = [result stringForColumn:@"LastTime"];
            entity.LastTimeString = [result stringForColumn:@"LastTimeString"];
            entity.HistoryPrice = [result stringForColumn:@"HistoryPrice"];
            entity.SalesVolume = [result stringForColumn:@"SalesVolume"];
            entity.minPrice = [result stringForColumn:@"minPrice"];
            entity.maxPrice = [result stringForColumn:@"maxPrice"];
            entity.priority = [result stringForColumn:@"priority"];
            entity.buyNumListStr = [result stringForColumn:@"buyNumListStr"];
            entity.Barcode = [result stringForColumn:@"Barcode"];
            entity.buyCount = [result stringForColumn:@"buyCount"];
            entity.store_Id = [result stringForColumn:@"store_Id"];
            entity.store_Name = [result stringForColumn:@"store_Name"];
            entity.minBuy = [result stringForColumn:@"minBuy"];
            entity.sxrq = [result stringForColumn:@"sxrq"];
            entity.pid = [result stringForColumn:@"pid"];
            entity.Price = [result stringForColumn:@"Price"];
            entity.sellType = [result stringForColumn:@"sellType"];
            entity.Product_Pcs = [result stringForColumn:@"Product_Pcs"];
            entity.Product_Pcs_Small = [result stringForColumn:@"Product_Pcs_Small"];
            entity.supplierName = [result stringForColumn:@"supplierName"];
            entity.myStock = [result stringForColumn:@"myStock"];
            entity.pmid = [result stringForColumn:@"pmid"];
            
            [array addObject:entity];
            
        }
        finished (array);
    }];
}




#pragma mark - 智慧采购淘汰数据

/**
 *智慧采购淘汰数据插入
 *@param entity   所传数据
 */
-(void)insertItemEliminateWisdomList:(STWisdomEntity *)entity{
    NSString *sql=[NSString stringWithFormat:@"insert into EliminateWisdomList(mTimestamp,Goods_Package_ID,memberID,userid,psn,PreChar,DrugsBase_Manufacturer,DrugsBase_ProName,DrugsBase_DrugName,DrugsBase_Formulation,Goods_Unit,DrugsBase_Specification,DrugsBase_ApprovalNumber,stock,LastTime,LastTimeString,HistoryPrice,SalesVolume,minPrice,maxPrice,priority,buyNumListStr,Barcode,buyCount,store_Id,store_Name,minBuy,sxrq,pid,Price,sellType,Product_Pcs,Product_Pcs_Small,supplierName,myStock,pmid) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:sql,entity.mTimestamp,entity.Goods_Package_ID,entity.memberID,entity.userid,entity.psn,entity.PreChar,entity.DrugsBase_Manufacturer,entity.DrugsBase_ProName,entity.DrugsBase_DrugName,entity.DrugsBase_Formulation,entity.Goods_Unit,entity.DrugsBase_Specification,entity.DrugsBase_ApprovalNumber,entity.stock,entity.LastTime,entity.LastTimeString,entity.HistoryPrice,entity.SalesVolume,entity.minPrice,entity.maxPrice,entity.priority,entity.buyNumListStr,entity.Barcode,entity.buyCount,entity.store_Id,entity.store_Name,entity.minBuy,entity.sxrq,entity.pid,entity.Price,entity.sellType,entity.Product_Pcs,entity.Product_Pcs_Small,entity.supplierName,entity.myStock,entity.pmid]){
        }
        else
            [db lastErrorMessage];
    }];
}

/**
 * 根据Goods_Package_ID数据更新
 */
-(void)updateEliminateWisdomList:(NSString *)Goods_Package_ID WithValue:(NSDate *)value{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *strSql=[NSString stringWithFormat:@"update EliminateWisdomList set mTimestamp =%@ where Goods_Package_ID=%@",value,Goods_Package_ID];
        if([db executeUpdate:strSql,value]){
        }else{
        }
    }];
}


//读数据
-(void)readDataEliminateWisdomList:(void(^)(NSMutableArray *ary))finished{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:@"SELECT * FROM EliminateWisdomList"];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        while ([result next]){
            
            STWisdomEntity *entity = [STWisdomEntity new];
            
            entity.mTimestamp = [result dateForColumn:@"mTimestamp"];
            entity.Goods_Package_ID = [result stringForColumn:@"Goods_Package_ID"];
            entity.memberID = [result stringForColumn:@"memberID"];
            entity.userid = [result stringForColumn:@"userid"];
            entity.psn = [result stringForColumn:@"psn"];
            entity.PreChar = [result stringForColumn:@"PreChar"];
            entity.DrugsBase_Manufacturer = [result stringForColumn:@"DrugsBase_Manufacturer"];
            entity.DrugsBase_ProName = [result stringForColumn:@"DrugsBase_ProName"];
            entity.DrugsBase_DrugName = [result stringForColumn:@"DrugsBase_DrugName"];
            entity.DrugsBase_Formulation = [result stringForColumn:@"DrugsBase_Formulation"];
            entity.Goods_Unit = [result stringForColumn:@"Goods_Unit"];
            entity.DrugsBase_Specification = [result stringForColumn:@"DrugsBase_Specification"];
            entity.DrugsBase_ApprovalNumber = [result stringForColumn:@"DrugsBase_ApprovalNumber"];
            entity.stock = [result stringForColumn:@"stock"];
            entity.LastTime = [result stringForColumn:@"LastTime"];
            entity.LastTimeString = [result stringForColumn:@"LastTimeString"];
            entity.HistoryPrice = [result stringForColumn:@"HistoryPrice"];
            entity.SalesVolume = [result stringForColumn:@"SalesVolume"];
            entity.minPrice = [result stringForColumn:@"minPrice"];
            entity.maxPrice = [result stringForColumn:@"maxPrice"];
            entity.priority = [result stringForColumn:@"priority"];
            entity.buyNumListStr = [result stringForColumn:@"buyNumListStr"];
            entity.Barcode = [result stringForColumn:@"Barcode"];
            entity.buyCount = [result stringForColumn:@"buyCount"];
            entity.store_Id = [result stringForColumn:@"store_Id"];
            entity.store_Name = [result stringForColumn:@"store_Name"];
            entity.minBuy = [result stringForColumn:@"minBuy"];
            entity.sxrq = [result stringForColumn:@"sxrq"];
            entity.pid = [result stringForColumn:@"pid"];
            entity.Price = [result stringForColumn:@"Price"];
            entity.sellType = [result stringForColumn:@"sellType"];
            entity.Product_Pcs = [result stringForColumn:@"Product_Pcs"];
            entity.Product_Pcs_Small = [result stringForColumn:@"Product_Pcs_Small"];
            entity.supplierName = [result stringForColumn:@"supplierName"];
            entity.myStock = [result stringForColumn:@"myStock"];
            entity.pmid = [result stringForColumn:@"pmid"];
            
            [array addObject:entity];
        }
        finished  (array);
    }];
}

//根据Goods_Package_ID删除相应的数据
-(void)deleteEliminateWisdomList:(NSString *)Goods_Package_ID andFinished:(void(^)(BOOL isYes))finished{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from EliminateWisdomList where Goods_Package_ID == ?",Goods_Package_ID];
        finished(YES);
    }];
}

//删除全部数据
-(void)deleteAllEliminateWisdomList{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM EliminateWisdomList;"];
    }];
}

//根据某一字段读取数据
-(void)readEliminateWisdomListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished{
    [self.queue inDatabase:^(FMDatabase *db) {
        //        FMResultSet *result = [db executeQuery:@"SELECT * FROM FriendList"];
        //        result = [db executeQuery:@"SELECT * FROM FriendList WHERE %@ = ?",name,searchName];
        
        NSString *sqStr = [NSString stringWithFormat:@"select * from EliminateWisdomList where name= '%@'", searchName];
        FMResultSet *result = [db executeQuery:sqStr];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        while ([result next]){
            
            STWisdomEntity *entity = [STWisdomEntity new];
            
            entity.mTimestamp = [result dateForColumn:@"mTimestamp"];
            entity.Goods_Package_ID = [result stringForColumn:@"Goods_Package_ID"];
            entity.memberID = [result stringForColumn:@"memberID"];
            entity.userid = [result stringForColumn:@"userid"];
            entity.psn = [result stringForColumn:@"psn"];
            entity.PreChar = [result stringForColumn:@"PreChar"];
            entity.DrugsBase_Manufacturer = [result stringForColumn:@"DrugsBase_Manufacturer"];
            entity.DrugsBase_ProName = [result stringForColumn:@"DrugsBase_ProName"];
            entity.DrugsBase_DrugName = [result stringForColumn:@"DrugsBase_DrugName"];
            entity.DrugsBase_Formulation = [result stringForColumn:@"DrugsBase_Formulation"];
            entity.Goods_Unit = [result stringForColumn:@"Goods_Unit"];
            entity.DrugsBase_Specification = [result stringForColumn:@"DrugsBase_Specification"];
            entity.DrugsBase_ApprovalNumber = [result stringForColumn:@"DrugsBase_ApprovalNumber"];
            entity.stock = [result stringForColumn:@"stock"];
            entity.LastTime = [result stringForColumn:@"LastTime"];
            entity.LastTimeString = [result stringForColumn:@"LastTimeString"];
            entity.HistoryPrice = [result stringForColumn:@"HistoryPrice"];
            entity.SalesVolume = [result stringForColumn:@"SalesVolume"];
            entity.minPrice = [result stringForColumn:@"minPrice"];
            entity.maxPrice = [result stringForColumn:@"maxPrice"];
            entity.priority = [result stringForColumn:@"priority"];
            entity.buyNumListStr = [result stringForColumn:@"buyNumListStr"];
            entity.Barcode = [result stringForColumn:@"Barcode"];
            entity.buyCount = [result stringForColumn:@"buyCount"];
            entity.store_Id = [result stringForColumn:@"store_Id"];
            entity.store_Name = [result stringForColumn:@"store_Name"];
            entity.minBuy = [result stringForColumn:@"minBuy"];
            entity.sxrq = [result stringForColumn:@"sxrq"];
            entity.pid = [result stringForColumn:@"pid"];
            entity.Price = [result stringForColumn:@"Price"];
            entity.sellType = [result stringForColumn:@"sellType"];
            entity.Product_Pcs = [result stringForColumn:@"Product_Pcs"];
            entity.Product_Pcs_Small = [result stringForColumn:@"Product_Pcs_Small"];
            entity.supplierName = [result stringForColumn:@"supplierName"];
            entity.myStock = [result stringForColumn:@"myStock"];
            entity.pmid = [result stringForColumn:@"pmid"];
            
            [array addObject:entity];
            
        }
        finished (array);
    }];
}
@end
