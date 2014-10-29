package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPlayerInfo2
    /** 
    *角色进入视野
    */
    public class PacketSCPlayerEnterGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1006;
        /** 
        *角色信息
        */
        public var playerinfo:StructPlayerInfo2 = new StructPlayerInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            playerinfo.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            playerinfo.Deserialize(ar);
        }
    }
}
