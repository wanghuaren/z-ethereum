package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *心缘属性激活
    */
    public class PacketCSWifeEquipAttrActive implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54114;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *第几条属性
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            index = ar.readInt();
        }
    }
}
