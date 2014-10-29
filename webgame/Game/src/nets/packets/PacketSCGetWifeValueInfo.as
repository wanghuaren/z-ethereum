package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取当前玩家心缘值返回
    */
    public class PacketSCGetWifeValueInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54105;
        /** 
        *心缘值时间
        */
        public var wife_value:int;
        /** 
        *心缘等级
        */
        public var wife_level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(wife_value);
            ar.writeInt(wife_level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            wife_value = ar.readInt();
            wife_level = ar.readInt();
        }
    }
}
