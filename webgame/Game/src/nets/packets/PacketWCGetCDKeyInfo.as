package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCDKeyList2
    /** 
    *获取新手卡信息
    */
    public class PacketWCGetCDKeyInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43103;
        /** 
        *新手卡信息
        */
        public var cdkeyinfo:StructCDKeyList2 = new StructCDKeyList2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            cdkeyinfo.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            cdkeyinfo.Deserialize(ar);
        }
    }
}
