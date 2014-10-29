package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *斗战神数据数据
    */
    public class StructFFGInfo implements ISerializable
    {
        /** 
        *所需时间
        */
        public var time:int;
        /** 
        *玩家id
        */
        public var userid:int;
        /** 
        *玩家account
        */
        public var account:int;
        /** 
        *玩家名称
        */
        public var name:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(time);
            ar.writeInt(userid);
            ar.writeInt(account);
            PacketFactory.Instance.WriteString(ar, name, 50);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
            userid = ar.readInt();
            account = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
