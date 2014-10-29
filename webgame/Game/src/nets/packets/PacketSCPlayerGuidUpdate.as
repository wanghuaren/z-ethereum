package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备强化石合成
    */
    public class PacketSCPlayerGuidUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15026;
        /** 
        *引导信息
        */
        public var data:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(data);
        }
        public function Deserialize(ar:ByteArray):void
        {
            data = ar.readInt();
        }
    }
}
