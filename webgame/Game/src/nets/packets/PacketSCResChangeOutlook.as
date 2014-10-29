package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *资源改变形象
    */
    public class PacketSCResChangeOutlook implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1012;
        /** 
        *资源id
        */
        public var objid:int;
        /** 
        *外观id
        */
        public var outlook:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(outlook);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            outlook = ar.readInt();
        }
    }
}
