package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructEvilGrain2
    /** 
    *装备信息
    */
    public class StructEquipData implements ISerializable
    {
        /** 
        *物品位置
        */
        public var itempos:int;
        /** 
        *物品类型
        */
        public var itemType:int;
        /** 
        *物品规则
        */
        public var itemRuler:int;
        /** 
        *绑定
        */
        public var bindValue:int;
        /** 
        *过期时间
        */
        public var existtime:int;
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
        public var fightvalue:int;
        /** 
        *属性信息
        */
        public var arrItemattrArray:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *噬魂属性信息
        */
        public var arrItemsoulAttrArray:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *魔纹信息
        */
        public var arrItemevilGrains:Vector.<StructEvilGrain2> = new Vector.<StructEvilGrain2>();
        /** 
        *橙装品阶
        */
        public var colorLvl:int;
        /** 
        *噬魂属性等级
        */
        public var soulLvl:int;
        /** 
        *投保次数
        */
        public var antiDropCnt:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itempos);
            ar.writeInt(itemType);
            ar.writeShort(itemRuler);
            ar.writeByte(bindValue);
            ar.writeInt(existtime);
            ar.writeInt(strongLevel);
            ar.writeInt(strongFailed);
            ar.writeInt(curDurPoint);
            ar.writeInt(fightvalue);
            ar.writeInt(arrItemattrArray.length);
            for each (var attrArrayitem:Object in arrItemattrArray)
            {
                var objattrArray:ISerializable = attrArrayitem as ISerializable;
                if (null!=objattrArray)
                {
                    objattrArray.Serialize(ar);
                }
            }
            ar.writeInt(arrItemsoulAttrArray.length);
            for each (var soulAttrArrayitem:Object in arrItemsoulAttrArray)
            {
                var objsoulAttrArray:ISerializable = soulAttrArrayitem as ISerializable;
                if (null!=objsoulAttrArray)
                {
                    objsoulAttrArray.Serialize(ar);
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
            ar.writeByte(colorLvl);
            ar.writeByte(soulLvl);
            ar.writeByte(antiDropCnt);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itempos = ar.readInt();
            itemType = ar.readInt();
            itemRuler = ar.readShort();
            bindValue = ar.readByte();
            existtime = ar.readInt();
            strongLevel = ar.readInt();
            strongFailed = ar.readInt();
            curDurPoint = ar.readInt();
            fightvalue = ar.readInt();
            arrItemattrArray= new  Vector.<StructItemAttr2>();
            var attrArrayLength:int = ar.readInt();
            for (var iattrArray:int=0;iattrArray<attrArrayLength; ++iattrArray)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemattrArray.push(objItemAttr);
            }
            arrItemsoulAttrArray= new  Vector.<StructItemAttr2>();
            var soulAttrArrayLength:int = ar.readInt();
            for (var isoulAttrArray:int=0;isoulAttrArray<soulAttrArrayLength; ++isoulAttrArray)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemsoulAttrArray.push(objItemAttr);
            }
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
            antiDropCnt = ar.readByte();
        }
    }
}
