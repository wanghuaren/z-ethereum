package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取镇魔谷经验值
    */
    public class PacketSCDevilGetValue implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 55202;
        /** 
        *value1
        */
        public var value1:int;
        /** 
        *value2
        */
        public var value2:int;
        /** 
        *value3
        */
        public var value3:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(value1);
            ar.writeInt(value2);
            ar.writeInt(value3);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            value1 = ar.readInt();
            value2 = ar.readInt();
            value3 = ar.readInt();
            tag = ar.readInt();
        }
    }
}
