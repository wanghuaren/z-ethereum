package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCampRank2
    /** 
    *阵营排行榜数据返回
    */
    public class PacketSCCampRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29033;
        /** 
        *阵营数据
        */
        public var data:StructCampRank2 = new StructCampRank2();
        /** 
        *可否领取，0不可以领取，1可以领取
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            data.Serialize(ar);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            data.Deserialize(ar);
            flag = ar.readInt();
        }
    }
}
