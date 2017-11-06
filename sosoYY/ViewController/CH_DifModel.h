//
//  CH_DifModel.h
//  sosoYY
//
//  Created by zhy on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CH_DifModel : NSObject<MJKeyValue>
/// 记录id
@property (nonatomic,strong)NSString *recordid;

//冲红原因
@property (nonatomic,strong)NSString *des;
//冲红数量
@property (nonatomic,strong)NSString *num;
/// 订单id
@property (nonatomic,strong)NSString *oid;

/// 用户id
@property (nonatomic,strong)NSString *uid;

/// sessionId
@property (nonatomic,strong)NSString *sid;

/// 商品id
@property (nonatomic,strong)NSString *pid;

/// 商品编码
@property (nonatomic,strong)NSString *psn;

 /// 分类id
@property (nonatomic,strong)NSString *cateid;

/// 品牌id
@property (nonatomic,strong)NSString *brandid;

/// 店铺id
@property (nonatomic,strong)NSString *storeid;

 /// 店铺分类id
@property (nonatomic,strong)NSString *storecid;

/// 店铺配送模板id
@property (nonatomic,strong)NSString *storestid;

/// 商品名称
@property (nonatomic,strong)NSString *name;

/// 商品展示图片
@property (nonatomic,strong)NSString *showimg;

/// 商品折扣价格
@property (nonatomic,strong)NSString *discountprice	;

/// 商品商城价格
@property (nonatomic,strong)NSString *shopprice;

// 商品成本价格
@property (nonatomic,strong)NSString *costprice;

/// 商品成本价格
@property (nonatomic,strong)NSString *marketprice;

 /// 商品重量
@property (nonatomic,strong)NSString *weight;

 /// 是否评价(0代表未评价，1代表已评价)
@property (nonatomic,strong)NSString *isreview;

// 真实数量
@property (nonatomic,strong)NSString *realcount;

 /// 商品购买数量
@property (nonatomic,strong)NSString *buycount;

/// 商品出库数量
@property (nonatomic,strong)NSString *buycount_s;

 /// 商品邮寄数量
@property (nonatomic,strong)NSString *sendcount;

// 商品类型(0为普遍商品,1为普通商品赠品,2为套装商品赠品,3为套装商品,4满赠商品,5特价商品)
@property (nonatomic,strong)NSString *type;

// 支付积分
@property (nonatomic,strong)NSString *paycredits;

// 赠送优惠劵类型id
@property (nonatomic,strong)NSString *coupontypeid;


@property (nonatomic,strong)NSString *extcode1;


@property (nonatomic,strong)NSString *extcode2;


@property (nonatomic,strong)NSString *extcode3;


@property (nonatomic,strong)NSString *extcode4;


@property (nonatomic,strong)NSString *extcode5;

 /// 添加时间
@property (nonatomic,strong)NSString *addtime;


@property (nonatomic,strong)NSString *orderproductstate;

/// 商品来源
@property (nonatomic,strong)NSString *channelType;


@property (nonatomic,strong)NSString *addpricebuypernum;


@property (nonatomic,strong)NSString *addpricebuynum;


@property (nonatomic,strong)NSString *addpricebuyid;


@property (nonatomic,strong)NSString *addpricebuycoast;


@property (nonatomic,strong)NSString *pmid;


@property (nonatomic,strong)NSString *isSelect;


@property (nonatomic,strong)NSString *DrugsBase_DrugName;


@property (nonatomic,strong)NSString *DrugsBase_Manufacturer;


@property (nonatomic,strong)NSString *paysn;


@end
