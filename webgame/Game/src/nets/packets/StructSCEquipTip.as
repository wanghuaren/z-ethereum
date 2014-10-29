package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructEvilGrain2
    /** 
    *悬浮
    */
    public class StructSCEquipTip implements ISerializable
    {
        /** 
        *错误返回码
        */
        public var tag:int;
        /** 
        *强化等级
        */
        public var strongLevel:int;
        /** 
        *强化失败次数
        */
        public var strongFailed:int;
        /** 
        *当前耐久值
        */
        public var curDurPoint:int;
        /** 
        *战力值
        */
        public var fightValue:int;
        /** 
        *装备属性
        */
        public var arrItemequipAttrs:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *装备噬魂属性
        */
        public var arrItemsoulAttrs:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *装备id
        */
        public var itemid:int;
        /** 
        *魔纹数据
        */
        public var arrItemevilGrains:Vector.<StructEvilGrain2> = new Vector.<StructEvilGrain2>();
        /** 
        *神品品阶
        */
        public var colorLvl:int;
        /** 
        *噬魂等级
        */
        public var soulLvl:int;
        /** 
        *是否鉴定 0:未鉴定 1:已鉴定
        */
        public var identify:int;
        /** 
        *物品规则
        */
        public var ruler:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(tag);
            ar.writeInt(strongLevel);
            ar.writeInt(strongFailed);
            ar.writeInt(curDurPoint);
            ar.writeInt(fightValue);
            ar.writeInt(arrItemequipAttrs.length);
            for each (var equipAttrsitem:Object in arrItemequipAttrs)
            {
                var objequipAttrs:ISerializable = equipAttrsitem as ISerializable;
                if (null!=objequipAttrs)
                {
                    objequipAttrs.Serialize(ar);
                }
            }
            ar.writeInt(arrItemsoulAttrs.length);
            for each (var soulAttrsitem:Object in arrItemsoulAttrs)
            {
                var objsoulAttrs:ISerializable = soulAttrsitem as ISerializable;
                if (null!=objsoulAttrs)
                {
                    objsoulAttrs.Serialize(ar);
                }
            }
            ar.writeInt(itemid);
            ar.writeInt(arrItemevilGrains.length);
            for each (var evilGrainsitem:Object in arrItemevilGrains)
            {
                var objevilGrains:ISerializable = evilGrainsitem as ISerializable;
                if (null!=objevilGrains)
                {
                    objevilGrains.Serialize(ar);
                }
            }
            ar.writeByte(colorLvl);
            ar.writeByte(soulLvl);
            ar.writeByte(identify);
            ar.writeShort(ruler);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            strongLevel = ar.readInt();
            strongFailed = ar.readInt();
            curDurPoint = ar.readInt();
            fightValue = ar.readInt();
            arrItemequipAttrs= new  Vector.<StructItemAttr2>();
            var equipAttrsLength:int = ar.readInt();
            for (var iequipAttrs:int=0;iequipAttrs<equipAttrsLength; ++iequipAttrs)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemequipAttrs.push(objItemAttr);
            }
            arrItemsoulAttrs= new  Vector.<StructItemAttr2>();
            var soulAttrsLength:int = ar.readInt();
            for (var isoulAttrs:int=0;isoulAttrs<soulAttrsLength; ++isoulAttrs)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemsoulAttrs.push(objItemAttr);
            }
            itemid = ar.readInt();
            arrItemevilGrains= new  Vector.<StructEvilGrain2>();
            var evilGrainsLength:int = ar.readInt();
            for (var ievilGrains:int=0;ievilGrains<evilGrainsLength; ++ievilGrains)
            {
                var objEvilGrain:StructEvilGrain2 = new StructEvilGrain2();
                objEvilGrain.Deserialize(ar);
                arrItemevilGrains.push(objEvilGrain);
            }
            colorLvl = ar.readByte();
            soulLvl = ar.readByte();
            identify = ar.readByte();
            ruler = ar.readShort();
        }
    }
}
