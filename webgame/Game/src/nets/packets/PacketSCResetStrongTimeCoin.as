package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *请求消除冷却时间所花元宝
    */
    public class PacketSCResetStrongTimeCoin implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15008;
        /** 
        *槽位置
        */
        public var pos:int;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *花多少元宝
        */
        public var coin:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(tag);
            ar.writeInt(coin);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            tag = ar.readInt();
            coin = ar.readInt();
        }
    }
}
