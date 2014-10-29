package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设定玩家接受的pk信息
    */
    public class PacketCWSetPkUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20049;
        /** 
        *接受信息的类型 1 玩家pk信息 战报信息 2 阵营积分信息 3 阵营报名信息
        */
        public var sort:int;
        /** 
        *设定是否接收信息 1 接收 2 关闭接收
        */
        public var value:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sort);
            ar.writeInt(value);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
            value = ar.readInt();
        }
    }
}
