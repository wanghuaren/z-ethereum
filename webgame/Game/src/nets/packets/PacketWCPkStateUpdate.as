package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家Pk状态更新
    */
    public class PacketWCPkStateUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20054;
        /** 
        *玩家id
        */
        public var userid:int;
        /** 
        *状态1 空闲 2战斗
        */
        public var state:int;
        /** 
        *玩家等级
        */
        public var level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
            ar.writeInt(state);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            state = ar.readInt();
            level = ar.readInt();
        }
    }
}
