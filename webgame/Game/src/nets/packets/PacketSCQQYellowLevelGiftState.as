package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取QQ黄钻等级礼包领取状态返回
    */
    public class PacketSCQQYellowLevelGiftState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38908;
        /** 
        *从最后一位开始，位的状态代表该序号对应的等级礼包领取状态，1为已领取
        */
        public var status:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(status);
        }
        public function Deserialize(ar:ByteArray):void
        {
            status = ar.readInt();
        }
    }
}
