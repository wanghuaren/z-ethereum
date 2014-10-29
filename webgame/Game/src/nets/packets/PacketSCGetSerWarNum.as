package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得当前大海战等待人数返回
    */
    public class PacketSCGetSerWarNum implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 42004;
        /** 
        *大海战等待人数
        */
        public var waitnum:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(waitnum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            waitnum = ar.readInt();
        }
    }
}
