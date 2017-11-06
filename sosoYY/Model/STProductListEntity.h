//
//  STProductListEntity.h
//  sosoYY
//
//  Created by soso-mac on 2016/11/29.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STProductListEntity : NSObject
@property(assign,nonatomic)NSInteger pageIndex;
@property(assign,nonatomic)NSInteger recordCount;
@property(assign,nonatomic)NSInteger pageCount;
@property(strong,nonatomic)NSString *productId;//产品id
@property(strong,nonatomic)NSString *goods_Package_ID;//药品id
@property(strong,nonatomic)NSString *drugsBase_DrugName;//药品通用名
@property(strong,nonatomic)NSString *drugsBase_SimpeCode;// 药品拼音简码
@property(strong,nonatomic)NSString *drugsBase_ProName;// 药品专用名
@property(strong,nonatomic)NSString *drugsBase_Manufacturer;// 生产厂家
@property(strong,nonatomic)NSString *goods_Pcs;// 件装数
@property(strong,nonatomic)NSString *goods_Unit;// 包装单位
@property(strong,nonatomic)NSString *originalImageUrl;// 包装盒图片URl
@property(strong,nonatomic)NSString *imageUrl;// 包装盒小图
@property(strong,nonatomic)NSString *surfaceUrl;// 封面图片
@property(strong,nonatomic)NSString *drugsBase_Specification;// 规格
@property(strong,nonatomic)NSString *marketPrice;// 药品下属最高毛利率商品的终端零售价
@property(strong,nonatomic)NSString *minShopPrice;// 药品下属商品最低的商城价格
@property(strong,nonatomic)NSString *maxShopPrice;// 药品下属商品最高的商城价格
@property(strong,nonatomic)NSString *maxGrossMargin;// 药品下属商品的最高毛利率
@property(strong,nonatomic)NSString *storeId;// 药品的所有经营店铺ID（逗号分隔
@property(strong,nonatomic)NSString *sellerCount;// 此药品卖家数
@property(strong,nonatomic)NSString *saleCount;// 药品总销量
@property(strong,nonatomic)NSString *repeatBuyCount;// 重复采购数
@property(strong,nonatomic)NSString *favoriteCount;// 药品收藏数
@property(strong,nonatomic)NSString *reviewCount;// 药品评论数
@property(strong,nonatomic)NSString *isHighMargin;// 是否是首推药品(高毛利)
@property(strong,nonatomic)NSString *tag_PharmAttribute_fullPath;// 适应症,产品分类
@property(strong,nonatomic)NSString *tag_PharmAttribute_id;// 季节标签ID（只包含97,98,99,100 中的一部分
@property(strong,nonatomic)NSString *priceRange;// 价格区间
@property(strong,nonatomic)NSString *grossMarginRange;// 毛利率范围
@property(strong,nonatomic)NSString *pid;// 商品pid
@property(strong,nonatomic)NSString *addr_Ids_Seller;// 是否显示该商品
@property(strong,nonatomic)NSString *addr_control;// 区域控销
@property(strong,nonatomic)NSString *type_control;// 类型控销
@property(strong,nonatomic)NSString *addPriceBuyTimeList;// 加价购活动时间列表
@property(strong,nonatomic)NSString *salesAll;/// 总销售额 所有卖家求和(销售数量*销售单价)
@property(strong,nonatomic)NSString *isExemptPostage;// 是否免邮(1免邮,0不免邮)
@property(strong,nonatomic)NSString *promotionTypes;// 促销类型(以,号前后分割促销类型) 1 加价购
@property(strong,nonatomic)NSString *visitcount;//访问次数
@property(strong,nonatomic)NSString *salecount30;
@property(strong,nonatomic)NSString *salecounthalfyear;
@property(strong,nonatomic)NSString *salecountyear;
@property(strong,nonatomic)NSString *IsStandard;//判断标品和非标品
@property(strong,nonatomic)NSString *ImageUrl_NoStandard_Top1;//非标品图片
@property(strong,nonatomic)NSString *PricePromotionsTypes;//特价
@property(strong,nonatomic)NSString *mAddr_control;

@end
