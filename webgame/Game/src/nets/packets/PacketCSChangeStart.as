package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *调整进入方式
    */
    public class PacketCSChangeStart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20011;
        /** 
        *报名id
        */
        public var signid:int;
        /** 
        *报名id 0-3人进入 1-4人进入 2-5人进入 3-手动进入
        */
        public var entrytype:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(signid);
            ar.writeInt(entrytype);
        }
        public function Deserialize(ar:ByteArray):void
        {
            signid = ar.readInt();
            entrytype = ar.readInt();
        }
    }
}
