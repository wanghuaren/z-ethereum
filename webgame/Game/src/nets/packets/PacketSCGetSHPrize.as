package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得个人赛比赛奖励返回
    */
    public class PacketSCGetSHPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53030;
        /** 
        *1 每日参与 2 挑战成就 3 每周排名
        */
        public var type:int;
        /** 
        *领取第几个奖励(1~3)
        */
        public var index:int;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(index);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            index = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
