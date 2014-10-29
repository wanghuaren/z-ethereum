package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取开服礼包状态
    */
    public class PacketSCGetStartPrizeState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31106;
        /** 
        *返回结果
        */
        public var tag:int;
        /** 
        *当前状态
        */
        public var id1:int;
        /** 
        *当前状态
        */
        public var id2:int;
        /** 
        *当前状态
        */
        public var id3:int;
        /** 
        *当前状态
        */
        public var id4:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(id1);
            ar.writeInt(id2);
            ar.writeInt(id3);
            ar.writeInt(id4);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            id1 = ar.readInt();
            id2 = ar.readInt();
            id3 = ar.readInt();
            id4 = ar.readInt();
        }
    }
}
