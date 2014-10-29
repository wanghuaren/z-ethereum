package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *家族树操作
    */
    public class PacketCSGuildTreeOp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39232;
        /** 
        *家族
        */
        public var guildid:int;
        /** 
        *操作0:浇水1:施肥2:除虫
        */
        public var treeop:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(treeop);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            treeop = ar.readInt();
        }
    }
}
