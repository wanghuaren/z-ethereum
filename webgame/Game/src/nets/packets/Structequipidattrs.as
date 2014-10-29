package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructItemAttr2
    import netc.packets2.StructEvilGrain2
    /** 
    *装备id和附加属性
    */
    public class Structequipidattrs implements ISerializable
    {
        /** 
        *物品id
        */
        public var equipid:int;
        /** 
        *如果是装备：代表强化等级 ，星魂：代表经验
        */
        public var strongLevel:int;
        /** 
        *装备强化失败次数
        */
        public var strongFailed:int;
        /** 
        *战力值
        */
        public var fightValue:int;
        /** 
        *所有附加属性
        */
        public var arrItemequipattrs:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
        /** 
        *装备噬魂属性
        */
        public var arrItemsoulAttrs:Vector.<StructItemAttr2> = new Vector.<StructItemAttr2>();
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
            ar.writeInt(equipid);
            ar.writeInt(strongLevel);
            ar.writeInt(strongFailed);
            ar.writeInt(fightValue);
            ar.writeInt(arrItemequipattrs.length);
            for each (var equipattrsitem:Object in arrItemequipattrs)
            {
                var objequipattrs:ISerializable = equipattrsitem as ISerializable;
                if (null!=objequipattrs)
                {
                    objequipattrs.Serialize(ar);
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
            ar.writeByte(colorLvl);
            ar.writeByte(soulLvl);
            ar.writeByte(identify);
            ar.writeShort(ruler);
        }
        public function Deserialize(ar:ByteArray):void
        {
            equipid = ar.readInt();
            strongLevel = ar.readInt();
            strongFailed = ar.readInt();
            fightValue = ar.readInt();
            arrItemequipattrs= new  Vector.<StructItemAttr2>();
            var equipattrsLength:int = ar.readInt();
            for (var iequipattrs:int=0;iequipattrs<equipattrsLength; ++iequipattrs)
            {
                var objItemAttr:StructItemAttr2 = new StructItemAttr2();
                objItemAttr.Deserialize(ar);
                arrItemequipattrs.push(objItemAttr);
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
            colorLvl = ar.readByte();
            soulLvl = ar.readByte();
            identify = ar.readByte();
            ruler = ar.readShort();
        }
    }
}
