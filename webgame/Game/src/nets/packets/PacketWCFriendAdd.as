package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructFriendData2
    /** 
    *添加好友
    */
    public class PacketWCFriendAdd implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3008;
        /** 
        *角色ID
        */
        public var newfriend:StructFriendData2 = new StructFriendData2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            newfriend.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            newfriend.Deserialize(ar);
        }
    }
}
