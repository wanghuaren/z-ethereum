package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *强化
    */
    public class PacketSCEquipStrong implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15002;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();
        /** 
        *装备强化级别
        */
        public var stronglevel:int;
        /** 
        *战力值
        */
        public var fightValue:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
            ar.writeInt(stronglevel);
            ar.writeInt(fightValue);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            stronglevel = ar.readInt();
            fightValue = ar.readInt();
        }
    }
}
