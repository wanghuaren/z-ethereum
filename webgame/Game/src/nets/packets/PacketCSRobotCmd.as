package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *机器人命令
    */
    public class PacketCSRobotCmd implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1021;
        /** 
        *命令字符串
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, msg, 50);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
