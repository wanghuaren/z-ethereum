package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *附近队伍信息
    */
    public class PacketCSTeamDesc implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18021;
        /** 
        *第几页
        */
        public var page:int;
        /** 
        *只显示未满队伍，1只显示，0都显示
        */
        public var notfull:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(page);
            ar.writeInt(notfull);
        }
        public function Deserialize(ar:ByteArray):void
        {
            page = ar.readInt();
            notfull = ar.readInt();
        }
    }
}
