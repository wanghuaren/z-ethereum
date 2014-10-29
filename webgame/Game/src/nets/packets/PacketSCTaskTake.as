package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *任务领取
    */
    public class PacketSCTaskTake implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6007;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *消息
        */
        public var msg:String = new String();
        /** 
        *自动寻路npc
        */
        public var npc_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
            ar.writeInt(npc_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            npc_id = ar.readInt();
        }
    }
}
