package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructShortKeyList2
    /** 
    *快捷键列表
    */
    public class PacketSCShortKeyList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8802;
        /** 
        *快捷键
        */
        public var items:StructShortKeyList2 = new StructShortKeyList2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            items.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            items.Deserialize(ar);
        }
    }
}
