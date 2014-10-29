package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *强化退级
    */
    public class PacketCSEquipStrongBack implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15020;
        /** 
        *类型(0:角色，1~3:伙伴)
        */
        public var type:int;
        /** 
        *位置
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            pos = ar.readInt();
        }
    }
}
