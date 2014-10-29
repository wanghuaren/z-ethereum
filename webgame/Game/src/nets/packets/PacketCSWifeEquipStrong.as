package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *心缘炼化
    */
    public class PacketCSWifeEquipStrong implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54110;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *元宝替代材料 0:不代替 1:代替
        */
        public var is_usecoin:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(is_usecoin);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            is_usecoin = ar.readInt();
        }
    }
}
