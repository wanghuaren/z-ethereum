package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSignList2
    /** 
    *玩家副本报名数据更新
    */
    public class PacketSCPlayerListUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20016;
        /** 
        *报名信息
        */
        public var signlist:StructSignList2 = new StructSignList2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            signlist.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            signlist.Deserialize(ar);
        }
    }
}
