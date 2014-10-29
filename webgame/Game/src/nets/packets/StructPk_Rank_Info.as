package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *pk排行数据
    */
    public class StructPk_Rank_Info implements ISerializable
    {
        /** 
        *玩家名次
        */
        public var rank_no:int;
        /** 
        *玩家id
        */
        public var userid:int;
        /** 
        *玩家名称
        */
        public var name:String = new String();
        /** 
        *玩家阵营
        */
        public var camp:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *积分
        */
        public var rank:int;
        /** 
        *最高连胜
        */
        public var max_win:int;
        /** 
        *regid
        */
        public var acc_id:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(rank_no);
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, name, 32);
            ar.writeInt(camp);
            ar.writeInt(metier);
            ar.writeInt(level);
            ar.writeInt(rank);
            ar.writeInt(max_win);
            ar.writeInt(acc_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            rank_no = ar.readInt();
            userid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            camp = ar.readInt();
            metier = ar.readInt();
            level = ar.readInt();
            rank = ar.readInt();
            max_win = ar.readInt();
            acc_id = ar.readInt();
        }
    }
}
