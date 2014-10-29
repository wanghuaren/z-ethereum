package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructFriendData2
    /** 
    *好友更新
    */
    public class PacketWCFriendUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3002;
        /** 
        *好友数据
        */
        public var frienddata:StructFriendData2 = new StructFriendData2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            frienddata.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            frienddata.Deserialize(ar);
        }
    }
}
