package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家死亡
    */
    public class PacketSCDie implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14035;
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
