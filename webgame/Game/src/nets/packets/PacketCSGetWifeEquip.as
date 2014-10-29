package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *激活心缘装备
    */
    public class PacketCSGetWifeEquip implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54108;
        /** 
        *心缘位置 1 开始
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
        }
    }
}
