package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructHundredSrvData2
    /** 
    *百服活动数据返回
    */
    public class PacketSCGetHundredSrvData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53803;
        /** 
        *百服数据
        */
        public var data:StructHundredSrvData2 = new StructHundredSrvData2();
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            data.Serialize(ar);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            data.Deserialize(ar);
            tag = ar.readInt();
        }
    }
}
