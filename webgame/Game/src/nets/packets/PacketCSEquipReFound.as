package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *重铸
    */
    public class PacketCSEquipReFound implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15012;
        /** 
        *类型(0:角色，1:伙伴)
        */
        public var type:int;
        /** 
        *哪一个伙伴
        */
        public var pet:int;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *是否高级重铸(1是高级)
        */
        public var flag:int;
        /** 
        *锁定的属性
        */
        public var arrItemattritems:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(pet);
            ar.writeInt(pos);
            ar.writeInt(flag);
            ar.writeInt(arrItemattritems.length);
            for each (var attritemsitem:int in arrItemattritems)
            {
                ar.writeInt(attritemsitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            pet = ar.readInt();
            pos = ar.readInt();
            flag = ar.readInt();
            arrItemattritems= new  Vector.<int>();
            var attritemsLength:int = ar.readInt();
            for (var iattritems:int=0;iattritems<attritemsLength; ++iattritems)
            {
                arrItemattritems.push(ar.readInt());
            }
        }
    }
}
