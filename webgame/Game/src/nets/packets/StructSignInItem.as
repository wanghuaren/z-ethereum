package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *签到抽奖物品列表
    */
    public class StructSignInItem implements ISerializable
    {
        /** 
        *物品id
        */
        public var itemid:int;
        /** 
        *个数
        */
        public var num:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itemid);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            num = ar.readInt();
        }
    }
}
