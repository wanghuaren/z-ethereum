package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructLimitInfo2
    /** 
    *限制数据更新
    */
    public class PacketSCLimitUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24303;
        /** 
        *限制id数据
        */
        public var limitinfo:StructLimitInfo2 = new StructLimitInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            limitinfo.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            limitinfo.Deserialize(ar);
        }
    }
}
