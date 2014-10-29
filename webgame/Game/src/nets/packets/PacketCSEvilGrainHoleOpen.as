package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备开洞
    */
    public class PacketCSEvilGrainHoleOpen implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34011;
        /** 
        *0玩家123伙伴
        */
        public var type:int;
        /** 
        *装备位置
        */
        public var pos:int;
        /** 
        *魔纹在背包中的位置
        */
        public var hole_index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(pos);
            ar.writeInt(hole_index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            pos = ar.readInt();
            hole_index = ar.readInt();
        }
    }
}
