package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *boss排行数据
    */
    public class StructRank_List implements ISerializable
    {
        /** 
        *玩家排名
        */
        public var rank_no:int;
        /** 
        *玩家伤害
        */
        public var damage:int;
        /** 
        *伤害百分比，万单位
        */
        public var per:int;
        /** 
        *玩家名称
        */
        public var name:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(rank_no);
            ar.writeInt(damage);
            ar.writeInt(per);
            PacketFactory.Instance.WriteString(ar, name, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            rank_no = ar.readInt();
            damage = ar.readInt();
            per = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
