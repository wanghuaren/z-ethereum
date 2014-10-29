package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *取得角色附近玩家列表
    */
    public class PacketCSPlayerGetGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1004;
        /** 
        *只显示未组队玩家，1只显示，0不显示，2表示好友附近玩家请求
        */
        public var noteam:int;
        /** 
        *第几页
        */
        public var page:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(noteam);
            ar.writeInt(page);
        }
        public function Deserialize(ar:ByteArray):void
        {
            noteam = ar.readInt();
            page = ar.readInt();
        }
    }
}
