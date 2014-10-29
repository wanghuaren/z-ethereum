package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *至尊VIP信息返回
    */
    public class PacketSCGetVipLevelData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53601;
        /** 
        *至尊VIP等级
        */
        public var level:int;
        /** 
        *已充元宝数
        */
        public var curCoin3:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(level);
            ar.writeInt(curCoin3);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            level = ar.readInt();
            curCoin3 = ar.readInt();
            tag = ar.readInt();
        }
    }
}
