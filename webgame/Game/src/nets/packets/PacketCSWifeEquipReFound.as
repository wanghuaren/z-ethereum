package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *心缘洗属性
    */
    public class PacketCSWifeEquipReFound implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54112;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *0:洗属性 1:洗值
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
