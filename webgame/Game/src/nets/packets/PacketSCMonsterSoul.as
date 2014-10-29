package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *打怪获得魂点
    */
    public class PacketSCMonsterSoul implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14030;
        /** 
        *人物编号
        */
        public var objid:int;
        /** 
        *怪物编号
        */
        public var monsterid:int;
        /** 
        *获得的魂点
        */
        public var soul:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(monsterid);
            ar.writeInt(soul);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            monsterid = ar.readInt();
            soul = ar.readInt();
        }
    }
}
