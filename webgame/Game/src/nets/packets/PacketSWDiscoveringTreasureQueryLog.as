package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *全服寻宝史册
    */
    public class PacketSWDiscoveringTreasureQueryLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43211;
        /** 
        *账号ID
        */
        public var playerid:int;
        /** 
        *缓存版本号
        */
        public var version:int;
        /** 
        *拉取数量
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(playerid);
            ar.writeInt(version);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            playerid = ar.readInt();
            version = ar.readInt();
            num = ar.readInt();
        }
    }
}
