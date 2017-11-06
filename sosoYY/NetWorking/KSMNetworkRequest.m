//
//  KSMNetworkRequest.m
//
//  Created by ksm on 15/11/10.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import "KSMNetworkRequest.h"
#import "ShareManagerCtrl.h"
#import "STCommon.h"
#import "StepTools.h"
@implementation KSMNetworkRequest


+(void)cancelquest {
    
    AFHTTPSessionManager *manager = [ShareManagerCtrl shareManager];
    [[manager operationQueue] cancelAllOperations];
}

+ (void)getRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    //网络不可用
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
        return;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [ShareManagerCtrl shareManager];
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            successHandler(responseObject);
            
        }else if ([responseObject isKindOfClass:[NSArray class]]){
            successHandler(responseObject);
        }else if ([responseObject isKindOfClass:[NSString class]]){
            
            [ZHProgressHUD showInfoWithText:@"返回数据有误"];
            
            return ;
        }else{
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            successHandler(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        KSMLog(@"------请求失败-------%@",error);
        
        [ZHProgressHUD showInfoWithText:@"请求失败"];
        
        failureHandler(error);
    }];
}



+ (void)postRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
        return;
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [ShareManagerCtrl shareManager];
    [manager.requestSerializer setTimeoutInterval:15];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            successHandler(responseObject);
            
        }else if ([responseObject isKindOfClass:[NSArray class]]){
            
            successHandler(responseObject);
            
        }else if ([responseObject isKindOfClass:[NSString class]]){
            [ZHProgressHUD showInfoWithText:@"返回数据有误"];
            return ;
        }else{
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            successHandler(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        KSMLog(@"------请求失败-------%@",error);
        [ZHProgressHUD showInfoWithText:@"请求失败"];
        failureHandler(error);
    }];
}


+ (void)updateImgRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
        return;
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [ShareManagerCtrl shareManager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // name必须和后台PHP接收的参数名相同
        // fileName为图片名
        [formData appendPartWithFileData:[StepTools compressOriginalImage:params[@"image"] toMaxDataSizeKBytes:99] name:params[@"imageName"] fileName:params[@"imageName"] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            successHandler(responseObject);
        }else if ([responseObject isKindOfClass:[NSArray class]]){
            successHandler(responseObject);
        }else if ([responseObject isKindOfClass:[NSString class]]){
            [ZHProgressHUD showInfoWithText:@"返回数据有误"];
            return ;
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dic = %@",dic);
            successHandler(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        KSMLog(@"------请求失败-------%@",error);
        [ZHProgressHUD showInfoWithText:@"请求失败"];
        failureHandler(error);
    }];
}


//是否上传gps
+ (void)IsUploadGps:(NSString *)url finished:(void(^)(BOOL finish))finished {
    
    [self postRequest:url params:nil success:^(id responseObj) {
        
        if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {
            finished(NO);
        }else {
            if ([responseObj[@"data"] integerValue] == 1) {
                
                finished(YES);
            }else {
                finished(NO);
            }
        }
    } failure:^(NSError *error) {
        finished(NO);
    }];
}

//智慧采购删除商品
+ (void)WisdomShopCartDeleteProduce:(NSString *)url params:(id)params finished:(void(^)(BOOL finish))finished {
    
    [self postRequest:url params:params success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] integerValue] == 200) {
            
            finished(YES);
        }else {
            
            finished(NO);
        }
        
    } failure:^(NSError *error) {
        
        finished(NO);
    }];
}

//智慧采购淘汰商品
+ (void)WisdomShopCartWeekOutProduce:(NSString *)url params:(id)params finished:(void(^)(BOOL finish))finished {
    
    [self postRequest:url params:params success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] integerValue] == 200) {
            
            finished(YES);
        }else {
            
            finished(NO);
        }
        
    } failure:^(NSError *error) {
        
        finished(NO);
    }];
}

//展开。折叠
+ (void)WisdomExpandChange:(NSString *)url params:(id)params finished:(void(^)(BOOL finish))finished {
    
    [self postRequest:url params:params success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
            
            finished(YES);
        }else {
            
            finished(NO);
        }
        
    } failure:^(NSError *error) {
        
        finished(NO);
    }];
}

+(void)getProductListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STProductListEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        STProductListEntity *mode = [STProductListEntity new];
        mode.pageIndex = [responseObj[@"pageIndex"]integerValue];
        mode.recordCount = [responseObj[@"recordCount"]integerValue];
        mode.pageCount = [responseObj[@"PageCount"]integerValue];
        
        for (NSDictionary *dict in responseObj[@"list"]) {
            STProductListEntity *entity = [STProductListEntity new];
            entity.productId = dict[@"id"];
            entity.goods_Package_ID = dict[@"Goods_Package_ID"];
            entity.drugsBase_DrugName = dict[@"DrugsBase_DrugName"];
            entity.drugsBase_SimpeCode = dict[@"DrugsBase_SimpeCode"];
            
            if (![dict[@"DrugsBase_ProName"] isKindOfClass:[NSNull class]]) {
                entity.drugsBase_ProName = dict[@"DrugsBase_ProName"];
            }else {
                entity.drugsBase_ProName = @"";
            }
            
            entity.drugsBase_Manufacturer = dict[@"DrugsBase_Manufacturer"];
            entity.goods_Pcs = dict[@"Goods_Pcs"];
            entity.goods_Unit = dict[@"Goods_Unit"];
            entity.originalImageUrl = dict[@"OriginalImageUrl"];
            entity.imageUrl = dict[@"ImageUrl"];
            entity.surfaceUrl = dict[@"SurfaceUrl"];
            entity.drugsBase_Specification = dict[@"DrugsBase_Specification"];
            entity.marketPrice = dict[@"MarketPrice"];
            entity.minShopPrice = dict[@"MinShopPrice"];
            entity.maxShopPrice = dict[@"MaxShopPrice"];
            entity.maxGrossMargin = dict[@"MaxGrossMargin"];
            entity.storeId = dict[@"StoreId"];
            entity.sellerCount = dict[@"SellerCount"];
            entity.saleCount = dict[@"SaleCount"];
            entity.repeatBuyCount = dict[@"RepeatBuyCount"];
            entity.favoriteCount = dict[@"FavoriteCount"];
            entity.reviewCount = dict[@"ReviewCount"];
            entity.isHighMargin = dict[@"IsHighMargin"];
            entity.tag_PharmAttribute_fullPath = dict[@"Tag_PharmAttribute_fullPath"];
            if (![dict[@"Tag_PharmAttribute_id"] isKindOfClass:[NSNull class]]) {
                entity.tag_PharmAttribute_id = dict[@"Tag_PharmAttribute_id"];
            }else {
                entity.tag_PharmAttribute_id = @"";
            }
            
            entity.priceRange = dict[@"PriceRange"];
            entity.grossMarginRange = dict[@"GrossMarginRange"];
            entity.pid = dict[@"Pid"];
            entity.addr_Ids_Seller = dict[@"Addr_Ids_Seller"];
            entity.addr_control = dict[@"Addr_control"];
            entity.type_control = dict[@"Type_control"];
            entity.addPriceBuyTimeList = dict[@"AddPriceBuyTimeList"];
            entity.salesAll = dict[@"SalesAll"];
            entity.isExemptPostage = dict[@"isExemptPostage"];
            if (![dict[@"PromotionTypes"] isKindOfClass:[NSNull class]]) {
                entity.promotionTypes = dict[@"PromotionTypes"];
            }else {
                entity.promotionTypes = @"";
            }
            entity.visitcount = dict[@"visitcount"];
            entity.salecount30 = dict[@"salecount30"];
            entity.salecounthalfyear = dict[@"salecounthalfyear"];
            entity.salecountyear = dict[@"salecountyear"];
            entity.IsStandard = dict[@"IsStandard"];
            entity.ImageUrl_NoStandard_Top1 = dict[@"ImageUrl_NoStandard_Top1"];
            
            if (![dict[@"PricePromotionsTypes"] isKindOfClass:[NSNull class]]) {
                entity.PricePromotionsTypes = dict[@"PricePromotionsTypes"];
            }else {
                entity.PricePromotionsTypes = @"";
            }
            
            
            [dataResult addObject:entity];
        }
        finshed(dataResult,mode,nil);
        
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}

+(void)getProductAssociateUrl:(NSString *)url text:(NSString *)text finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:@{@"q":text} success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        [dataResult addObjectsFromArray:responseObj];
        finshed(dataResult,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getShopAssociateUrl:(NSString *)url text:(NSString *)text finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:@{@"q":text} success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        [dataResult addObjectsFromArray:responseObj];
        finshed(dataResult,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getShopListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STShopListEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *shopDataResult = [NSMutableArray new];
        STShopListEntity *mode = [STShopListEntity new];
        
        mode.pageIndex = [responseObj[@"PageModel"][@"PageIndex"]integerValue];
        mode.totalCount = [responseObj[@"PageModel"][@"TotalCount"]integerValue];
        mode.pageCount = [responseObj[@"PageModel"][@"TotalPages"]integerValue];
        mode.keyWord = responseObj[@"Word"];
        
        for (NSDictionary *dict in responseObj[@"BaseInfoList"]) {
            STShopListEntity *entity = [STShopListEntity new];
            entity.ProductsCount = dict[@"ProductsCount"];
            entity.storeId = dict[@"StoreId"];
            entity.islous = dict[@"islous"];
            entity.state = [dict[@"State"] intValue];
            entity.storeName = dict[@"Name"];
            entity.regionId = dict[@"RegionId"];
            entity.storeRid = dict[@"StoreRid"];
            entity.StoreIid = dict[@"StoreIid"];
            entity.Logo = dict[@"Logo"];
            entity.CreateTime = dict[@"CreateTime"];
            entity.Mobile = dict[@"Mobile"];
            entity.Phone = dict[@"Phone"];
            entity.QQ = dict[@"QQ"];
            entity.WW = dict[@"WW"];
            entity.DePoint = dict[@"DePoint"];
            entity.SePoint = dict[@"SePoint"];
            entity.ShPoint = dict[@"ShPoint"];
            entity.Honesties = dict[@"Honesties"];
            entity.StateEndTime = dict[@"StateEndTime"];
            entity.Theme = dict[@"Theme"];
            entity.Banner = dict[@"Banner"];
            entity.Announcement = dict[@"Announcement"];
            entity.Description = dict[@"Description"];
            entity.Account = dict[@"Account"];
            entity.ManagerUid = dict[@"ManagerUid"];
            entity.ManagerName = dict[@"ManagerName"];
            entity.Address = dict[@"Address"];
            entity.Contact = dict[@"Contact"];
            entity.LowestdeliveryAmount = dict[@"LowestdeliveryAmount"];
            entity.LowestFreeShippingAmount = dict[@"StoreCountModel"][@"lowestFreeShippingAmount"];
            
            
            entity.DefaultShipFee = dict[@"DefaultShipFee"];
            entity.DeliveryType = dict[@"DeliveryType"];
            entity.DomainName = dict[@"DomainName"];
            entity.TaxPolicy = dict[@"StoreCountModel"][@"tax_policy"];
            entity. Addr_Ids_Seller = dict[@"Addr_Ids_Seller"];
            entity.IsLinkErp = dict[@"IsLinkErp"];
            entity.addPrice = dict[@"StoreCountModel"][@"addPrice"];
            
            entity.TopProducts = [NSMutableArray new];
            for (NSDictionary *dict2 in dict[@"TopProducts"]) {
                STShopListEntity *entity2 = [STShopListEntity new];
                entity2.pid = dict2[@"pid"];
                entity2.DrugsBase_DrugName = dict2[@"DrugsBase_DrugName"];
                entity2.shopprice = dict2[@"shopprice"];
                entity2.marketprice = dict2[@"marketprice"];
                entity2.sellType = dict2[@"sellType"];
                entity2.salecount = dict2[@"salecount"];
                entity2.imageNmae = dict2[@"images"];
                [entity.TopProducts addObject:entity2];
            }
            [shopDataResult addObject:entity];
        }
        finshed(shopDataResult,mode,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}

+(void)getStorewideListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STStorewideEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *storewideDataResult = [NSMutableArray new];
        STStorewideEntity *mode = [STStorewideEntity new];
        mode.pageIndex = [responseObj[@"PageModel"][@"PageIndex"] integerValue];
        mode.recordCount = [responseObj[@"PageModel"][@"TotalCount"] integerValue];
        mode.pageCount = [responseObj[@"PageModel"][@"TotalPages"] integerValue];
        
        
        for (NSDictionary *dict in responseObj[@"StoreOlineProductList"]) {
            STStorewideEntity *entity = [STStorewideEntity new];
            entity.Pid = dict[@"Pid"];
            entity.StoreId = dict[@"StoreId"];
            entity.StoreCid = dict[@"StoreCid"];
            entity.Goods_Package_ID = dict[@"Goods_Package_ID"];
            entity.DrugsBase_DrugName = dict[@"DrugsBase_DrugName"];
            entity.DrugsBase_SimpeCode = dict[@"DrugsBase_SimpeCode"];
            entity.DrugsBase_ProName = dict[@"DrugsBase_ProName"];
            entity.DrugsBase_Manufacturer = dict[@"DrugsBase_Manufacturer"];
            entity.OriginalImageUrl = dict[@"OriginalImageUrl"];
            entity.Tag_PharmAttribute_fullPath = dict[@"Tag_PharmAttribute_fullPath"];
            entity.ImageUrl = dict[@"ImageUrl"];
            entity.SurfaceUrl = dict[@"SurfaceUrl"];
            entity.DrugsBase_Specification = dict[@"DrugsBase_Specification"];
            entity.MarketPrice = dict[@"MarketPrice"];
            entity.ShopPrice = dict[@"ShopPrice"];
            entity.GrossMargin = dict[@"GrossMargin"];
            entity.SaleCount = dict[@"SaleCount"];
            entity.SaleAmount = dict[@"SaleAmount"];
            entity.Addr_Ids_Seller = dict[@"Addr_Ids_Seller"];
            entity.Addr_Control = dict[@"Addr_Control"];
            entity.Type_Control = dict[@"Type_Control"];
            entity.IsKong = dict[@"IsKong"];
            entity.visitcount = dict[@"visitcount"];
            entity.IsStandard = dict[@"IsStandard"];
            entity.ImageUrl_NoStandard_Top1 = dict[@"ImageUrl_NoStandard_Top1"];
            entity.PricePromotionsTypes = dict[@"PricePromotionsTypes"];
            [storewideDataResult addObject:entity];
        }
        
        finshed(storewideDataResult,mode,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}

+(void)getStoreClassAssociateUrl:(NSString *)url params:(id)params finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        [dataResult addObjectsFromArray:responseObj];
        finshed(dataResult,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getStoreClassUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STStoreClassEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        
        for (NSDictionary *dict in responseObj) {
            STStoreClassEntity *entity = [STStoreClassEntity new];
            entity.StoreCid = dict[@"StoreCid"];
            entity.StoreId = dict[@"StoreId"];
            entity.DisplayOrder = dict[@"DisplayOrder"];
            entity.Name = dict[@"Name"];
            entity.ParentId = dict[@"ParentId"];
            entity.Layer = dict[@"Layer"];
            entity.HasChild = dict[@"HasChild"];
            entity.Path = dict[@"Path"];
            entity.StoreCount = dict[@"StoreCount"];
            entity.AllStoreCount = dict[@"AllStoreCount"];
            
            [dataResult addObject:entity];
        }
        
        finshed(dataResult,nil,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}


+(void)getSearchListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STCateListEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        for (NSDictionary *GroupDict in responseObj) {
            STCateListEntity *GroupEntity = [STCateListEntity new];
            GroupEntity.GroupCateId = GroupDict[@"CateId"];
            GroupEntity.GroupCateName = GroupDict[@"CateName"];
            GroupEntity.GroupImagesUrl = GroupDict[@"ImagesUrl"];
            GroupEntity.GroupCateList = [NSMutableArray new];
            for (NSDictionary *dict in GroupDict[@"CateList"]) {
                STCateListEntity *entity = [STCateListEntity new];
                entity.CateId = dict[@"CateId"];
                entity.CateName = dict[@"CateName"];
                entity.ImagesUrl = dict[@"ImagesUrl"];
                entity.CateList = dict[@"CateList"];
                [GroupEntity.GroupCateList addObject:entity];
            }
            
            [dataResult addObject:GroupEntity];
        }
        finshed(dataResult,nil,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}
+(void)getSearchGetCateProductsUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STCateListEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        for (NSDictionary *dict in responseObj) {
            STCateListEntity *entity = [STCateListEntity new];
            entity.CateId = dict[@"CateId"];
            entity.CateName = dict[@"CateName"];
            entity.ImagesUrl = dict[@"ImagesUrl"];
            entity.CateList = dict[@"CateList"];
            [dataResult addObject:entity];
        }
        finshed(dataResult,nil,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}

+(void)getShopHomeListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(responseObj,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}
+(void)getShopInfoListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(responseObj,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}
+(void)getShopAddStoreToFavoriteUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(responseObj,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}
+(void)getShopAddStoreDelFavoriteUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(responseObj,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

//智慧采购
+(void)getWisdomProcurementUrl:(NSString *)url params:(id)params type:(NSInteger)type finshed:(void(^)(NSMutableArray *dataResult,NSMutableArray *indexResult,NSError *error,NSMutableDictionary *indexDict,NSString *mobile))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableDictionary *dictIndex = [NSMutableDictionary new];
        [dictIndex setObject:[NSString stringWithFormat:@"%@",responseObj[@"matchingCount"]] forKey:@"matchingCount"];
        [dictIndex setObject:[NSString stringWithFormat:@"%@",responseObj[@"notMatchingCount"]] forKey:@"notMatchingCount"];
        [dictIndex setObject:[NSString stringWithFormat:@"%@",responseObj[@"notPurchaseCount"] ]forKey:@"notPurchaseCount"];
        
        NSString *mobile = responseObj[@"mobile"];
        NSMutableArray *dataResult = [NSMutableArray new];
        
        for (NSDictionary *dict in responseObj[@"list"]) {
            STWisdomEntity *entity = [STWisdomEntity new];
            entity.memberID = dict[@"id"];
            entity.userid = dict[@"userid"];
            entity.psn = dict[@"psn"];
            entity.Goods_Package_ID = dict[@"Goods_Package_ID"];
            entity.PreChar = dict[@"PreChar"];
            entity.DrugsBase_Manufacturer = dict[@"DrugsBase_Manufacturer"];
            entity.DrugsBase_ProName = dict[@"DrugsBase_ProName"];
            entity.DrugsBase_DrugName = dict[@"DrugsBase_DrugName"];
            entity.DrugsBase_Formulation = dict[@"DrugsBase_Formulation"];
            entity.Goods_Unit = dict[@"Goods_Unit"];
            entity.DrugsBase_Specification = dict[@"DrugsBase_Specification"];
            entity.DrugsBase_ApprovalNumber = dict[@"DrugsBase_ApprovalNumber"];
            entity.stock = dict[@"stock"];
            entity.LastTime = dict[@"LastTime"];
            entity.LastTimeString = dict[@"LastTimeString"];
            entity.HistoryPrice = dict[@"HistoryPrice"];
            entity.SalesVolume = dict[@"SalesVolume"];
            entity.minPrice = dict[@"minPrice"];
            entity.maxPrice = dict[@"maxPrice"];
            entity.priority = dict[@"priority"];
            entity.buyNumList = dict[@"buyNumList"];
            //将array数组转换为string字符串
            NSString *tempString = [entity.buyNumList componentsJoinedByString:@","];//分隔符逗号
            entity.buyNumListStr = tempString;
            entity.Barcode = dict[@"Barcode"];
            entity.buyCount = dict[@"buyCount"];
            entity.store_Id = dict[@"store_Id"];
            entity.store_Name = dict[@"store_Name"];
            entity.minBuy = dict[@"minBuy"];
            entity.sxrq = dict[@"sxrq"];
            entity.pid = dict[@"pid"];
            entity.Price = dict[@"Price"];
            entity.sellType = dict[@"sellType"];
            entity.Product_Pcs = dict[@"Product_Pcs"];
            entity.Product_Pcs_Small = dict[@"Product_Pcs_Small"];
            entity.supplierName = dict[@"supplierName"];
            entity.myStock = dict[@"myStock"];
            entity.pmid = @"0";
            entity.speprice = dict[@"speprice"];
            entity.isSelect = dict[@"isSelect"];
            entity.YesterdayNoStock = dict[@"YesterdayNoStock"];
            
            [dataResult addObject:entity];
        }
        
        //        [[STCommon  sharedSTSTCommon] setSaveMoreWisdomListDataBase:dataResult type:0];
        //
        //
        //    [[DCFMDatabaseQueue sharedDatabase] readDataWisdomListToSortByWisdomType:2 andFinished:^(NSMutableArray *ary) {
        //        [[STCommon sharedSTSTCommon] setArrayWithPinYinFirstLetterFormat:ary type:type finished:^(NSMutableArray *dataAry, NSMutableArray *indexAry) {
        //                        finshed(dataAry,indexAry,nil,dictIndex,mobile);
        //                    }];
        //        }];
        
        
        [[STCommon sharedSTSTCommon] setArrayWithPinYinFirstLetterFormat:dataResult type:type finished:^(NSMutableArray *dataAry, NSMutableArray *indexAry) {
            finshed(dataAry,indexAry,nil,dictIndex,mobile);
        }];
        
        
    } failure:^(NSError *error) {
        finshed(nil,nil,error,0,nil);
    }];
}

+(void)getDeletePurchaseUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(responseObj,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}


+(void)getChangePurchaseCountUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(responseObj,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}
+(void)getPurchaseSchemeUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        for (NSDictionary *dict in responseObj[@"list"]) {
            STPurchaseSchemeEntity *entity = [STPurchaseSchemeEntity new];
            entity.SchemeName = dict[@"SchemeName"];
            entity.EconomizeTime = dict[@"EconomizeTime"];
            entity.EconomizeMoney = dict[@"EconomizeMoney"];
            entity.SuperiorityNum = dict[@"SuperiorityNum"];
            entity.StoresCount = dict[@"StoresCount"];
            entity.Postage = dict[@"Postage"];
            entity.SurplusMoney = dict[@"SurplusMoney"];
            entity.mismatching = dict[@"mismatching"];
            entity.Count = dict[@"Count"];
            [dataResult addObject:entity];
        }
        finshed(dataResult,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getCancelDeletePurchaseForIdUrl:(NSString *)url params:(id)params finshed:(void(^)(BOOL isYes,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(YES,nil);
    } failure:^(NSError *error) {
        finshed(NO,error);
    }];
}


+(void)getDeletePurchaseEliminateParamsUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        finshed(responseObj,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getCancelDeletePurchaseEliminateForIdUrl:(NSString *)url params:(id)params finshed:(void(^)(BOOL isYes,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] integerValue] == 200) {
            
            finshed(YES,nil);
        }else {
            
            finshed(NO,nil);
        }
        
    } failure:^(NSError *error) {
        finshed(NO,error);
    }];
}


+(void)getSearchProductNewUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STStorewideEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        STStorewideEntity *mode = [STStorewideEntity new];
        
        mode.pageIndex = [responseObj[@"PageModel"][@"PageIndex"] integerValue];
        mode.recordCount = [responseObj[@"PageModel"][@"TotalCount"] integerValue];
        mode.pageCount = [responseObj[@"PageModel"][@"TotalPages"] integerValue];
        mode.Total_Amount = responseObj[@"Total_Amount"];
        mode.D_Amount = responseObj[@"D_Amount"];
        mode.lowestFreeShippingAmount = responseObj[@"lowestFreeShippingAmount"];
        
        for (NSDictionary *dict in responseObj[@"ProductWisdomList"]) {
            STStorewideEntity *entity = [STStorewideEntity new];
            entity.Pid = dict[@"Pid"];
            entity.StoreId = dict[@"StoreId"];
            entity.StoreCid = dict[@"StoreCid"];
            entity.Goods_Package_ID = dict[@"Goods_Package_ID"];
            entity.DrugsBase_DrugName = dict[@"DrugsBase_DrugName"];
            entity.DrugsBase_SimpeCode = dict[@"DrugsBase_SimpeCode"];
            entity.DrugsBase_ProName = dict[@"DrugsBase_ProName"];
            entity.DrugsBase_Manufacturer = dict[@"DrugsBase_Manufacturer"];
            entity.OriginalImageUrl = dict[@"OriginalImageUrl"];
            entity.Tag_PharmAttribute_fullPath = dict[@"Tag_PharmAttribute_fullPath"];
            entity.ImageUrl = dict[@"ImageUrl"];
            entity.SurfaceUrl = dict[@"SurfaceUrl"];
            entity.DrugsBase_Specification = dict[@"DrugsBase_Specification"];
            entity.MarketPrice = dict[@"MarketPrice"];
            entity.ShopPrice = dict[@"ShopPrice"];
            entity.GrossMargin = dict[@"GrossMargin"];
            entity.SaleCount = dict[@"SaleCount"];
            entity.SaleAmount = dict[@"SaleAmount"];
            entity.Addr_Ids_Seller = dict[@"Addr_Ids_Seller"];
            entity.Addr_Control = dict[@"Addr_Control"];
            entity.Type_Control = dict[@"Type_Control"];
            entity.IsKong = dict[@"IsKong"];
            entity.visitcount = dict[@"visitcount"];
            entity.IsStandard = dict[@"IsStandard"];
            entity.ImageUrl_NoStandard_Top1 = dict[@"ImageUrl_NoStandard_Top1"];
            entity.PricePromotionsTypes = dict[@"PricePromotionsTypes"];
            entity.speprice = dict[@"speprice"];
            entity.SpecialPrice = dict[@"SpecialPrice"];
            entity.AddPriceBuy = dict[@"AddPriceBuy"];
            entity.goods_Unit = dict[@"Goods_Unit"];
            entity.sxrq = dict[@"sxrq"];
            entity.cuxiaotype = dict[@"cuxiaotype"];
            entity.stock = dict[@"stock"];
            entity.MinBuyNum = dict[@"MinBuyNum"];
            entity.IsJxq = dict[@"IsJxq"];
            entity.sellType = dict[@"sellType"];
            entity.Product_Pcs = dict[@"Product_Pcs"];
            entity.Product_Pcs_Small = dict[@"Product_Pcs_Small"];
            entity.isBuy = dict[@"isBuy"];
            
            
            [dataResult addObject:entity];
        }
        finshed(dataResult,mode,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}


+(void)getAddPurchaseProductUrl:(NSString *)url params:(id)params  finshed:(void(^)(STStorewideEntity *entity,NSString *mesg,NSString *code, NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        
        NSString *mesg = responseObj[@"info"];
        
        NSString *code = responseObj[@"success"];
        
        if ([responseObj[@"success"] intValue] == 1) {
            
            
            STStorewideEntity *entity = [STStorewideEntity new];
            entity.Total_Amount = responseObj[@"data"][@"Surplusmoney"];
            entity.D_Amount = responseObj[@"data"][@"DifflowestdeliveryAmount"];
            entity.lowestFreeShippingAmount = responseObj[@"data"][@"lowestFreeShippingAmount"];
            
            finshed(entity,mesg,code,nil);
        }else{
            [ZHProgressHUD showInfoWithText:mesg];
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }
        
    } failure:^(NSError *error) {
        [ZHProgressHUD showInfoWithText:@"请求失败"];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}



+(void)getArtificialPurchasingUrl:(NSString *)url finshed:(void(^)(NSMutableArray *dataResult,NSError *error))finshed{
    [self getRequest:url params:nil success:^(id responseObj) {
        
        NSMutableArray *dataResult = [NSMutableArray new];
        for (NSDictionary *dict in responseObj[@"list"]) {
            STWisdomEntity *entity = [STWisdomEntity new];
            entity.supplierName = dict[@"supplierName"];
            
            entity.dataAryTwo = [NSMutableArray new];
            
            NSArray *list = dict[@"list"];
            for (NSDictionary *dict2 in list) {
                STWisdomEntity *entity2 = [STWisdomEntity new];
                
                entity2.memberID = dict2[@"id"];
                entity2.userid = dict2[@"userid"];
                entity2.psn = dict2[@"psn"];
                entity2.Goods_Package_ID = dict2[@"Goods_Package_ID"];
                entity2.PreChar = dict2[@"PreChar"];
                entity2.DrugsBase_Manufacturer = dict2[@"DrugsBase_Manufacturer"];
                entity2.DrugsBase_ProName = dict2[@"DrugsBase_ProName"];
                entity2.DrugsBase_DrugName = dict2[@"DrugsBase_DrugName"];
                entity2.DrugsBase_Formulation = dict2[@"DrugsBase_Formulation"];
                entity2.Goods_Unit = dict2[@"Goods_Unit"];
                entity2.DrugsBase_Specification = dict2[@"DrugsBase_Specification"];
                entity2.DrugsBase_ApprovalNumber = dict2[@"DrugsBase_ApprovalNumber"];
                entity2.stock = dict2[@"stock"];
                entity2.LastTime = dict2[@"LastTime"];
                entity2.LastTimeString = dict2[@"LastTimeString"];
                entity2.HistoryPrice = dict2[@"HistoryPrice"];
                entity2.SalesVolume = dict2[@"SalesVolume"];
                entity2.minPrice = dict2[@"minPrice"];
                entity2.maxPrice = dict2[@"maxPrice"];
                entity2.priority = dict2[@"priority"];
                entity2.buyNumList = dict2[@"buyNumList"];
                //将array数组转换为string字符串
                NSString *tempString = [entity2.buyNumList componentsJoinedByString:@","];//分隔符逗号
                entity2.buyNumListStr = tempString;
                entity2.Barcode = dict2[@"Barcode"];
                entity2.buyCount = dict2[@"buyCount"];
                entity2.store_Id = dict2[@"store_Id"];
                entity2.store_Name = dict2[@"store_Name"];
                entity2.minBuy = dict2[@"minBuy"];
                entity2.sxrq = dict2[@"sxrq"];
                entity2.pid = dict2[@"pid"];
                entity2.Price = dict2[@"Price"];
                entity2.sellType = dict2[@"sellType"];
                entity2.Product_Pcs = dict2[@"Product_Pcs"];
                entity2.Product_Pcs_Small = dict2[@"Product_Pcs_Small"];
                entity2.myStock = dict2[@"myStock"];
                entity2.isSelect = dict2[@"isSelect"];
                entity2.YesterdayNoStock = dict2[@"YesterdayNoStock"];
                
                [entity.dataAryTwo addObject:entity2];
            }
            [dataResult addObject:entity];
        }
        
        finshed(dataResult,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}


+(void)getProductListBarCodeUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult, STProductListEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        STProductListEntity *mode = [STProductListEntity new];
        mode.pageIndex = [responseObj[@"pageIndex"]integerValue];
        mode.recordCount = [responseObj[@"recordCount"]integerValue];
        mode.pageCount = [responseObj[@"PageCount"]integerValue];
        
        for (NSDictionary *dict in responseObj[@"list"]) {
            STProductListEntity *entity = [STProductListEntity new];
            entity.productId = dict[@"id"];
            entity.goods_Package_ID = dict[@"Goods_Package_ID"];
            entity.drugsBase_DrugName = dict[@"DrugsBase_DrugName"];
            entity.drugsBase_SimpeCode = dict[@"DrugsBase_SimpeCode"];
            
            if ([dict[@"DrugsBase_ProName"] isKindOfClass:[NSNull class]]) {
                
                entity.drugsBase_ProName = @"";
            }else {
                entity.drugsBase_ProName = dict[@"DrugsBase_ProName"];
            }
            
            
            entity.drugsBase_Manufacturer = dict[@"DrugsBase_Manufacturer"];
            entity.goods_Pcs = dict[@"Goods_Pcs"];
            entity.goods_Unit = dict[@"Goods_Unit"];
            entity.originalImageUrl = dict[@"OriginalImageUrl"];
            entity.imageUrl = dict[@"ImageUrl"];
            entity.surfaceUrl = dict[@"SurfaceUrl"];
            entity.drugsBase_Specification = dict[@"DrugsBase_Specification"];
            entity.marketPrice = dict[@"MarketPrice"];
            entity.minShopPrice = dict[@"MinShopPrice"];
            entity.maxShopPrice = dict[@"MaxShopPrice"];
            entity.maxGrossMargin = dict[@"MaxGrossMargin"];
            entity.storeId = dict[@"StoreId"];
            entity.sellerCount = dict[@"SellerCount"];
            entity.saleCount = dict[@"SaleCount"];
            entity.repeatBuyCount = dict[@"RepeatBuyCount"];
            entity.favoriteCount = dict[@"FavoriteCount"];
            entity.reviewCount = dict[@"ReviewCount"];
            entity.isHighMargin = dict[@"IsHighMargin"];
            entity.tag_PharmAttribute_fullPath = dict[@"Tag_PharmAttribute_fullPath"];
            if ([dict[@"Tag_PharmAttribute_id"] isKindOfClass:[NSNull class]]) {
                
                entity.tag_PharmAttribute_id = @"";
            }else {
                entity.tag_PharmAttribute_id = dict[@"Tag_PharmAttribute_id"];
            }
            
            entity.priceRange = dict[@"PriceRange"];
            entity.grossMarginRange = dict[@"GrossMarginRange"];
            entity.pid = dict[@"Pid"];
            entity.addr_Ids_Seller = dict[@"Addr_Ids_Seller"];
            entity.addr_control = dict[@"Addr_control"];
            entity.type_control = dict[@"Type_control"];
            entity.addPriceBuyTimeList = dict[@"AddPriceBuyTimeList"];
            entity.salesAll = dict[@"SalesAll"];
            entity.isExemptPostage = dict[@"isExemptPostage"];
            entity.promotionTypes = dict[@"PromotionTypes"];
            entity.visitcount = dict[@"visitcount"];
            entity.salecount30 = dict[@"salecount30"];
            entity.salecounthalfyear = dict[@"salecounthalfyear"];
            entity.salecountyear = dict[@"salecountyear"];
            entity.IsStandard = dict[@"IsStandard"];
            entity.ImageUrl_NoStandard_Top1 = dict[@"ImageUrl_NoStandard_Top1"];
            
            if ([dict[@"PricePromotionsTypes"] isKindOfClass:[NSNull class]]) {
                
                entity.PricePromotionsTypes = @"";
            }else {
                entity.PricePromotionsTypes = dict[@"PricePromotionsTypes"];
            }
            
            entity.mAddr_control = dict[@"Addr_control"];
            
            [dataResult addObject:entity];
        }
        finshed(dataResult,mode,nil);
        
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}


+(void)getAddPurchaseSearchProductUrl:(NSString *)url params:(id)params  finshed:(void(^)(NSString *mesg,NSString *code, NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSString *mesg = responseObj[@"mesg"];
        NSString *code = responseObj[@"code"];
        if ([responseObj[@"code"] intValue] == 200) {
            finshed(mesg,code,nil);
        }else{
            finshed(mesg,code,nil);
        }
        
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}

+(void)getpurchaseHome_TabManualShareUrl:(NSString *)url params:(id)params  finshed:(void(^)(NSDictionary *data, NSError *error))finshed{
    [self postRequest:url params:params success:^(id responseObj) {
        NSDictionary *dict = @{@"title":responseObj[@"title"],@"url":responseObj[@"url"],@"descr":responseObj[@"info"]};
        finshed(dict,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getBatchSubmitForPurchaseHomeUrl:(NSString *)url params:(id)params  finshed:(void(^)(NSString *code,NSError *error))finshed{
    [self postRequest:url params:params success:^(id responseObj) {
        finshed(responseObj[@"code"],nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getStoreCateListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,STStoreClassEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSMutableArray *dataResult = [NSMutableArray new];
        
        for (NSDictionary *dict in responseObj) {
            STStoreClassEntity *entity = [STStoreClassEntity new];
            entity.CateCountAll = dict[@"CateCountAll"];
            entity.CateId = dict[@"CateId"];
            entity.CateName = dict[@"CateName"];
            entity.CountAll = dict[@"CountAll"];
            entity.ImagesUrl = dict[@"ImagesUrl"];
            entity.CateList = dict[@"CateList"];
            
            [dataResult addObject:entity];
        }
        
        finshed(dataResult,nil,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,error);
    }];
}

+(void)setChangeSelectUrl:(NSString *)url params:(NSDictionary *)params finshed:(void(^)(BOOL isYes))finshed{
    [self postRequest:url params:params success:^(id responseObj) {
        NSString *codeStr = responseObj[@"code"];
        if (codeStr.intValue == 200) {
            finshed(YES);
        }else{
            finshed(NO);
        }
    } failure:^(NSError *error) {
        finshed(NO);
    }];
}

+(void)getChangePurchaseCountForPsnUrl:(NSString *)url params:(id)params  finshed:(void(^)(BOOL isYes))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        NSString *codeStr = responseObj[@"code"];
        if (codeStr.intValue == 200) {
            finshed(YES);
        }else{
            finshed(NO);
        }
    } failure:^(NSError *error) {
        finshed(NO);
    }];
}

+(void)getShareOfSuccessUrl:(NSString *)url params:(NSDictionary *)params finshed:(void(^)(BOOL isSuccess))finshed{
    [self postRequest:url params:params success:^(id responseObj) {
        NSString *codeStr = responseObj[@"code"];
        if (codeStr.intValue == 200) {
            finshed(YES);
        }else{
            finshed(NO);
        }
        
    } failure:^(NSError *error) {
        finshed(NO);
    }];
}



+(void)getOrderNoPayDetialUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,id data,STPaymentDetailsEntity *entity,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        
        NSMutableArray *dataResult = [NSMutableArray new];
        
        NSMutableArray *dataAry = [NSMutableArray new];
        
        STPaymentDetailsEntity *mode = [STPaymentDetailsEntity new];
        
        mode.orderamount = responseObj[@"orderamount"];
        mode.shipfee = responseObj[@"shipfee"];
        mode.paybalancemoney = responseObj[@"paybalancemoney"];
        mode.couponmoney = responseObj[@"couponmoney"];
        mode.buyerremark = responseObj[@"buyerremark"];
        mode.paysn = responseObj[@"paysn"];
        mode.addtime = responseObj[@"addtime"];
        mode.master_osn = responseObj[@"master_osn"];
        mode.consignee = responseObj[@"consignee"];
        mode.mobile = responseObj[@"mobile"];
        mode.address = responseObj[@"address"];
        
        NSArray *orderlist = responseObj[@"orderlist"];
        
        for (NSDictionary *orderDict in orderlist) {
            
            STPaymentDetailsEntity *mode2 = [STPaymentDetailsEntity new];
            
            mode2.OSN = orderDict[@"OSN"];
            
            mode2.storename = orderDict[@"storename"];
            
            mode2.StoreId = orderDict[@"storeid"];
            
            NSMutableArray *orderproductAry = [NSMutableArray new];
            
            NSArray *orderproductlist = orderDict[@"orderproductlist"];
            
            for (NSDictionary *orderproductDict in orderproductlist) {
                
                STPaymentDetailsEntity *mode3 = [STPaymentDetailsEntity new];
                
                mode3.addtime = orderproductDict[@"AddTime"];
                mode3.BuyCount = orderproductDict[@"BuyCount"];
                mode3.BagCount = orderproductDict[@"BagCount"];
                mode3.BuyCount_s = orderproductDict[@"BuyCount_s"];
                mode3.CateId = orderproductDict[@"CateId"];
                mode3.CostPrice = orderproductDict[@"CostPrice"];
                mode3.CouponTypeId = orderproductDict[@"CouponTypeId"];
                mode3.Created = orderproductDict[@"Created"];
                mode3.DiscountPrice = orderproductDict[@"DiscountPrice"];
                mode3.DrugsBase_ApprovalNumber = orderproductDict[@"DrugsBase_ApprovalNumber"];
                mode3.DrugsBase_Manufacturer = orderproductDict[@"DrugsBase_Manufacturer"];
                
                mode3.DrugsBase_ProName = orderproductDict[@"DrugsBase_ProName"];
                mode3.DrugsBase_Specification = orderproductDict[@"DrugsBase_Specification"];
                mode3.Experience = orderproductDict[@"Experience"];
                mode3.ExtCode1 = orderproductDict[@"ExtCode1"];
                mode3.ExtCode2 = orderproductDict[@"ExtCode2"];
                mode3.ExtCode3 = orderproductDict[@"ExtCode3"];
                mode3.ExtCode5 = orderproductDict[@"ExtCode5"];
                mode3.ExtCode4 = orderproductDict[@"ExtCode4"];
                mode3.Goods_Package_ID = orderproductDict[@"Goods_Package_ID"];
                mode3.Goods_Pcs = orderproductDict[@"Goods_Pcs"];
                
                
                mode3.Goods_Pcs_Small = orderproductDict[@"Goods_Pcs_Small"];
                mode3.Goods_Unit = orderproductDict[@"Goods_Unit"];
                mode3.Helpful = orderproductDict[@"Helpful"];
                mode3.ImageList = orderproductDict[@"ImageList"];
                mode3.IsReview = orderproductDict[@"IsReview"];
                mode3.IsSelect = orderproductDict[@"IsSelect"];
                mode3.MarketPrice = orderproductDict[@"MarketPrice"];
                mode3.MinBuyNum = orderproductDict[@"MinBuyNum"];
                mode3.Name = orderproductDict[@"Name"];
                mode3.Oid = orderproductDict[@"Oid"];
                
                mode3.PSN = orderproductDict[@"PSN"];
                mode3.PayCredits = orderproductDict[@"PayCredits"];
                mode3.Pid = orderproductDict[@"Pid"];
                mode3.ProductStCommentID = orderproductDict[@"ProductStCommentID"];
                mode3.Product_Pcs = orderproductDict[@"Product_Pcs"];
                mode3.Product_Pcs_Small = orderproductDict[@"Product_Pcs_Small"];
                mode3.RealCount = orderproductDict[@"RealCount"];
                mode3.RecordId = orderproductDict[@"RecordId"];
                mode3.SellType = orderproductDict[@"SellType"];
                mode3.SendCount = orderproductDict[@"SendCount"];
                
                mode3.ShopPrice = orderproductDict[@"ShopPrice"];
                mode3.ShowImg = orderproductDict[@"ShowImg"];
                mode3.Sid = orderproductDict[@"Sid"];
                mode3.SmallImageUrl = orderproductDict[@"SmallImageUrl"];
                mode3.Stcommentstate = orderproductDict[@"Stcommentstate"];
                mode3.StoreCid = orderproductDict[@"StoreCid"];
                mode3.StoreId = orderproductDict[@"StoreId"];
                mode3.StoreSTid = orderproductDict[@"StoreSTid"];
                mode3.Type = orderproductDict[@"Type"];
                mode3.Uid = orderproductDict[@"Uid"];
                
                mode3.Weight = orderproductDict[@"Weight"];
                mode3.addpricebuycoast = orderproductDict[@"addpricebuycoast"];
                mode3.addpricebuyid = orderproductDict[@"addpricebuyid"];
                mode3.addpricebuymodel = orderproductDict[@"addpricebuymodel"];
                mode3.addpricebuynum = orderproductDict[@"addpricebuynum"];
                mode3.addpricebuypernum = orderproductDict[@"addpricebuypernum"];
                mode3.addproduct = orderproductDict[@"addproduct"];
                mode3.channelType = orderproductDict[@"channelType"];
                mode3.ishight = orderproductDict[@"ishight"];
                mode3.iskong = orderproductDict[@"iskong"];
                
                
                mode3.notHelpful = orderproductDict[@"notHelpful"];
                mode3.orderproductstate = orderproductDict[@"orderproductstate"];
                mode3.pmid = orderproductDict[@"pmid"];
                mode3.specialpricemodel = orderproductDict[@"specialpricemodel"];
                mode3.stock = orderproductDict[@"stock"];
                
                [orderproductAry addObject:mode3];
                
                
                if ([mode3.addpricebuyid intValue] > 0) {
                    
                    STPaymentDetailsEntity *mode4 =[STPaymentDetailsEntity new];
                    
                    mode4.secondDrugsBase_DrugName = mode3.addpricebuymodel[@"secondDrugsBase_DrugName"];
                    mode4.secondDrugsBase_Manufacturer = mode3.addpricebuymodel[@"secondDrugsBase_Manufacturer"];
                    mode4.secondDrugsBase_Specification = mode3.addpricebuymodel[@"secondDrugsBase_Specification"];
                    mode4.addPrice = mode3.addpricebuymodel[@"addPrice"];
                    mode4.secondGoods_Unit = mode3.addpricebuymodel[@"secondGoods_Unit"];
                    mode4.secondProudctNum = mode3.addpricebuymodel[@"secondProudctNum"];
                    mode4.secondimage = mode3.addpricebuymodel[@"secondimage"];
                    mode4.IsAddPriceBuy = @"2";
                    
                    [orderproductAry addObject:mode4];
                    
                }
            }
            
            [dataResult addObject:mode2];
            
            [dataAry addObject:orderproductAry];
        }
        
        finshed(dataResult,dataAry,mode,nil);
    } failure:^(NSError *error) {
        finshed(nil,nil,nil,error);
    }];
}

+(void)getAppConfirmOrderUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,id data,STPaymentDetailsEntity *entity,NSError *error))finshed{
    [self postRequest:url params:params success:^(id responseObj) {
        
        NSString *success = responseObj[@"success"];
        
        if (success.intValue == 1) {
            
            NSMutableArray *dataResult = [NSMutableArray new];
            
            STPaymentDetailsEntity *mode = [STPaymentDetailsEntity new];
            
            NSMutableArray *dataAry = [NSMutableArray new];
            
            NSDictionary *data = responseObj[@"data"];
            
            
            mode.CouponStoreCount = data[@"CouponStoreCount"];
            mode.AllProductAmount = data[@"AllProductAmount"];
            mode.MaxUseBalance = data[@"MaxUseBalance"];
            mode.AllShipFee = data[@"AllShipFee"];
            mode.AllOrderAmount = data[@"AllOrderAmount"];
            mode.PayFee = data[@"PayFee"];
            mode.CouponMallCount = data[@"CouponMallCount"];
            mode.SelectedCartItemKeyList = data[@"SelectedCartItemKeyList"];
            mode.AllFullCut = data[@"AllFullCut"];
            mode.UserBalance = data[@"UserBalance"];
            mode.CanUseCouponCount = data[@"CanUseCouponCount"];
            
            
            mode.mobile = data[@"DefaultShipAddressInfo"][@"Mobile"];
            mode.CityName = data[@"DefaultShipAddressInfo"][@"CityName"];
            mode.SAId = data[@"DefaultShipAddressInfo"][@"SAId"];
            mode.ProvinceName = data[@"DefaultShipAddressInfo"][@"ProvinceName"];
            mode.CountyId = data[@"DefaultShipAddressInfo"][@"CountyId"];
            mode.consignee = data[@"DefaultShipAddressInfo"][@"Consignee"];
            mode.CountyName = data[@"DefaultShipAddressInfo"][@"CountyName"];
            mode.DefaultExpress = data[@"DefaultShipAddressInfo"][@"DefaultExpress"];
            mode.address = data[@"DefaultShipAddressInfo"][@"Address"];
            mode.CityId = data[@"DefaultShipAddressInfo"][@"CityId"];
            mode.Uid = data[@"DefaultShipAddressInfo"][@"Uid"];
            mode.ProvinceId = data[@"DefaultShipAddressInfo"][@"ProvinceId"];
            
            
            
            NSArray *StoreOrderListLous = responseObj[@"data"][@"StoreOrderListLous"];
            if (StoreOrderListLous) {
                for (NSDictionary *StoreOrderDict in StoreOrderListLous) {
                    
                    STPaymentDetailsEntity *mode2 = [STPaymentDetailsEntity new];
                    
                    mode2.StoreId = StoreOrderDict[@"StoreId"];
                    mode2.TotalCount = StoreOrderDict[@"TotalCount"];
                    mode2.FullCut = StoreOrderDict[@"FullCut"];
                    mode2.Name = StoreOrderDict[@"Name"];
                    mode2.shipfee = StoreOrderDict[@"ShipFee"];
                    mode2.ProductAmount = StoreOrderDict[@"ProductAmount"];
                    mode2.storename = StoreOrderDict[@"StoreName"];
                    mode2.islous = StoreOrderDict[@"islous"];
                    //                mode2.ProductCount = StoreOrderDict[@"ProductCount"];
                    
                    
                    NSMutableArray *orderproductAry = [NSMutableArray new];
                    NSArray *OrderProductList = StoreOrderDict[@"OrderProductList"];
                    
                    for (NSDictionary *OrderProductDict in OrderProductList) {
                        
                        STPaymentDetailsEntity *mode3 = [STPaymentDetailsEntity new];
                        
                        mode3.PName = OrderProductDict[@"PName"];
                        mode3.BuyCount = OrderProductDict[@"BuyCount"];
                        mode3.DrugsBase_Specification = OrderProductDict[@"DrugsBase_Specification"];
                        mode3.IsSpePrice = OrderProductDict[@"IsSpePrice"];
                        mode3.SmallImageUrl = OrderProductDict[@"SmallImageUrl"];
                        mode3.DrugsBase_Manufacturer = OrderProductDict[@"DrugsBase_Manufacturer"];
                        mode3.Pid = OrderProductDict[@"Pid"];
                        mode3.AddPriceProInfo = OrderProductDict[@"AddPriceProInfo"];
                        mode3.DiscountPrice = OrderProductDict[@"DiscountPrice"];
                        mode3.IsAddPriceBuy = OrderProductDict[@"IsAddPriceBuy"];
                        mode3.ShopPrice = OrderProductDict[@"ShopPrice"];
                        mode3.SpePriceProInfo = OrderProductDict[@"SpePriceProInfo"];
                        
                        [orderproductAry addObject:mode3];
                        
                        if ([mode3.IsAddPriceBuy intValue] == 1) {
                            
                            STPaymentDetailsEntity *mode4 =[STPaymentDetailsEntity new];
                            
                            mode4.firstpid = mode3.AddPriceProInfo[@"firstpid"];
                            mode4.secondpid = mode3.AddPriceProInfo[@"secondpid"];
                            mode4.Name = mode3.AddPriceProInfo[@"name"];
                            mode4.addPrice = mode3.AddPriceProInfo[@"addPrice"];
                            mode4.addPriceType = mode3.AddPriceProInfo[@"addPriceType"];
                            mode4.firstProudctStartNum = mode3.AddPriceProInfo[@"firstProudctStartNum"];
                            mode4.firstProudctPerNum = mode3.AddPriceProInfo[@"firstProudctPerNum"];
                            mode4.secondProudctNum = mode3.AddPriceProInfo[@"secondProudctNum"];
                            mode4.pmid = mode3.AddPriceProInfo[@"pmid"];
                            mode4.secondimage = mode3.AddPriceProInfo[@"secondimage"];
                            mode4.SmallImageUrl = mode3.AddPriceProInfo[@"secondimage"];
                            mode4.secondDrugsBase_DrugName = mode3.AddPriceProInfo[@"secondDrugsBase_DrugName"];
                            mode4.DrugsBase_ProName = mode3.AddPriceProInfo[@"secondDrugsBase_ProName"];
                            mode4.secondisHighMargin = mode3.AddPriceProInfo[@"secondisHighMargin"];
                            mode4.secondDrugsBase_Manufacturer = mode3.AddPriceProInfo[@"secondDrugsBase_Manufacturer"];
                            mode4.secondDrugsBase_Specification = mode3.AddPriceProInfo[@"secondDrugsBase_Specification"];
                            mode4.secondGoods_Unit = mode3.AddPriceProInfo[@"secondGoods_Unit"];
                            mode4.secondshopprice = mode3.AddPriceProInfo[@"secondshopprice"];
                            mode4.secondsxrq = mode3.AddPriceProInfo[@"secondsxrq"];
                            mode4.SecondIsJxq = mode3.AddPriceProInfo[@"SecondIsJxq"];
                            mode4.IsAddPriceBuy = @"2";
                            
                            if (mode4.addPriceType.integerValue == 0) {
                                
                                mode4.SecondNum = mode4.secondProudctNum;
                                
                            }else{
                                
                                mode4.SecondNum = [NSString stringWithFormat:@"%zi",mode3.BuyCount.integerValue / mode4.firstProudctPerNum.integerValue * mode4.secondProudctNum.integerValue];
                                
                            }
                            
                            [orderproductAry addObject:mode4];
                        }
                    }
                    
                    [dataResult addObject:mode2];
                    [dataAry addObject:orderproductAry];
                }
            }

            
            NSArray *StoreOrderList = responseObj[@"data"][@"StoreOrderList"];
            for (NSDictionary *StoreOrderDict in StoreOrderList) {
                
                STPaymentDetailsEntity *mode2 = [STPaymentDetailsEntity new];
                
                mode2.StoreId = StoreOrderDict[@"StoreId"];
                mode2.TotalCount = StoreOrderDict[@"TotalCount"];
                mode2.FullCut = StoreOrderDict[@"FullCut"];
                mode2.Name = StoreOrderDict[@"Name"];
                mode2.shipfee = StoreOrderDict[@"ShipFee"];
                mode2.ProductAmount = StoreOrderDict[@"ProductAmount"];
                mode2.storename = StoreOrderDict[@"StoreName"];
                mode2.islous = StoreOrderDict[@"islous"];
                
                
                NSMutableArray *orderproductAry = [NSMutableArray new];
                NSArray *OrderProductList = StoreOrderDict[@"OrderProductList"];
                
                for (NSDictionary *OrderProductDict in OrderProductList) {
                    
                    STPaymentDetailsEntity *mode3 = [STPaymentDetailsEntity new];
                    
                    mode3.PName = OrderProductDict[@"PName"];
                    mode3.BuyCount = OrderProductDict[@"BuyCount"];
                    mode3.DrugsBase_Specification = OrderProductDict[@"DrugsBase_Specification"];
                    mode3.IsSpePrice = OrderProductDict[@"IsSpePrice"];
                    mode3.SmallImageUrl = OrderProductDict[@"SmallImageUrl"];
                    mode3.DrugsBase_Manufacturer = OrderProductDict[@"DrugsBase_Manufacturer"];
                    mode3.Pid = OrderProductDict[@"Pid"];
                    mode3.AddPriceProInfo = OrderProductDict[@"AddPriceProInfo"];
                    mode3.DiscountPrice = OrderProductDict[@"DiscountPrice"];
                    mode3.IsAddPriceBuy = OrderProductDict[@"IsAddPriceBuy"];
                    mode3.ShopPrice = OrderProductDict[@"ShopPrice"];
                    mode3.SpePriceProInfo = OrderProductDict[@"SpePriceProInfo"];
                    
                    [orderproductAry addObject:mode3];
                    
                    if ([mode3.IsAddPriceBuy intValue] == 1) {
                        
                        STPaymentDetailsEntity *mode4 =[STPaymentDetailsEntity new];
                        
                        mode4.firstpid = mode3.AddPriceProInfo[@"firstpid"];
                        mode4.secondpid = mode3.AddPriceProInfo[@"secondpid"];
                        mode4.Name = mode3.AddPriceProInfo[@"name"];
                        mode4.addPrice = mode3.AddPriceProInfo[@"addPrice"];
                        mode4.addPriceType = mode3.AddPriceProInfo[@"addPriceType"];
                        mode4.firstProudctStartNum = mode3.AddPriceProInfo[@"firstProudctStartNum"];
                        mode4.firstProudctPerNum = mode3.AddPriceProInfo[@"firstProudctPerNum"];
                        mode4.secondProudctNum = mode3.AddPriceProInfo[@"secondProudctNum"];
                        mode4.pmid = mode3.AddPriceProInfo[@"pmid"];
                        mode4.secondimage = mode3.AddPriceProInfo[@"secondimage"];
                        mode4.SmallImageUrl = mode3.AddPriceProInfo[@"secondimage"];
                        mode4.secondDrugsBase_DrugName = mode3.AddPriceProInfo[@"secondDrugsBase_DrugName"];
                        mode4.DrugsBase_ProName = mode3.AddPriceProInfo[@"secondDrugsBase_ProName"];
                        mode4.secondisHighMargin = mode3.AddPriceProInfo[@"secondisHighMargin"];
                        mode4.secondDrugsBase_Manufacturer = mode3.AddPriceProInfo[@"secondDrugsBase_Manufacturer"];
                        mode4.secondDrugsBase_Specification = mode3.AddPriceProInfo[@"secondDrugsBase_Specification"];
                        mode4.secondGoods_Unit = mode3.AddPriceProInfo[@"secondGoods_Unit"];
                        mode4.secondshopprice = mode3.AddPriceProInfo[@"secondshopprice"];
                        mode4.secondsxrq = mode3.AddPriceProInfo[@"secondsxrq"];
                        mode4.SecondIsJxq = mode3.AddPriceProInfo[@"SecondIsJxq"];
                        mode4.IsAddPriceBuy = @"2";
                        
                        if (mode4.addPriceType.integerValue == 0) {
                            
                            mode4.SecondNum = mode4.secondProudctNum;
                            
                        }else{
                            
                            mode4.SecondNum = [NSString stringWithFormat:@"%zi",mode3.BuyCount.integerValue / mode4.firstProudctPerNum.integerValue * mode4.secondProudctNum.integerValue];
                            
                        }
                        
                        [orderproductAry addObject:mode4];
                    }
                }
                
                [dataResult addObject:mode2];
                [dataAry addObject:orderproductAry];
            }
            
            finshed(dataResult,dataAry,mode,nil);
        }else{
            
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
            
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        finshed(nil,nil,nil,error);
    }];
}

+(void)getAppSubmitOrderUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,id data,STPaymentDetailsEntity *entity,NSError *error))finshed{
    [self postRequest:url params:params success:^(id responseObj) {
        
        finshed(responseObj,nil,nil,nil);
        
        
    } failure:^(NSError *error) {
        finshed(nil,nil,nil,error);
    }];
}

+(void)getAppwebchatUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        
        finshed(nil,nil);
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getAppPayUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        
        NSString *success = responseObj[@"success"];
        
        if (success.intValue == 1) {
            
            NSDictionary *dataDict = responseObj[@"data"];
            
            finshed(dataDict,nil);
            
        }else{
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
        }
        
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        finshed(nil,error);
    }];
}

+(void)getSwitchStoreUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    
    [self getRequest:url params:params success:^(id responseObj) {
        
        if ([responseObj[@"success"] intValue] != 1) {
            
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }else{
            NSMutableArray *dataResult = [NSMutableArray new];
            
            NSArray *list = responseObj[@"data"][@"list"];
            
            for (NSDictionary *dict  in list) {
                
                STSwitchStoreEneity *entity = [STSwitchStoreEneity new];
                
                entity.islous = dict[@"islous"];
                entity.storeid = dict[@"storeid"];
                entity.storeName = dict[@"storeName"];
                entity.enterpriseName = dict[@"enterpriseName"];
                entity.selected = dict[@"Selected"];
                entity.sxrq = dict[@"sxrq"];
                entity.price = dict[@"price"];
                entity.lowestdeliveryAmount = dict[@"lowestdeliveryAmount"];
                entity.lowestFreeShippingAmount = dict[@"lowestFreeShippingAmount"];
                entity.tax_policy = dict[@"tax_policy"];
                entity.buyCount = dict[@"buyCount"];
                entity.surplusmoney = dict[@"surplusmoney"];
                entity.info = dict[@"info"];
                entity.Pid = dict[@"Pid"];
                entity.Goods_Package_ID = dict[@"Goods_Package_ID"];
                entity.IsJxq = dict[@"IsJxq"];
                entity.MinBuyNum = dict[@"MinBuyNum"];
                entity.Stock = dict[@"Stock"];
                entity.speprice = dict[@"speprice"];
                entity.limitnumber = dict[@"limitnumber"];
                entity.PromotionTypes = dict[@"PromotionTypes"];
                entity.limittype = dict[@"limittype"];
                entity.DrugsBase_Specification = dict[@"DrugsBase_Specification"];
                entity.DrugsBase_DrugName = dict[@"DrugsBase_DrugName"];
                entity.Goods_Unit = dict[@"Goods_Unit"];
                entity.sellType = dict[@"sellType"];
                entity.Product_Pcs_Small = dict[@"Product_Pcs_Small"];
                entity.psn = dict[@"psn"];
                entity.Product_Pcs = dict[@"Product_Pcs"];
                
                [dataResult addObject:entity];
            }
            
            if (dataResult.count != 0) {
                
                finshed(dataResult,nil);
            }else{
                [ZHProgressHUD showInfoWithText:@"没有数据"];
                [[UIApplication sharedApplication].keyWindow hideToastActivity];
            }
        }
    } failure:^(NSError *error) {
        [ZHProgressHUD showInfoWithText:@"请求失败"];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

+(void)getEliminateListUrl:(NSString *)url params:(id)params  finshed:(void(^)(id dataResult,NSError *error))finshed{
    [self postRequest:url params:params success:^(id responseObj) {
        
        if ([responseObj[@"success"] integerValue] != 1) {
            
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
            
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            
        }else{
            
            NSMutableArray *dataResult = [NSMutableArray new];
            
            NSArray *data = responseObj[@"data"];
            
            for (NSDictionary *dict in data) {
                
                STWisdomEntity *entity = [STWisdomEntity new];
                
                entity.Barcode = dict[@"Barcode"];
                entity.DrugsBase_ApprovalNumber = dict[@"DrugsBase_ApprovalNumber"];
                entity.DrugsBase_DrugName = dict[@"DrugsBase_DrugName"];
                entity.DrugsBase_Manufacturer = dict[@"DrugsBase_Manufacturer"];
                entity.DrugsBase_ProName = dict[@"DrugsBase_ProName"];
                entity.DrugsBase_Specification = dict[@"DrugsBase_Specification"];
                entity.Goods_Package_ID = dict[@"Goods_Package_ID"];
                entity.Goods_Unit = dict[@"Goods_Unit"];
                entity.LastTime = dict[@"LastTime"];
                entity.SalesVolume = dict[@"SalesVolume"];
                entity.stock = dict[@"Stock"];
                entity.minPrice = dict[@"minPrice"];
                entity.maxPrice = dict[@"maxPrice"];
                entity.psn = dict[@"psn"];
                entity.HistoryPrice = dict[@"HistoryPrice"];
                
                [dataResult addObject:entity];
                
            }
            finshed(dataResult,nil);
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }
    } failure:^(NSError *error) {
        finshed(nil,error);
    }];
}

+(void)getMessageBoxInfoUrl:(NSString *)url params:(id)params finshed:(void(^)(NSString *massageNum))finshed{
    
    [self postRequest:url params:params success:^(id responseObj) {
        
        NSString *success = responseObj[@"success"];
        
        if (success.intValue == 1) {
            
            NSString *num = responseObj[@"data"];
            finshed(num);
        }else{
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
            finshed(nil);
        }
    } failure:^(NSError *error) {
        finshed(nil);
    }];
}

+(void)getPurchaseCartSearchUrl:(NSString *)url params:(id)params finshed:(void(^)(id wisdomDataResult,id artificialDataResult,NSError *error))finshed{
    
    [self postRequest:url params:params success:^(id responseObj) {
        NSString *success = responseObj[@"success"];
        if (success.intValue == 1) {
            
            NSArray *list = responseObj[@"data"][@"list"];
            
#pragma mark - 智慧采购
            NSDictionary *wisdomDict = list[0];
            
            NSArray *wisdomAry = wisdomDict[@"li"];
            
               NSMutableArray *wisdomResult = [NSMutableArray new];
            
            for (NSDictionary *wisdomDict2 in wisdomAry) {
                
                STShopCartSeachEntity *entity = [STShopCartSeachEntity new];
                
                entity.memberID = wisdomDict2[@"id"];
                entity.userid = wisdomDict2[@"userid"];
                entity.psn = wisdomDict2[@"psn"];
                entity.Goods_Package_ID = wisdomDict2[@"Goods_Package_ID"];
                entity.PreChar = wisdomDict2[@"PreChar"];
                entity.DrugsBase_Manufacturer = wisdomDict2[@"DrugsBase_Manufacturer"];
                entity.DrugsBase_ProName = wisdomDict2[@"DrugsBase_ProName"];
                entity.DrugsBase_DrugName = wisdomDict2[@"DrugsBase_DrugName"];
                entity.DrugsBase_Formulation = wisdomDict2[@"DrugsBase_Formulation"];
                entity.Goods_Unit = wisdomDict2[@"Goods_Unit"];
                entity.DrugsBase_Specification = wisdomDict2[@"DrugsBase_Specification"];
                entity.DrugsBase_ApprovalNumber = wisdomDict2[@"DrugsBase_ApprovalNumber"];
                entity.stock = wisdomDict2[@"stock"];
                entity.LastTime = wisdomDict2[@"LastTime"];
                entity.LastTimeString = wisdomDict2[@"LastTimeString"];
                entity.HistoryPrice = wisdomDict2[@"HistoryPrice"];
                entity.SalesVolume = wisdomDict2[@"SalesVolume"];
                entity.minPrice = wisdomDict2[@"minPrice"];
                entity.maxPrice = wisdomDict2[@"maxPrice"];
                entity.priority = wisdomDict2[@"priority"];
                entity.buyNumList = wisdomDict2[@"buyNumList"];
                entity.Barcode = wisdomDict2[@"Barcode"];
                entity.buyCount = wisdomDict2[@"buyCount"];
                entity.supplierName = wisdomDict2[@"supplierName"];
                entity.myStock = wisdomDict2[@"myStock"];
                entity.IsStandard = wisdomDict2[@"IsStandard"];
                entity.store_Id = wisdomDict2[@"store_Id"];
                entity.store_Name = wisdomDict2[@"store_Name"];
                entity.minBuy = wisdomDict2[@"minBuy"];
                entity.sxrq = wisdomDict2[@"sxrq"];
                entity.pid = wisdomDict2[@"pid"];
                entity.Price = wisdomDict2[@"Price"];
                entity.sellType = wisdomDict2[@"sellType"];
                entity.Product_Pcs = wisdomDict2[@"Product_Pcs"];
                entity.Product_Pcs_Small = wisdomDict2[@"Product_Pcs_Small"];
                entity.source = wisdomDict2[@"source"];
                entity.pmid = wisdomDict2[@"pmid"];
                entity.PricePromotionsTypes = wisdomDict2[@"PricePromotionsTypes"];
                entity.PromotionTypes = wisdomDict2[@"PromotionTypes"];
                entity.purchasetAddPricePromotionsList = wisdomDict2[@"purchasetAddPricePromotionsList"];
                entity.IsJxq = wisdomDict2[@"IsJxq"];
                entity.speprice = wisdomDict2[@"speprice"];
                entity.isSelect = wisdomDict2[@"isSelect"];
                entity.YesterdayNoStock = wisdomDict2[@"YesterdayNoStock"];
                entity.isSelectForCart = wisdomDict2[@"isSelectForCart"];
                entity.purchasetSpecialPricePromotions = wisdomDict2[@"purchasetSpecialPricePromotions"];
                
                
                [wisdomResult addObject:entity];
            }

            
#pragma mark - 人工采购
            NSDictionary *artificialDict = list[1];
            
            
            NSArray *artificialAry = artificialDict[@"li"];
            
           NSMutableArray *artificialResult = [NSMutableArray new];
            
            for (NSDictionary *artificialDict2 in artificialAry) {
                
                STShopCartSeachEntity *entity = [STShopCartSeachEntity new];
                
                entity.memberID = artificialDict2[@"id"];
                entity.userid = artificialDict2[@"userid"];
                entity.psn = artificialDict2[@"psn"];
                entity.Goods_Package_ID = artificialDict2[@"Goods_Package_ID"];
                entity.PreChar = artificialDict2[@"PreChar"];
                entity.DrugsBase_Manufacturer = artificialDict2[@"DrugsBase_Manufacturer"];
                entity.DrugsBase_ProName = artificialDict2[@"DrugsBase_ProName"];
                entity.DrugsBase_DrugName = artificialDict2[@"DrugsBase_DrugName"];
                entity.DrugsBase_Formulation = artificialDict2[@"DrugsBase_Formulation"];
                entity.Goods_Unit = artificialDict2[@"Goods_Unit"];
                entity.DrugsBase_Specification = artificialDict2[@"DrugsBase_Specification"];
                entity.DrugsBase_ApprovalNumber = artificialDict2[@"DrugsBase_ApprovalNumber"];
                entity.stock = artificialDict2[@"stock"];
                entity.LastTime = artificialDict2[@"LastTime"];
                entity.LastTimeString = artificialDict2[@"LastTimeString"];
                entity.HistoryPrice = artificialDict2[@"HistoryPrice"];
                entity.SalesVolume = artificialDict2[@"SalesVolume"];
                entity.minPrice = artificialDict2[@"minPrice"];
                entity.maxPrice = artificialDict2[@"maxPrice"];
                entity.priority = artificialDict2[@"priority"];
                entity.buyNumList = artificialDict2[@"buyNumList"];
                entity.Barcode = artificialDict2[@"Barcode"];
                entity.buyCount = artificialDict2[@"buyCount"];
                entity.supplierName = artificialDict2[@"supplierName"];
                entity.myStock = artificialDict2[@"myStock"];
                entity.IsStandard = artificialDict2[@"IsStandard"];
                entity.store_Id = artificialDict2[@"store_Id"];
                entity.store_Name = artificialDict2[@"store_Name"];
                entity.minBuy = artificialDict2[@"minBuy"];
                entity.sxrq = artificialDict2[@"sxrq"];
                entity.pid = artificialDict2[@"pid"];
                entity.Price = artificialDict2[@"Price"];
                entity.sellType = artificialDict2[@"sellType"];
                entity.Product_Pcs = artificialDict2[@"Product_Pcs"];
                entity.Product_Pcs_Small = artificialDict2[@"Product_Pcs_Small"];
                entity.source = artificialDict2[@"source"];
                entity.pmid = artificialDict2[@"pmid"];
                entity.PricePromotionsTypes = artificialDict2[@"PricePromotionsTypes"];
                entity.PromotionTypes = artificialDict2[@"PromotionTypes"];
                entity.purchasetAddPricePromotionsList = artificialDict2[@"purchasetAddPricePromotionsList"];
                entity.IsJxq = artificialDict2[@"IsJxq"];
                entity.speprice = artificialDict2[@"speprice"];
                entity.isSelect = artificialDict2[@"isSelect"];
                entity.YesterdayNoStock = artificialDict2[@"YesterdayNoStock"];
                entity.isSelectForCart = artificialDict2[@"isSelectForCart"];
                entity.purchasetSpecialPricePromotions = artificialDict2[@"purchasetSpecialPricePromotions"];
                
                [artificialResult addObject:entity];
            }
            
            finshed(wisdomResult,artificialResult,nil);
        }else{
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }
        
    } failure:^(NSError *error) {
        
        finshed(nil,nil,error);
        [ZHProgressHUD showInfoWithText:@"请求失败"];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

+(void)getPurchaseCartUrl:(NSString *)url params:(id)params  finshed:(void(^)(STShopCartSeachEntity *entity,NSString *mesg,NSString *code, NSError *error))finshed{
    [self getRequest:url params:params success:^(id responseObj) {
        
        NSString *mesg = responseObj[@"info"];
        
        NSString *code = responseObj[@"success"];
        
        if ([responseObj[@"success"] intValue] == 1) {
            
            
            STShopCartSeachEntity *entity = [STShopCartSeachEntity new];
            entity.Total_Amount = responseObj[@"data"][@"Surplusmoney"];
            entity.D_Amount = responseObj[@"data"][@"DifflowestdeliveryAmount"];
            entity.lowestFreeShippingAmount = responseObj[@"data"][@"lowestFreeShippingAmount"];
            
            finshed(entity,mesg,code,nil);
        }else{
            [ZHProgressHUD showInfoWithText:mesg];
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }
        
    } failure:^(NSError *error) {
        [ZHProgressHUD showInfoWithText:@"请求失败"];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

/**
 监控网络状态
 */
+ (BOOL)checkNetworkStatus {
    
    __block BOOL isNetworkUse = YES;
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusNotReachable){
            // 网络异常操作
            isNetworkUse = NO;
            KSMLog(@"网络异常,请检查网络是否可用！");
            return;
        }
    }];
    [reachabilityManager startMonitoring];
    return isNetworkUse;
}

@end

