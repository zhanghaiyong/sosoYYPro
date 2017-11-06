//
//  DCFMDatabaseQueue.h
//  InstFit
//
//  Created by Bitaxon-mac on 16/8/15.
//  Copyright © 2016年 administrator-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFMDatabaseQueue : NSObject


+(DCFMDatabaseQueue *)sharedDatabase;

-(void)countOfTableName:(NSString *)tableName andFinished:(void(^)(NSInteger index))finished;
-(void)existsDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSString *)nameValue andFinished:(void(^)(BOOL isYes))finished;
-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withValue:(NSArray *)valueArray;
-(void)deleteDataWithTable:(NSString *)table withItemName:(NSString *)itemName withString:(NSString *)valueSting;
-(void)updateTable:(NSString *)table widthValueName:(NSString *)name withVale:(NSString *)value ofSearchName:(NSString *)searchName ofSearchValue:(NSString *)searchValue;


#pragma mark - 智慧采购数据

/**
 *智慧采购审计化数据插入
 *@param entity   所传数据
 */
-(void)insertItemWithWisdomList:(STWisdomEntity *)entity;

/**
 * 根据Goods_Package_ID数据更新
 */
-(void)updateWisdomList:(NSString *)Goods_Package_ID WithValue:(NSDate *)value;

//根据Goods_Package_ID更新buyCount
-(void)setUpdateSql:(NSString *)buyCount goods_Package_ID:(NSString *)Goods_Package_ID finished:(void(^)(BOOL isYes))finished;

//排序读数据
-(void)readDataWisdomListToSortByWisdomType:(int)type andFinished:(void(^)(NSMutableArray *ary))finished;

//根据Goods_Package_ID删除相应的数据
-(void)deleteWisdomList:(NSString *)Goods_Package_ID andFinished:(void(^)(BOOL isYes))finished;

//删除全部数据
-(void)deleteAllWisdomList;

//根据某一字段读取数据
-(void)readWisdomListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished;



#pragma mark - 智慧采购暂不采购数据

/**
 *智慧采购暂不采购数据插入
 *@param entity   所传数据
 */
-(void)insertItemNotBuyWisdomList:(STWisdomEntity *)entity;

/**
 * 根据Goods_Package_ID数据更新
 */
-(void)updateNotBuyWisdomList:(NSString *)Goods_Package_ID WithValue:(NSDate *)value;


//读数据
-(void)readDataNotBuyWisdomList:(void(^)(NSMutableArray *ary))finished;

//根据Goods_Package_ID删除相应的数据
-(void)deleteNotBuyWisdomList:(NSString *)Goods_Package_ID andFinished:(void(^)(BOOL isYes))finished;

//删除全部数据
-(void)deleteAllNotBuyWisdomList;

//根据某一字段读取数据
-(void)readNotBuyWisdomListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished;

#pragma mark - 智慧采购淘汰数据

/**
 *智慧采购淘汰数据插入
 *@param entity   所传数据
 */
-(void)insertItemEliminateWisdomList:(STWisdomEntity *)entity;

/**
 * 根据Goods_Package_ID数据更新
 */
-(void)updateEliminateWisdomList:(NSString *)Goods_Package_ID WithValue:(NSDate *)value;


//读数据
-(void)readDataEliminateWisdomList:(void(^)(NSMutableArray *ary))finished;

//根据Goods_Package_ID删除相应的数据
-(void)deleteEliminateWisdomList:(NSString *)Goods_Package_ID andFinished:(void(^)(BOOL isYes))finished;

//删除全部数据
-(void)deleteAllEliminateWisdomList;

//根据某一字段读取数据
-(void)readEliminateWisdomListDBName:(NSString *)name andSearchName:(NSString *)searchName andFinished:(void(^)(NSMutableArray *ary))finished;

@end
