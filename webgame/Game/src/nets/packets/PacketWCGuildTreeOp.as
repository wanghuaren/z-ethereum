package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *家族树操作
    */
    public class PacketWCGuildTreeOp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39233;
        /** 
        *操作0:浇水1:施肥2:除虫
        */
        public var treeop:int;
        /** 
        *操作次数
        */
        public var optimes:int;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(treeop);
            ar.writeInt(optimes);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            treeop = ar.readInt();
            optimes = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
