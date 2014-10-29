package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置显示称号返回
    */
    public class PacketSCDisplayTitleSet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 35106;
        /** 
        *称号id
        */
        public var title:int;
        /** 
        *flag,1为装备，0为卸下
        */
        public var flag:int;
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
            ar.writeInt(title);
            ar.writeInt(flag);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            title = ar.readInt();
            flag = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
