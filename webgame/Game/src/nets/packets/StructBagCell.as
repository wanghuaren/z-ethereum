package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructEvilGrain2
    /** 
    *背包格
    */
    public class StructBagCell implements ISerializable
    {
        /** 
        *物品ID
        */
        public var itemid:int;
        /** 
        *物品位置
        */
        public var pos:int;
        /** 
        *当前数量
        */
        public var num:int;
        /** 
        *物品规则
        */
        public var ruler:int;
        /** 
        *itemid是 装备：表示强化等级，星魂：表示能量, 使用次数物品：表示剩余次数
        */
        public var para:int;
        /** 
        *强化失败次数
        */
        public var strongFailed:int;
        /** 
        *物品存在时间0.没有时间限制
        */
        public var exist_time:int;
        /** 
        *战力值
        */
        public var equip_fightValue:int;
        /** 
        *神品品阶
        */
        public var colorLvl:int;
        /** 
        *噬魂属性等级
        */
        public var soulLvl:int;
        /** 
        *是否鉴定 0:未鉴定 1:已鉴定
        */
        public var identify:int;
        /** 
        *附加属性
        */
        public var arrItemattrs:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *噬魂属性
        */
        public var arrItemsoulAttrs:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *魔纹数据
        */
        public var arrItemevilGrains:Vector.<StructEvilGrain2> = new Vector.<StructEvilGrain2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itemid);
            ar.writeInt(pos);
            ar.writeInt(num);
            ar.writeShort(ruler);
            ar.writeInt(para);
            ar.writeInt(strongFailed);
            ar.writeInt(exist_time);
            ar.writeInt(equip_fightValue);
            ar.writeByte(colorLvl);
            ar.writeByte(soulLvl);
            ar.writeByte(identify);
            ar.writeInt(arrItemattrs.length);
            for each (var attrsitem:Object in arrItemattrs)
            {
                var objattrs:ISerializable = attrsitem as ISerializable;
                if (null!=objattrs)
                {
                    objattrs.Serialize(ar);
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
            ar.writeInt(arrItemevilGrains.length);
            for each (var evilGrainsitem:Object in arrItemevilGrains)
            {
                var objevilGrains:ISerializable = evilGrainsitem as ISerializable;
                if (null!=objevilGrains)
                {
                    objevilGrains.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            pos = ar.readInt();
            num = ar.readInt();
            ruler = ar.readShort();
            para = ar.readInt();
            strongFailed = ar.readInt();
            exist_time = ar.readInt();
            equip_fightValue = ar.readInt();
            colorLvl = ar.readByte();
            soulLvl = ar.readByte();
            identify = ar.readByte();
            arrItemattrs= new  Vector.<StructItemAttr2>();
            var attrsLength:int = ar.readInt();
            for (var iattrs:int=0;iattrs<attrsLength; ++iattrs)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemattrs.push(objItemAttr);
            }
            arrItemsoulAttrs= new  Vector.<StructItemAttr2>();
            var soulAttrsLength:int = ar.readInt();
            for (var isoulAttrs:int=0;isoulAttrs<soulAttrsLength; ++isoulAttrs)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemsoulAttrs.push(objItemAttr);
            }
            arrItemevilGrains= new  Vector.<StructEvilGrain2>();
            var evilGrainsLength:int = ar.readInt();
            for (var ievilGrains:int=0;ievilGrains<evilGrainsLength; ++ievilGrains)
            {
                var objEvilGrain:StructEvilGrain2 = new StructEvilGrain2();
                objEvilGrain.Deserialize(ar);
                arrItemevilGrains.push(objEvilGrain);
            }
        }
    }
}
