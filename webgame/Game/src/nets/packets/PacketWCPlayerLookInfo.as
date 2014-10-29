package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRankEquipInfo2
    import netc.packets2.StructStarItemData2
    import netc.packets2.StructCardData2
    import netc.packets2.StructBourn2
    import netc.packets2.StructRankEquipInfo2
    import netc.packets2.StructStarItemData2
    import netc.packets2.StructPetSkillItem2
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructRoleGemInfo2
    /** 
    *角色查看
    */
    public class PacketWCPlayerLookInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28006;
        /** 
        *角色编号
        */
        public var role:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *名称
        */
        public var name:String = new String();
        /** 
        *家族名称
        */
        public var guildname:String = new String();
        /** 
        *战力值
        */
        public var fight:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *炼骨
        */
        public var bone:int;
        /** 
        *性别
        */
        public var sex:int;
        /** 
        *经验
        */
        public var exp:Number;
        /** 
        *阵营
        */
        public var camp:int;
        /** 
        *生命
        */
        public var shengming:int;
        /** 
        *生命上限
        */
        public var shengmingMax:int;
        /** 
        *灵力
        */
        public var lingli:int;
        /** 
        *灵力上限
        */
        public var lingliMax:int;
        /** 
        *内攻击
        */
        public var gongjiNei:int;
        /** 
        *外攻击
        */
        public var gongjiWai:int;
        /** 
        *内防御
        */
        public var fangyuNei:int;
        /** 
        *外防御
        */
        public var fangyuWai:int;
        /** 
        *内攻击最大
        */
        public var gongjiNeiMax:int;
        /** 
        *外攻击最大
        */
        public var gongjiWaiMax:int;
        /** 
        *内防御最大
        */
        public var fangyuNeiMax:int;
        /** 
        *外防御最大
        */
        public var fangyuWaiMax:int;
        /** 
        *命中
        */
        public var mingzhong:int;
        /** 
        *闪避
        */
        public var shanbi:int;
        /** 
        *暴击
        */
        public var baoji:int;
        /** 
        *暴击率
        */
        public var baojiRate:int;
        /** 
        *韧性
        */
        public var renxing:int;
        /** 
        *眩晕抗性
        */
        public var xuanYun:int;
        /** 
        *减速抗性
        */
        public var jianSu:int;
        /** 
        *定身抗性
        */
        public var dingShen:int;
        /** 
        *沉默抗性
        */
        public var chenMo:int;
        /** 
        *混乱抗性
        */
        public var hunLuan:int;
        /** 
        *皮肤数据
        */
        public var s0:int;
        /** 
        *皮肤数据
        */
        public var s1:int;
        /** 
        *皮肤数据
        */
        public var s2:int;
        /** 
        *皮肤数据
        */
        public var s3:int;
        /** 
        *外形效果
        */
        public var r1:int;
        /** 
        *坐骑
        */
        public var horse:int;
        /** 
        *装备
        */
        public var arrItemequipInfo:Vector.<StructRankEquipInfo2> = new Vector.<StructRankEquipInfo2>();
        /** 
        *星魂
        */
        public var arrItemstar:Vector.<StructStarItemData2> = new Vector.<StructStarItemData2>();
        /** 
        *卡片
        */
        public var arrItemcardsInfo:Vector.<StructCardData2> = new Vector.<StructCardData2>();
        /** 
        *境界
        */
        public var arrItembournsInfo:Vector.<StructBourn2> = new Vector.<StructBourn2>();
        /** 
        *伙伴编号
        */
        public var pet:int;
        /** 
        *职业
        */
        public var pet_metier:int;
        /** 
        *名称
        */
        public var pet_name:String = new String();
        /** 
        *战力值
        */
        public var pet_fight:int;
        /** 
        *等级
        */
        public var pet_level:int;
        /** 
        *装备
        */
        public var arrItempet_equipInfo:Vector.<StructRankEquipInfo2> = new Vector.<StructRankEquipInfo2>();
        /** 
        *星魂
        */
        public var arrItempet_star:Vector.<StructStarItemData2> = new Vector.<StructStarItemData2>();
        /** 
        *生命
        */
        public var pet_shengming:int;
        /** 
        *生命上限
        */
        public var pet_shengmingMax:int;
        /** 
        *灵力
        */
        public var pet_lingli:int;
        /** 
        *灵力上限
        */
        public var pet_lingliMax:int;
        /** 
        *内攻击
        */
        public var pet_gongjiNei:int;
        /** 
        *外攻击
        */
        public var pet_gongjiWai:int;
        /** 
        *内防御
        */
        public var pet_fangyuNei:int;
        /** 
        *外防御
        */
        public var pet_fangyuWai:int;
        /** 
        *命中
        */
        public var pet_mingzhong:int;
        /** 
        *闪避
        */
        public var pet_shanbi:int;
        /** 
        *暴击
        */
        public var pet_baoji:int;
        /** 
        *暴击率
        */
        public var pet_baojiRate:int;
        /** 
        *韧性
        */
        public var pet_renxing:int;
        /** 
        *格挡
        */
        public var pet_gedang:int;
        /** 
        *破甲
        */
        public var pet_pojia:int;
        /** 
        *破格
        */
        public var pet_poGe:int;
        /** 
        *雷电伤害
        */
        public var pet_dianshang:int;
        /** 
        *雷电抗性
        */
        public var pet_diankang:int;
        /** 
        *火焰伤害
        */
        public var pet_huoshang:int;
        /** 
        *火焰抗性
        */
        public var pet_huofang:int;
        /** 
        *冰冻伤害
        */
        public var pet_bingshang:int;
        /** 
        *冰冻抗性
        */
        public var pet_bingfang:int;
        /** 
        *眩晕抗性
        */
        public var pet_xuanYun:int;
        /** 
        *减速抗性
        */
        public var pet_jianSu:int;
        /** 
        *定身抗性
        */
        public var pet_dingShen:int;
        /** 
        *沉默抗性
        */
        public var pet_chenMo:int;
        /** 
        *混乱抗性
        */
        public var pet_hunLuan:int;
        /** 
        *生命封印
        */
        public var pet_shengmingfengyin:int;
        /** 
        *外攻封印
        */
        public var pet_waigongfengyin:int;
        /** 
        *内攻封印
        */
        public var pet_neigongfengyin:int;
        /** 
        *内功防御封印
        */
        public var pet_fangyuNeifengyin:int;
        /** 
        *外功防御封印
        */
        public var pet_fangyuWaifengyin:int;
        /** 
        *生命资质
        */
        public var pet_shengmingzizhi:int;
        /** 
        *外攻资质
        */
        public var pet_waigongzizhi:int;
        /** 
        *内攻资质
        */
        public var pet_neigongzizhi:int;
        /** 
        *防御资质
        */
        public var pet_fangyuzizhi:int;
        /** 
        *附加力量
        */
        public var pet_liLiang:int;
        /** 
        *附加敏捷
        */
        public var pet_minJie:int;
        /** 
        *附加体质
        */
        public var pet_tiZhi:int;
        /** 
        *附加智力
        */
        public var pet_zhiLi:int;
        /** 
        *附加精神
        */
        public var pet_jingShen:int;
        /** 
        *总力量
        */
        public var pet_liLiangTotal:int;
        /** 
        *总敏捷
        */
        public var pet_minJieTotal:int;
        /** 
        *总体质
        */
        public var pet_tiZhiTotal:int;
        /** 
        *总智力
        */
        public var pet_zhiLiTotal:int;
        /** 
        *总精神
        */
        public var pet_jingShenTotal:int;
        /** 
        *潜力点
        */
        public var pet_qianLi:int;
        /** 
        *星级
        */
        public var pet_xingJi:int;
        /** 
        *品质
        */
        public var pet_pinZhi:int;
        /** 
        *鉴定
        */
        public var pet_jianDing:int;
        /** 
        *经验
        */
        public var pet_exp:int;
        /** 
        *技能
        */
        public var arrItempet_Skills:Vector.<StructPetSkillItem2> = new Vector.<StructPetSkillItem2>();
        /** 
        *卡片
        */
        public var arrItemcard:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *四神器
        */
        public var arrItemguard:Vector.<int> = new Vector.<int>();
        /** 
        *宝石信息
        */
        public var geminfo:StructRoleGemInfo2 = new StructRoleGemInfo2();
        /** 
        *翅膀
        */
        public var wingLevel:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(role);
            ar.writeInt(metier);
            PacketFactory.Instance.WriteString(ar, name, 64);
            PacketFactory.Instance.WriteString(ar, guildname, 32);
            ar.writeInt(fight);
            ar.writeInt(level);
            ar.writeInt(bone);
            ar.writeInt(sex);
            ar.writeDouble(exp);
            ar.writeInt(camp);
            ar.writeInt(shengming);
            ar.writeInt(shengmingMax);
            ar.writeInt(lingli);
            ar.writeInt(lingliMax);
            ar.writeInt(gongjiNei);
            ar.writeInt(gongjiWai);
            ar.writeInt(fangyuNei);
            ar.writeInt(fangyuWai);
            ar.writeInt(gongjiNeiMax);
            ar.writeInt(gongjiWaiMax);
            ar.writeInt(fangyuNeiMax);
            ar.writeInt(fangyuWaiMax);
            ar.writeInt(mingzhong);
            ar.writeInt(shanbi);
            ar.writeInt(baoji);
            ar.writeInt(baojiRate);
            ar.writeInt(renxing);
            ar.writeInt(xuanYun);
            ar.writeInt(jianSu);
            ar.writeInt(dingShen);
            ar.writeInt(chenMo);
            ar.writeInt(hunLuan);
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(r1);
            ar.writeInt(horse);
            ar.writeInt(arrItemequipInfo.length);
            for each (var equipInfoitem:Object in arrItemequipInfo)
            {
                var objequipInfo:ISerializable = equipInfoitem as ISerializable;
                if (null!=objequipInfo)
                {
                    objequipInfo.Serialize(ar);
                }
            }
            ar.writeInt(arrItemstar.length);
            for each (var staritem:Object in arrItemstar)
            {
                var objstar:ISerializable = staritem as ISerializable;
                if (null!=objstar)
                {
                    objstar.Serialize(ar);
                }
            }
            ar.writeInt(arrItemcardsInfo.length);
            for each (var cardsInfoitem:Object in arrItemcardsInfo)
            {
                var objcardsInfo:ISerializable = cardsInfoitem as ISerializable;
                if (null!=objcardsInfo)
                {
                    objcardsInfo.Serialize(ar);
                }
            }
            ar.writeInt(arrItembournsInfo.length);
            for each (var bournsInfoitem:Object in arrItembournsInfo)
            {
                var objbournsInfo:ISerializable = bournsInfoitem as ISerializable;
                if (null!=objbournsInfo)
                {
                    objbournsInfo.Serialize(ar);
                }
            }
            ar.writeInt(pet);
            ar.writeInt(pet_metier);
            PacketFactory.Instance.WriteString(ar, pet_name, 64);
            ar.writeInt(pet_fight);
            ar.writeInt(pet_level);
            ar.writeInt(arrItempet_equipInfo.length);
            for each (var pet_equipInfoitem:Object in arrItempet_equipInfo)
            {
                var objpet_equipInfo:ISerializable = pet_equipInfoitem as ISerializable;
                if (null!=objpet_equipInfo)
                {
                    objpet_equipInfo.Serialize(ar);
                }
            }
            ar.writeInt(arrItempet_star.length);
            for each (var pet_staritem:Object in arrItempet_star)
            {
                var objpet_star:ISerializable = pet_staritem as ISerializable;
                if (null!=objpet_star)
                {
                    objpet_star.Serialize(ar);
                }
            }
            ar.writeInt(pet_shengming);
            ar.writeInt(pet_shengmingMax);
            ar.writeInt(pet_lingli);
            ar.writeInt(pet_lingliMax);
            ar.writeInt(pet_gongjiNei);
            ar.writeInt(pet_gongjiWai);
            ar.writeInt(pet_fangyuNei);
            ar.writeInt(pet_fangyuWai);
            ar.writeInt(pet_mingzhong);
            ar.writeInt(pet_shanbi);
            ar.writeInt(pet_baoji);
            ar.writeInt(pet_baojiRate);
            ar.writeInt(pet_renxing);
            ar.writeInt(pet_gedang);
            ar.writeInt(pet_pojia);
            ar.writeInt(pet_poGe);
            ar.writeInt(pet_dianshang);
            ar.writeInt(pet_diankang);
            ar.writeInt(pet_huoshang);
            ar.writeInt(pet_huofang);
            ar.writeInt(pet_bingshang);
            ar.writeInt(pet_bingfang);
            ar.writeInt(pet_xuanYun);
            ar.writeInt(pet_jianSu);
            ar.writeInt(pet_dingShen);
            ar.writeInt(pet_chenMo);
            ar.writeInt(pet_hunLuan);
            ar.writeInt(pet_shengmingfengyin);
            ar.writeInt(pet_waigongfengyin);
            ar.writeInt(pet_neigongfengyin);
            ar.writeInt(pet_fangyuNeifengyin);
            ar.writeInt(pet_fangyuWaifengyin);
            ar.writeInt(pet_shengmingzizhi);
            ar.writeInt(pet_waigongzizhi);
            ar.writeInt(pet_neigongzizhi);
            ar.writeInt(pet_fangyuzizhi);
            ar.writeInt(pet_liLiang);
            ar.writeInt(pet_minJie);
            ar.writeInt(pet_tiZhi);
            ar.writeInt(pet_zhiLi);
            ar.writeInt(pet_jingShen);
            ar.writeInt(pet_liLiangTotal);
            ar.writeInt(pet_minJieTotal);
            ar.writeInt(pet_tiZhiTotal);
            ar.writeInt(pet_zhiLiTotal);
            ar.writeInt(pet_jingShenTotal);
            ar.writeInt(pet_qianLi);
            ar.writeInt(pet_xingJi);
            ar.writeInt(pet_pinZhi);
            ar.writeInt(pet_jianDing);
            ar.writeInt(pet_exp);
            ar.writeInt(arrItempet_Skills.length);
            for each (var pet_Skillsitem:Object in arrItempet_Skills)
            {
                var objpet_Skills:ISerializable = pet_Skillsitem as ISerializable;
                if (null!=objpet_Skills)
                {
                    objpet_Skills.Serialize(ar);
                }
            }
            ar.writeInt(arrItemcard.length);
            for each (var carditem:Object in arrItemcard)
            {
                var objcard:ISerializable = carditem as ISerializable;
                if (null!=objcard)
                {
                    objcard.Serialize(ar);
                }
            }
            ar.writeInt(arrItemguard.length);
            for each (var guarditem:int in arrItemguard)
            {
                ar.writeInt(guarditem);
            }
            geminfo.Serialize(ar);
            ar.writeInt(wingLevel);
        }
        public function Deserialize(ar:ByteArray):void
        {
            role = ar.readInt();
            metier = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
            fight = ar.readInt();
            level = ar.readInt();
            bone = ar.readInt();
            sex = ar.readInt();
            exp = ar.readDouble();
            camp = ar.readInt();
            shengming = ar.readInt();
            shengmingMax = ar.readInt();
            lingli = ar.readInt();
            lingliMax = ar.readInt();
            gongjiNei = ar.readInt();
            gongjiWai = ar.readInt();
            fangyuNei = ar.readInt();
            fangyuWai = ar.readInt();
            gongjiNeiMax = ar.readInt();
            gongjiWaiMax = ar.readInt();
            fangyuNeiMax = ar.readInt();
            fangyuWaiMax = ar.readInt();
            mingzhong = ar.readInt();
            shanbi = ar.readInt();
            baoji = ar.readInt();
            baojiRate = ar.readInt();
            renxing = ar.readInt();
            xuanYun = ar.readInt();
            jianSu = ar.readInt();
            dingShen = ar.readInt();
            chenMo = ar.readInt();
            hunLuan = ar.readInt();
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            r1 = ar.readInt();
            horse = ar.readInt();
            arrItemequipInfo= new  Vector.<StructRankEquipInfo2>();
            var equipInfoLength:int = ar.readInt();
            for (var iequipInfo:int=0;iequipInfo<equipInfoLength; ++iequipInfo)
            {
                var objRankEquipInfo:StructRankEquipInfo2 = new StructRankEquipInfo2();
                objRankEquipInfo.Deserialize(ar);
                arrItemequipInfo.push(objRankEquipInfo);
            }
            arrItemstar= new  Vector.<StructStarItemData2>();
            var starLength:int = ar.readInt();
            for (var istar:int=0;istar<starLength; ++istar)
            {
                var objStarItemData:StructStarItemData2 = new StructStarItemData2();
                objStarItemData.Deserialize(ar);
                arrItemstar.push(objStarItemData);
            }
            arrItemcardsInfo= new  Vector.<StructCardData2>();
            var cardsInfoLength:int = ar.readInt();
            for (var icardsInfo:int=0;icardsInfo<cardsInfoLength; ++icardsInfo)
            {
                var objCardData:StructCardData2 = new StructCardData2();
                objCardData.Deserialize(ar);
                arrItemcardsInfo.push(objCardData);
            }
            arrItembournsInfo= new  Vector.<StructBourn2>();
            var bournsInfoLength:int = ar.readInt();
            for (var ibournsInfo:int=0;ibournsInfo<bournsInfoLength; ++ibournsInfo)
            {
                var objBourn:StructBourn2 = new StructBourn2();
                objBourn.Deserialize(ar);
                arrItembournsInfo.push(objBourn);
            }
            pet = ar.readInt();
            pet_metier = ar.readInt();
            var pet_nameLength:int = ar.readInt();
            pet_name = ar.readMultiByte(pet_nameLength,PacketFactory.Instance.GetCharSet());
            pet_fight = ar.readInt();
            pet_level = ar.readInt();
            arrItempet_equipInfo= new  Vector.<StructRankEquipInfo2>();
            var pet_equipInfoLength:int = ar.readInt();
            for (var ipet_equipInfo:int=0;ipet_equipInfo<pet_equipInfoLength; ++ipet_equipInfo)
            {
                var objRankEquipInfo:StructRankEquipInfo2 = new StructRankEquipInfo2();
                objRankEquipInfo.Deserialize(ar);
                arrItempet_equipInfo.push(objRankEquipInfo);
            }
            arrItempet_star= new  Vector.<StructStarItemData2>();
            var pet_starLength:int = ar.readInt();
            for (var ipet_star:int=0;ipet_star<pet_starLength; ++ipet_star)
            {
                var objStarItemData:StructStarItemData2 = new StructStarItemData2();
                objStarItemData.Deserialize(ar);
                arrItempet_star.push(objStarItemData);
            }
            pet_shengming = ar.readInt();
            pet_shengmingMax = ar.readInt();
            pet_lingli = ar.readInt();
            pet_lingliMax = ar.readInt();
            pet_gongjiNei = ar.readInt();
            pet_gongjiWai = ar.readInt();
            pet_fangyuNei = ar.readInt();
            pet_fangyuWai = ar.readInt();
            pet_mingzhong = ar.readInt();
            pet_shanbi = ar.readInt();
            pet_baoji = ar.readInt();
            pet_baojiRate = ar.readInt();
            pet_renxing = ar.readInt();
            pet_gedang = ar.readInt();
            pet_pojia = ar.readInt();
            pet_poGe = ar.readInt();
            pet_dianshang = ar.readInt();
            pet_diankang = ar.readInt();
            pet_huoshang = ar.readInt();
            pet_huofang = ar.readInt();
            pet_bingshang = ar.readInt();
            pet_bingfang = ar.readInt();
            pet_xuanYun = ar.readInt();
            pet_jianSu = ar.readInt();
            pet_dingShen = ar.readInt();
            pet_chenMo = ar.readInt();
            pet_hunLuan = ar.readInt();
            pet_shengmingfengyin = ar.readInt();
            pet_waigongfengyin = ar.readInt();
            pet_neigongfengyin = ar.readInt();
            pet_fangyuNeifengyin = ar.readInt();
            pet_fangyuWaifengyin = ar.readInt();
            pet_shengmingzizhi = ar.readInt();
            pet_waigongzizhi = ar.readInt();
            pet_neigongzizhi = ar.readInt();
            pet_fangyuzizhi = ar.readInt();
            pet_liLiang = ar.readInt();
            pet_minJie = ar.readInt();
            pet_tiZhi = ar.readInt();
            pet_zhiLi = ar.readInt();
            pet_jingShen = ar.readInt();
            pet_liLiangTotal = ar.readInt();
            pet_minJieTotal = ar.readInt();
            pet_tiZhiTotal = ar.readInt();
            pet_zhiLiTotal = ar.readInt();
            pet_jingShenTotal = ar.readInt();
            pet_qianLi = ar.readInt();
            pet_xingJi = ar.readInt();
            pet_pinZhi = ar.readInt();
            pet_jianDing = ar.readInt();
            pet_exp = ar.readInt();
            arrItempet_Skills= new  Vector.<StructPetSkillItem2>();
            var pet_SkillsLength:int = ar.readInt();
            for (var ipet_Skills:int=0;ipet_Skills<pet_SkillsLength; ++ipet_Skills)
            {
                var objPetSkillItem:StructPetSkillItem2 = new StructPetSkillItem2();
                objPetSkillItem.Deserialize(ar);
                arrItempet_Skills.push(objPetSkillItem);
            }
            arrItemcard= new  Vector.<StructItemAttr2>();
            var cardLength:int = ar.readInt();
            for (var icard:int=0;icard<cardLength; ++icard)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemcard.push(objItemAttr);
            }
            arrItemguard= new  Vector.<int>();
            var guardLength:int = ar.readInt();
            for (var iguard:int=0;iguard<guardLength; ++iguard)
            {
                arrItemguard.push(ar.readInt());
            }
            geminfo.Deserialize(ar);
            wingLevel = ar.readInt();
        }
    }
}
