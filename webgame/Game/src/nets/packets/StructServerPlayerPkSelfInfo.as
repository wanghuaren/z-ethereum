package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家自己战绩信息
    */
    public class StructServerPlayerPkSelfInfo implements ISerializable
    {
        /** 
        *场次
        */
        public var no:int;
        /** 
        *对手玩家名称
        */
        public var oppname:String = new String();
        /** 
        *比赛结果0未比赛 1 胜利 2 失败
        */
        public var iswin:int;
        /** 
        *胜利场次
        */
        public var winnum:int;
        /** 
        *失败场次
        */
        public var lostnum:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(no);
            PacketFactory.Instance.WriteString(ar, oppname, 32);
            ar.writeInt(iswin);
            ar.writeInt(winnum);
            ar.writeInt(lostnum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            var oppnameLength:int = ar.readInt();
            oppname = ar.readMultiByte(oppnameLength,PacketFactory.Instance.GetCharSet());
            iswin = ar.readInt();
            winnum = ar.readInt();
            lostnum = ar.readInt();
        }
    }
}
