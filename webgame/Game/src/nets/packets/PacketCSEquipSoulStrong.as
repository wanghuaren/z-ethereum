package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *噬魂
    */
    public class PacketCSEquipSoulStrong implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15031;
        /** 
        *魂位置 1:妖魂 2:魔魂 3:神魂
        */
        public var soul_pos:int;
        /** 
        *类型(0:角色，1~3:伙伴)
        */
        public var type:int;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *元宝替代道具 0:不代替 1:代替
        */
        public var is_usecoin:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(soul_pos);
            ar.writeInt(type);
            ar.writeInt(pos);
            ar.writeInt(is_usecoin);
        }
        public function Deserialize(ar:ByteArray):void
        {
            soul_pos = ar.readInt();
            type = ar.readInt();
            pos = ar.readInt();
            is_usecoin = ar.readInt();
        }
    }
}
