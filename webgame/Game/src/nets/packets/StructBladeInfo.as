package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *剑灵信息
    */
    public class StructBladeInfo implements ISerializable
    {
        /** 
        *剑灵编号
        */
        public var npc_id:int;
        /** 
        *当前血量
        */
        public var hp:int;
        /** 
        *死亡次数
        */
        public var dietimes:int;
        /** 
        *剩余时间
        */
        public var leftTime:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(npc_id);
            ar.writeInt(hp);
            ar.writeInt(dietimes);
            ar.writeInt(leftTime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            npc_id = ar.readInt();
            hp = ar.readInt();
            dietimes = ar.readInt();
            leftTime = ar.readInt();
        }
    }
}
