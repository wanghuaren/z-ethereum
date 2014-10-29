package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取剑灵状态
    */
    public class PacketSCGetBladeState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 12102;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *剑灵值
        */
        public var blade_value:int;
        /** 
        *当前剑灵,0:没有剑灵
        */
        public var npc_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(blade_value);
            ar.writeInt(npc_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            blade_value = ar.readInt();
            npc_id = ar.readInt();
        }
    }
}
