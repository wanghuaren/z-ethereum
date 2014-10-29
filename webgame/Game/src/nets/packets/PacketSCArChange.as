package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActRecInfo2
    /** 
    *成就变化
    */
    public class PacketSCArChange implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24001;
        /** 
        *成就id
        */
        public var info:StructActRecInfo2 = new StructActRecInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            info.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            info.Deserialize(ar);
        }
    }
}
