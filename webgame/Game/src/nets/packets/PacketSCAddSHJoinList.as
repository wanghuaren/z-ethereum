package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSHJoinInfo2
    /** 
    *个人赛参赛列表增加
    */
    public class PacketSCAddSHJoinList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53011;
        /** 
        *总人数
        */
        public var total_num:int;
        /** 
        *参赛列表
        */
        public var joinlist:StructSHJoinInfo2 = new StructSHJoinInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(total_num);
            joinlist.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            total_num = ar.readInt();
            joinlist.Deserialize(ar);
        }
    }
}
