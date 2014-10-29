package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRankEquipInfo2
    import netc.packets2.StructRankSatrInfo2
    import netc.packets2.StructBournList2
    import netc.packets2.StructCardInfo2
    import netc.packets2.StructHorseList2
    /** 
    *排行榜角色查看
    */
    public class PacketWCRankPlayerInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28003;
        /** 
        *编号
        */
        public var roleid:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *头像
        */
        public var head:int;
        /** 
        *战力值
        */
        public var fight:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *性别
        */
        public var sex:int;
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
        *成就1
        */
        public var honor1:int;
        /** 
        *成就2
        */
        public var honor2:int;
        /** 
        *成就3
        */
        public var honor3:int;
        /** 
        *成就4
        */
        public var honor4:int;
        /** 
        *成就5
        */
        public var honor5:int;
        /** 
        *装备
        */
        public var arrItemequipInfo:Vector.<StructRankEquipInfo2> = new Vector.<StructRankEquipInfo2>();
        /** 
        *武魂
        */
        public var arrItemstar:Vector.<StructRankSatrInfo2> = new Vector.<StructRankSatrInfo2>();
        /** 
        *星界
        */
        public var bourn:StructBournList2 = new StructBournList2();
        /** 
        *藏经阁
        */
        public var card:StructCardInfo2 = new StructCardInfo2();
        /** 
        *坐骑列表
        */
        public var arrItemhorselist:Vector.<StructHorseList2> = new Vector.<StructHorseList2>();
        /** 
        *VIP等级
        */
        public var vipLevel:int;
        /** 
        *龙脉等级
        */
        public var starLevel:int;
        /** 
        *渡劫等级
        */
        public var soarLevel:int;
        /** 
        *翅膀等级
        */
        public var wingLevel:int;
        /** 
        *结婚类型
        */
        public var marrySort:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(metier);
            ar.writeInt(head);
            ar.writeInt(fight);
            ar.writeInt(level);
            ar.writeInt(sex);
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(r1);
            ar.writeInt(honor1);
            ar.writeInt(honor2);
            ar.writeInt(honor3);
            ar.writeInt(honor4);
            ar.writeInt(honor5);
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
            bourn.Serialize(ar);
            card.Serialize(ar);
            ar.writeInt(arrItemhorselist.length);
            for each (var horselistitem:Object in arrItemhorselist)
            {
                var objhorselist:ISerializable = horselistitem as ISerializable;
                if (null!=objhorselist)
                {
                    objhorselist.Serialize(ar);
                }
            }
            ar.writeInt(vipLevel);
            ar.writeInt(starLevel);
            ar.writeInt(soarLevel);
            ar.writeInt(wingLevel);
            ar.writeInt(marrySort);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            metier = ar.readInt();
            head = ar.readInt();
            fight = ar.readInt();
            level = ar.readInt();
            sex = ar.readInt();
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            r1 = ar.readInt();
            honor1 = ar.readInt();
            honor2 = ar.readInt();
            honor3 = ar.readInt();
            honor4 = ar.readInt();
            honor5 = ar.readInt();
            arrItemequipInfo= new  Vector.<StructRankEquipInfo2>();
            var equipInfoLength:int = ar.readInt();
            for (var iequipInfo:int=0;iequipInfo<equipInfoLength; ++iequipInfo)
            {
                var objRankEquipInfo:StructRankEquipInfo2 = new StructRankEquipInfo2();
                objRankEquipInfo.Deserialize(ar);
                arrItemequipInfo.push(objRankEquipInfo);
            }
            arrItemstar= new  Vector.<StructRankSatrInfo2>();
            var starLength:int = ar.readInt();
            for (var istar:int=0;istar<starLength; ++istar)
            {
                var objRankSatrInfo:StructRankSatrInfo2 = new StructRankSatrInfo2();
                objRankSatrInfo.Deserialize(ar);
                arrItemstar.push(objRankSatrInfo);
            }
            bourn.Deserialize(ar);
            card.Deserialize(ar);
            arrItemhorselist= new  Vector.<StructHorseList2>();
            var horselistLength:int = ar.readInt();
            for (var ihorselist:int=0;ihorselist<horselistLength; ++ihorselist)
            {
                var objHorseList:StructHorseList2 = new StructHorseList2();
                objHorseList.Deserialize(ar);
                arrItemhorselist.push(objHorseList);
            }
            vipLevel = ar.readInt();
            starLevel = ar.readInt();
            soarLevel = ar.readInt();
            wingLevel = ar.readInt();
            marrySort = ar.readInt();
        }
    }
}
