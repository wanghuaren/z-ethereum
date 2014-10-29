package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *服务器爬塔数据更新
    */
    public class PacketSCServerTowerUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 41010;
        /** 
        *死亡次数
        */
        public var dead:int;
        /** 
        *杀人数
        */
        public var kill:int;
        /** 
        *剩余时间
        */
        public var last_time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(dead);
            ar.writeInt(kill);
            ar.writeInt(last_time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            dead = ar.readInt();
            kill = ar.readInt();
            last_time = ar.readInt();
        }
    }
}
