package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *通知玩家pk战准备开始
    */
    public class PacketSCPkReadyStart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20051;
        /** 
        *对手名称
        */
        public var oppname:String = new String();
        /** 
        *对手头像
        */
        public var oppicon:int;
        /** 
        *对手等级
        */
        public var opplevel:int;
        /** 
        *对手排名
        */
        public var oppranklevel:int;
        /** 
        *对手阵营
        */
        public var oppcamp:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, oppname, 32);
            ar.writeInt(oppicon);
            ar.writeInt(opplevel);
            ar.writeInt(oppranklevel);
            ar.writeInt(oppcamp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var oppnameLength:int = ar.readInt();
            oppname = ar.readMultiByte(oppnameLength,PacketFactory.Instance.GetCharSet());
            oppicon = ar.readInt();
            opplevel = ar.readInt();
            oppranklevel = ar.readInt();
            oppcamp = ar.readInt();
        }
    }
}
