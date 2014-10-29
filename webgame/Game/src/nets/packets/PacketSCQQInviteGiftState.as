package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取QQ邀请领取状态返回
    */
    public class PacketSCQQInviteGiftState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38916;
        /** 
        *从最后一位开始，位的状态代表该序号对应的礼包领取状态，1为已领取，0为未领取
        */
        public var status:int;
        /** 
        *从最后一位开始，位的状态代表该序号对应的礼包能否领取状态，1为能领取，0为不能领取
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(status);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            status = ar.readInt();
            flag = ar.readInt();
        }
    }
}
