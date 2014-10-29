package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *反击列表增加
    */
    public class PacketSCBeatBackAdd implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14034;
        /** 
        *人物编号
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
