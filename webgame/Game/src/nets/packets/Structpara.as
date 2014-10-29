package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRmbShopItem2
    import netc.packets2.StructOnlinePrizeData2
    import netc.packets2.StructMergeServerData2
    /** 
    *杂七杂八的保存数据
    */
    public class Structpara implements ISerializable
    {
        /** 
        *称号
        */
        public var ranktitle:int;
        /** 
        *当日兑换次数
        */
        public var exchangetimes:int;
        /** 
        *礼包数据
        */
        public var gifts:int;
        /** 
        *神秘商店
        */
        public var arrItemrmbshop:Vector.<StructRmbShopItem2> = new Vector.<StructRmbShopItem2>();
        /** 
        *神秘商店更新时间
        */
        public var rmbshopupdate:int;
        /** 
        *最后刷新时间(跨天刷新业务)
        */
        public var lastrefreshday:int;
        /** 
        *已领取在线礼包的个数
        */
        public var onlinegifts:int;
        /** 
        *在线时间
        */
        public var onlinetime:int;
        /** 
        *游戏中获得的绑定和非绑定元宝
        */
        public var exrmball:int;
        /** 
        *发广告时间
        */
        public var advertDataInt:int;
        /** 
        *排行榜奖励
        */
        public var ranktopaward:int;
        /** 
        *领取奖励时间
        */
        public var ranktopaward_time:int;
        /** 
        *玩家特殊的标记
        */
        public var SpecialFlag:int;
        /** 
        *在线奖励领取时间
        */
        public var onlineawadtime:int;
        /** 
        *默认阵法
        */
        public var defaulttTamSkill:int;
        /** 
        *浇水记录
        */
        public var guildtreeop1:int;
        /** 
        *施肥记录
        */
        public var guildtreeop2:int;
        /** 
        *捉虫记录
        */
        public var guildtreeop3:int;
        /** 
        *获得果实的树等级
        */
        public var guildtreelv:int;
        /** 
        *地图双倍经验剩余时间
        */
        public var mapdoubleexptime:int;
        /** 
        *家族礼包领取状态
        */
        public var guildgift:int;
        /** 
        *试用VIP等级
        */
        public var testviplevel:int;
        /** 
        *试用VIP等级剩余时间(以秒为单位)
        */
        public var testviptime:int;
        /** 
        *是否是皇城争霸胜利帮会
        */
        public var isguildcity:int;
        /** 
        *境界奖励等级
        */
        public var bournawardlevel:int;
        /** 
        *QQ黄钻vip等级奖励状态
        */
        public var qqyellowviplevelstate:int;
        /** 
        *Q币奖励
        */
        public var qqrmb:int;
        /** 
        *累计消费
        */
        public var consume_num:int;
        /** 
        *消费奖励状态
        */
        public var consume_prize_state:int;
        /** 
        *每日累计消费
        */
        public var consume_num_day:int;
        /** 
        *温泉个人时间
        */
        public var spaprivatetime:int;
        /** 
        *温泉系统时间
        */
        public var spasystime:int;
        /** 
        *QQ邀请当前次数
        */
        public var qqinvite_times_day:int;
        /** 
        *QQ邀请奖励可否领取状态
        */
        public var qqinvite_flag:int;
        /** 
        *QQ邀请奖励领取状态
        */
        public var qqinvite_state:int;
        /** 
        *QQ分享次数
        */
        public var qqshare_time:int;
        /** 
        *server pk 时间数
        */
        public var server_pk_time:int;
        /** 
        *QQ邀请总次数
        */
        public var qqinvite_times:int;
        /** 
        *验证码时间
        */
        public var verifyDataInt:int;
        /** 
        *修改阵营次数
        */
        public var camp_change_times:int;
        /** 
        *QQ蓝钻vip等级奖励状态
        */
        public var qqblueviplevelstate:int;
        /** 
        *武魂点
        */
        public var military_soul_point:int;
        /** 
        *武魂碎片
        */
        public var military_soul_chip:int;
        /** 
        *武魂宗师索引
        */
        public var military_soul_master_idx:int;
        /** 
        *武魂奇遇标记
        */
        public var military_soul_happy_encounter:int;
        /** 
        *快捷栏锁标记
        */
        public var shortkey_lockflag:int;
        /** 
        *设置显示的称号
        */
        public var displaytitle:int;
        /** 
        *寻宝幸运度
        */
        public var discovery_lucky:int;
        /** 
        *寻宝领取免费奖励标记
        */
        public var discovery_draw_flag:int;
        /** 
        *寻宝随机种子
        */
        public var discovery_rand_seed:int;
        /** 
        *寻宝物品ID
        */
        public var discovery_item_id:int;
        /** 
        *寻宝物品数量
        */
        public var discovery_item_num:int;
        /** 
        *寻宝物品ruler
        */
        public var discovery_item_ruler:int;
        /** 
        *寻宝幸运度物品ID
        */
        public var discovery_prize_item_id:int;
        /** 
        *寻宝幸运度物品数量
        */
        public var discovery_prize_item_num:int;
        /** 
        *寻宝幸运度物品ruler
        */
        public var discovery_prize_item_ruler:int;
        /** 
        *阅历当日兑换次数
        */
        public var exchangeexp2times:int;
        /** 
        *累计在线时长(分钟)
        */
        public var total_ol_minute:int;
        /** 
        *背包开启,花元宝开启的格子要记录对应的时间
        */
        public var rmb_buy_secs:int;
        /** 
        *寻宝积分
        */
        public var discovery_grade:int;
        /** 
        *数据修复标记
        */
        public var data_repair_flag:int;
        /** 
        *未领取的在线奖励
        */
        public var arrItemOnlinePrizePool:Vector.<StructOnlinePrizeData2> = new Vector.<StructOnlinePrizeData2>();
        /** 
        *合服活动
        */
        public var MergeServerData:StructMergeServerData2 = new StructMergeServerData2();
        /** 
        *发送非法聊天数据的时间
        */
        public var arrItembadWordPool:Vector.<int> = new Vector.<int>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ranktitle);
            ar.writeInt(exchangetimes);
            ar.writeInt(gifts);
            ar.writeInt(arrItemrmbshop.length);
            for each (var rmbshopitem:Object in arrItemrmbshop)
            {
                var objrmbshop:ISerializable = rmbshopitem as ISerializable;
                if (null!=objrmbshop)
                {
                    objrmbshop.Serialize(ar);
                }
            }
            ar.writeInt(rmbshopupdate);
            ar.writeInt(lastrefreshday);
            ar.writeInt(onlinegifts);
            ar.writeInt(onlinetime);
            ar.writeInt(exrmball);
            ar.writeInt(advertDataInt);
            ar.writeInt(ranktopaward);
            ar.writeInt(ranktopaward_time);
            ar.writeInt(SpecialFlag);
            ar.writeInt(onlineawadtime);
            ar.writeInt(defaulttTamSkill);
            ar.writeInt(guildtreeop1);
            ar.writeInt(guildtreeop2);
            ar.writeInt(guildtreeop3);
            ar.writeInt(guildtreelv);
            ar.writeInt(mapdoubleexptime);
            ar.writeInt(guildgift);
            ar.writeInt(testviplevel);
            ar.writeInt(testviptime);
            ar.writeInt(isguildcity);
            ar.writeInt(bournawardlevel);
            ar.writeInt(qqyellowviplevelstate);
            ar.writeInt(qqrmb);
            ar.writeInt(consume_num);
            ar.writeInt(consume_prize_state);
            ar.writeInt(consume_num_day);
            ar.writeInt(spaprivatetime);
            ar.writeInt(spasystime);
            ar.writeInt(qqinvite_times_day);
            ar.writeInt(qqinvite_flag);
            ar.writeInt(qqinvite_state);
            ar.writeInt(qqshare_time);
            ar.writeInt(server_pk_time);
            ar.writeInt(qqinvite_times);
            ar.writeInt(verifyDataInt);
            ar.writeInt(camp_change_times);
            ar.writeInt(qqblueviplevelstate);
            ar.writeInt(military_soul_point);
            ar.writeInt(military_soul_chip);
            ar.writeByte(military_soul_master_idx);
            ar.writeByte(military_soul_happy_encounter);
            ar.writeByte(shortkey_lockflag);
            ar.writeInt(displaytitle);
            ar.writeInt(discovery_lucky);
            ar.writeInt(discovery_draw_flag);
            ar.writeInt(discovery_rand_seed);
            ar.writeInt(discovery_item_id);
            ar.writeInt(discovery_item_num);
            ar.writeInt(discovery_item_ruler);
            ar.writeInt(discovery_prize_item_id);
            ar.writeInt(discovery_prize_item_num);
            ar.writeInt(discovery_prize_item_ruler);
            ar.writeInt(exchangeexp2times);
            ar.writeInt(total_ol_minute);
            ar.writeInt(rmb_buy_secs);
            ar.writeInt(discovery_grade);
            ar.writeInt(data_repair_flag);
            ar.writeInt(arrItemOnlinePrizePool.length);
            for each (var OnlinePrizePoolitem:Object in arrItemOnlinePrizePool)
            {
                var objOnlinePrizePool:ISerializable = OnlinePrizePoolitem as ISerializable;
                if (null!=objOnlinePrizePool)
                {
                    objOnlinePrizePool.Serialize(ar);
                }
            }
            MergeServerData.Serialize(ar);
            ar.writeInt(arrItembadWordPool.length);
            for each (var badWordPoolitem:int in arrItembadWordPool)
            {
                ar.writeInt(badWordPoolitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            ranktitle = ar.readInt();
            exchangetimes = ar.readInt();
            gifts = ar.readInt();
            arrItemrmbshop= new  Vector.<StructRmbShopItem2>();
            var rmbshopLength:int = ar.readInt();
            for (var irmbshop:int=0;irmbshop<rmbshopLength; ++irmbshop)
            {
                var objRmbShopItem:StructRmbShopItem2 = new StructRmbShopItem2();
                objRmbShopItem.Deserialize(ar);
                arrItemrmbshop.push(objRmbShopItem);
            }
            rmbshopupdate = ar.readInt();
            lastrefreshday = ar.readInt();
            onlinegifts = ar.readInt();
            onlinetime = ar.readInt();
            exrmball = ar.readInt();
            advertDataInt = ar.readInt();
            ranktopaward = ar.readInt();
            ranktopaward_time = ar.readInt();
            SpecialFlag = ar.readInt();
            onlineawadtime = ar.readInt();
            defaulttTamSkill = ar.readInt();
            guildtreeop1 = ar.readInt();
            guildtreeop2 = ar.readInt();
            guildtreeop3 = ar.readInt();
            guildtreelv = ar.readInt();
            mapdoubleexptime = ar.readInt();
            guildgift = ar.readInt();
            testviplevel = ar.readInt();
            testviptime = ar.readInt();
            isguildcity = ar.readInt();
            bournawardlevel = ar.readInt();
            qqyellowviplevelstate = ar.readInt();
            qqrmb = ar.readInt();
            consume_num = ar.readInt();
            consume_prize_state = ar.readInt();
            consume_num_day = ar.readInt();
            spaprivatetime = ar.readInt();
            spasystime = ar.readInt();
            qqinvite_times_day = ar.readInt();
            qqinvite_flag = ar.readInt();
            qqinvite_state = ar.readInt();
            qqshare_time = ar.readInt();
            server_pk_time = ar.readInt();
            qqinvite_times = ar.readInt();
            verifyDataInt = ar.readInt();
            camp_change_times = ar.readInt();
            qqblueviplevelstate = ar.readInt();
            military_soul_point = ar.readInt();
            military_soul_chip = ar.readInt();
            military_soul_master_idx = ar.readByte();
            military_soul_happy_encounter = ar.readByte();
            shortkey_lockflag = ar.readByte();
            displaytitle = ar.readInt();
            discovery_lucky = ar.readInt();
            discovery_draw_flag = ar.readInt();
            discovery_rand_seed = ar.readInt();
            discovery_item_id = ar.readInt();
            discovery_item_num = ar.readInt();
            discovery_item_ruler = ar.readInt();
            discovery_prize_item_id = ar.readInt();
            discovery_prize_item_num = ar.readInt();
            discovery_prize_item_ruler = ar.readInt();
            exchangeexp2times = ar.readInt();
            total_ol_minute = ar.readInt();
            rmb_buy_secs = ar.readInt();
            discovery_grade = ar.readInt();
            data_repair_flag = ar.readInt();
            arrItemOnlinePrizePool= new  Vector.<StructOnlinePrizeData2>();
            var OnlinePrizePoolLength:int = ar.readInt();
            for (var iOnlinePrizePool:int=0;iOnlinePrizePool<OnlinePrizePoolLength; ++iOnlinePrizePool)
            {
                var objOnlinePrizeData:StructOnlinePrizeData2 = new StructOnlinePrizeData2();
                objOnlinePrizeData.Deserialize(ar);
                arrItemOnlinePrizePool.push(objOnlinePrizeData);
            }
            MergeServerData.Deserialize(ar);
            arrItembadWordPool= new  Vector.<int>();
            var badWordPoolLength:int = ar.readInt();
            for (var ibadWordPool:int=0;ibadWordPool<badWordPoolLength; ++ibadWordPool)
            {
                arrItembadWordPool.push(ar.readInt());
            }
        }
    }
}
