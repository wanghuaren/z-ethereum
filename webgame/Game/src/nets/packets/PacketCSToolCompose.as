package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *道具合成
    */
    public class PacketCSToolCompose implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15049;
        /** 
        *合成ID
        */
        public var makeid:int;
        /** 
        *合成数量
        */
        public var count:int;
        /** 
        *标记 0:默认 1:装备合成 2:寻宝积分兑换
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(makeid);
            ar.writeInt(count);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            makeid = ar.readInt();
            count = ar.readInt();
            flag = ar.readInt();
        }
    }
}
