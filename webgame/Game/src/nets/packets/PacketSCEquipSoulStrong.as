package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *噬魂
    */
    public class PacketSCEquipSoulStrong implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15032;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();
        /** 
        *装备魂级别
        */
        public var stronglevel:int;
        /** 
        *魂位置 1:妖魂 2:魔魂 3:神魂
        */
        public var soul_pos:int;
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
            ar.writeInt(soul_pos);
            ar.writeInt(fightValue);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            stronglevel = ar.readInt();
            soul_pos = ar.readInt();
            fightValue = ar.readInt();
        }
    }
}
