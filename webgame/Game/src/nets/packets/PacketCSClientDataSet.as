package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructClientPara2
    /** 
    *设置客户端数据
    */
    public class PacketCSClientDataSet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 35103;
        /** 
        *参数数据
        */
        public var data:StructClientPara2 = new StructClientPara2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            data.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            data.Deserialize(ar);
        }
    }
}
