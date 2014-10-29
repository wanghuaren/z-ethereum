package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *服务器列表
    */
    public class StructServerList implements ISerializable
    {
        /** 
        *ip地址
        */
        public var ip:String = new String();
        /** 
        *端口
        */
        public var port:int;
        /** 
        *服务器名称
        */
        public var servername:String = new String();
        /** 
        *游戏名称
        */
        public var gamename:String = new String();
        /** 
        *服务器ID
        */
        public var id:int;
        /** 
        *服务器状态
        */
        public var state:int;

        public function Serialize(ar:ByteArray):void
        {
            PacketFactory.Instance.WriteString(ar, ip, 32);
            ar.writeInt(port);
            PacketFactory.Instance.WriteString(ar, servername, 32);
            PacketFactory.Instance.WriteString(ar, gamename, 32);
            ar.writeInt(id);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var ipLength:int = ar.readInt();
            ip = ar.readMultiByte(ipLength,PacketFactory.Instance.GetCharSet());
            port = ar.readInt();
            var servernameLength:int = ar.readInt();
            servername = ar.readMultiByte(servernameLength,PacketFactory.Instance.GetCharSet());
            var gamenameLength:int = ar.readInt();
            gamename = ar.readMultiByte(gamenameLength,PacketFactory.Instance.GetCharSet());
            id = ar.readInt();
            state = ar.readInt();
        }
    }
}
