package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *背包消息提示
    */
    public class PacketSCBagMessage implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8019;
        /** 
        *
        */
        public var tag:int;
        /** 
        *
        */
        public var msg:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(msg);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            msg = ar.readInt();
        }
    }
}
