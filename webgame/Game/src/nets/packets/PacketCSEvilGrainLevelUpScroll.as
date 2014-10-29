package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *魔纹卷轴升级
    */
    public class PacketCSEvilGrainLevelUpScroll implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34009;
        /** 
        *魔纹id
        */
        public var itemid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
        }
    }
}
