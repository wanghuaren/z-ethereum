package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *刷新美人
    */
    public class PacketCSRefleshBeauty implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39910;
        /** 
        *刷新id
        */
        public var beautyid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(beautyid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            beautyid = ar.readInt();
        }
    }
}
