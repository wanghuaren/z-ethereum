package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *快捷键列表
    */
    public class PacketSCShortKeyItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8804;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *技能或物品id
        */
        public var objid:int;
        /** 
        *0:技能 1:物品
        */
        public var objtype:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(objid);
            ar.writeInt(objtype);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            objid = ar.readInt();
            objtype = ar.readInt();
        }
    }
}
