package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *家族boss玩家信息
    */
    public class StructGuildBossPlayerInfo implements ISerializable
    {
        /** 
        *玩家id
        */
        public var userid:int;
        /** 
        *玩家名称
        */
        public var name:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, name, 50);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
