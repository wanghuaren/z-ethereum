package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *脱装备
    */
    public class PacketCSUnEquipItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8011;
        /** 
        *源位置
        */
        public var srcindex:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(srcindex);
        }
        public function Deserialize(ar:ByteArray):void
        {
            srcindex = ar.readInt();
        }
    }
}
