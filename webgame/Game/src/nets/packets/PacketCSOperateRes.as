package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *操作资源
    */
    public class PacketCSOperateRes implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14008;
        /** 
        *资源id
        */
        public var objid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
        }
    }
}
