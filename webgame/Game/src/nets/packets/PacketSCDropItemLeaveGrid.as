package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *掉落物品消失
    */
    public class PacketSCDropItemLeaveGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1010;
        /** 
        *掉落id
        */
        public var objid:int;
        /** 
        *掉落列表索引
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            index = ar.readInt();
        }
    }
}
