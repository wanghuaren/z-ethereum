package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildBossPlayerList2
    /** 
    *家族boss伤害列表(从高到低排序)
    */
    public class PacketSCGuildBossPlayerList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51402;
        /** 
        *玩家信息
        */
        public var playerlist:StructGuildBossPlayerList2 = new StructGuildBossPlayerList2();
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
            playerlist.Serialize(ar);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            playerlist.Deserialize(ar);
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
