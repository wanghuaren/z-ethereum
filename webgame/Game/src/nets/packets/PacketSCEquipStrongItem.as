package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *单个强化槽信息
    */
    public class PacketSCEquipStrongItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15011;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *状态
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            state = ar.readInt();
        }
    }
}
