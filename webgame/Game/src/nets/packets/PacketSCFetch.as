package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取奖励
    */
    public class PacketSCFetch implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38902;
        /** 
        *类型
        */
        public var type:int;
        /** 
        *数据
        */
        public var data:int;
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
            ar.writeInt(type);
            ar.writeInt(data);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            data = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
