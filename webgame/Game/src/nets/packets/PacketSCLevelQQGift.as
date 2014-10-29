package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取等级QQ币奖励
    */
    public class PacketSCLevelQQGift implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38910;
        /** 
        *数量
        */
        public var num:int;
        /** 
        *开始时间
        */
        public var start_date:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(num);
            ar.writeInt(start_date);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
            start_date = ar.readInt();
        }
    }
}
