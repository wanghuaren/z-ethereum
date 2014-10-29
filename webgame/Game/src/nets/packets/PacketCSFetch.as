package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取奖励
    */
    public class PacketCSFetch implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38901;
        /** 
        *类型 1:升级奖励
        */
        public var type:int;
        /** 
        *数据
        */
        public var data:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(data);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            data = ar.readInt();
        }
    }
}
