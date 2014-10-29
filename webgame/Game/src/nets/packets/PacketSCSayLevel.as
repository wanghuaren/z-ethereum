package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *同步聊天等级
    */
    public class PacketSCSayLevel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10027;
        /** 
        *世界聊天等级
        */
        public var world_level:int;
        /** 
        *场景聊天等级
        */
        public var map_level:int;
        /** 
        *交易聊天等级
        */
        public var camp_level:int;
        /** 
        *私人聊天等级
        */
        public var private_level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(world_level);
            ar.writeInt(map_level);
            ar.writeInt(camp_level);
            ar.writeInt(private_level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            world_level = ar.readInt();
            map_level = ar.readInt();
            camp_level = ar.readInt();
            private_level = ar.readInt();
        }
    }
}
