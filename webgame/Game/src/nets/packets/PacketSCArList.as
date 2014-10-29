package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActInfo2
    /** 
    *获取成就列表返回
    */
    public class PacketSCArList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24003;
        /** 
        *成就信息
        */
        public var actlist:StructActInfo2 = new StructActInfo2();
        /** 
        *成就排行
        */
        public var rank:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            actlist.Serialize(ar);
            ar.writeInt(rank);
        }
        public function Deserialize(ar:ByteArray):void
        {
            actlist.Deserialize(ar);
            rank = ar.readInt();
        }
    }
}
