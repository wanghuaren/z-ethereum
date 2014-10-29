package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备悬浮信息
    */
    public class PacketCSGetEquipTip implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8017;
        /** 
        *装备位置
        */
        public var pos:int;
        /** 
        *用户id
        */
        public var userid:int;
        /** 
        *类型:0 玩家 1 伙伴 2系统装备
        */
        public var type:int;
        /** 
        *0玩家 1 第一个宠物 2第二个宠物 3第三个宠物
        */
        public var wintype:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(userid);
            ar.writeInt(type);
            ar.writeInt(wintype);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            userid = ar.readInt();
            type = ar.readInt();
            wintype = ar.readInt();
        }
    }
}
