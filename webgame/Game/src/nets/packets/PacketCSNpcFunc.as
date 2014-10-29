package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *NPC功能调用
    */
    public class PacketCSNpcFunc implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 7002;
        /** 
        *对话ID
        */
        public var talk_id:int;
        /** 
        *对话索引
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(talk_id);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            talk_id = ar.readInt();
            index = ar.readInt();
        }
    }
}
