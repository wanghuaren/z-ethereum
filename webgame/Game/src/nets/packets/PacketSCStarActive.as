package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *境界激活
    */
    public class PacketSCStarActive implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 27009;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *当前编号
        */
        public var star_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(star_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            star_id = ar.readInt();
        }
    }
}
