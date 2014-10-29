package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *物体离开视野
    */
    public class PacketSCObjLeaveGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1007;
        /** 
        *物体id
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
