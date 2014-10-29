package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *宝石升级
    */
    public class PacketSCEvilGrainLevelUp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34008;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *成功标志，0表示失败，否则为合成成功后的宝石id
        */
        public var success:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(success);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            success = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
