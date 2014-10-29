package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *公会收益
    */
    public class PacketSWGuildActive implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39203;
        /** 
        *公会标示
        */
        public var guildid:int;
        /** 
        *工会繁荣度
        */
        public var active:int;
        /** 
        *工会资金
        */
        public var money:int;
        /** 
        *工会屠龙点
        */
        public var fightpoint:int;
        /** 
        *type
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(active);
            ar.writeInt(money);
            ar.writeInt(fightpoint);
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            active = ar.readInt();
            money = ar.readInt();
            fightpoint = ar.readInt();
            type = ar.readInt();
        }
    }
}
