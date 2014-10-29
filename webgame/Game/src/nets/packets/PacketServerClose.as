package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *服务器监视数据
    */
    public class PacketServerClose implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1102;
        /** 
        *服务器ID
        */
        public var serverid:int;
        /** 
        *操作代码1:关闭2.重启3.自动重启(serverid0:关1:开)4.启动5.获取服务器版本6.跟心版本7.启动一个新的场景服务器
        */
        public var op:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(serverid);
            ar.writeInt(op);
        }
        public function Deserialize(ar:ByteArray):void
        {
            serverid = ar.readInt();
            op = ar.readInt();
        }
    }
}
