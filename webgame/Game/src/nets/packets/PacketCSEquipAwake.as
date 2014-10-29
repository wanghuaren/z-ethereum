package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备觉醒
    */
    public class PacketCSEquipAwake implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15041;
        /** 
        *类型(0:角色，1~3:伙伴)
        */
        public var type:int;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *是否元宝替代道具 0:不代替 1:代替
        */
        public var is_usecoin:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(pos);
            ar.writeInt(is_usecoin);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            pos = ar.readInt();
            is_usecoin = ar.readInt();
        }
    }
}
