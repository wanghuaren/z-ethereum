package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取邀请抽奖数据
    */
    public class PacketSWInviteAwardData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37024;
        /** 
        *当前奖励
        */
        public var itemid:int;
        /** 
        *当前奖励数量
        */
        public var itemnum:int;
        /** 
        *是否抽取过奖励没有,0没有，1抽取过
        */
        public var isdraw:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
            ar.writeInt(itemnum);
            ar.writeInt(isdraw);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            itemnum = ar.readInt();
            isdraw = ar.readInt();
        }
    }
}
