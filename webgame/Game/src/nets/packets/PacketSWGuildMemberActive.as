package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *公会个人收益
    */
    public class PacketSWGuildMemberActive implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39214;
        /** 
        *公会标示
        */
        public var guildid:int;
        /** 
        *个人威望
        */
        public var cachet:int;
        /** 
        *个人帮贡
        */
        public var contribute:int;
        /** 
        *type
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(cachet);
            ar.writeInt(contribute);
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            cachet = ar.readInt();
            contribute = ar.readInt();
            type = ar.readInt();
        }
    }
}
