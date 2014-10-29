package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家gamble信息
    */
    public class StructServerPlayerPkGambleInfo implements ISerializable
    {
        /** 
        *场次
        */
        public var no:int;
        /** 
        *玩家名称
        */
        public var name:String = new String();
        /** 
        *比赛结果0未比赛 1 胜利 2 失败
        */
        public var iswin:int;
        /** 
        *赢得奖金
        */
        public var prize:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(no);
            PacketFactory.Instance.WriteString(ar, name, 32);
            ar.writeInt(iswin);
            ar.writeInt(prize);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            iswin = ar.readInt();
            prize = ar.readInt();
        }
    }
}
