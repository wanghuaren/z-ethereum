package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *活动结束后结果信息
    */
    public class PacketWCActEndResult implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20078;
        /** 
        *类型 1 Pk  2 金戈铁马 3 门派秘宝
        */
        public var type:int;
        /** 
        *获得金币
        */
        public var coin:int;
        /** 
        *获得声望
        */
        public var renown:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(coin);
            ar.writeInt(renown);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            coin = ar.readInt();
            renown = ar.readInt();
        }
    }
}
