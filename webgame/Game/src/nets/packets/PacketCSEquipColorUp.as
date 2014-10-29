package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备品质升级
    */
    public class PacketCSEquipColorUp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39100;
        /** 
        *0玩家 123伙伴
        */
        public var type:int;
        /** 
        *身上装备位置
        */
        public var pos:int;
        /** 
        *0不消耗元宝 1消耗元宝
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(pos);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            pos = ar.readInt();
            state = ar.readInt();
        }
    }
}
