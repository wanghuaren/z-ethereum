package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *炼丹
    */
    public class PacketCSComposepill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 22000;
        /** 
        *炼方id
        */
        public var toolid:int;
        /** 
        *是否损耗元宝
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(toolid);
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            toolid = ar.readInt();
            type = ar.readInt();
        }
    }
}
