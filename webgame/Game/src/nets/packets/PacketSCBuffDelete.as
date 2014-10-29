package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *人物/怪物的buff消失
    */
    public class PacketSCBuffDelete implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14027;
        /** 
        *人物/怪物编号
        */
        public var objid:int;
        /** 
        *buff序号
        */
        public var buffsn:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(buffsn);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            buffsn = ar.readInt();
        }
    }
}
