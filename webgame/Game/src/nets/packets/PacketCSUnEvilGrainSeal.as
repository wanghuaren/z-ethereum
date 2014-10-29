package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *摘除宝石
    */
    public class PacketCSUnEvilGrainSeal implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34005;
        /** 
        *0玩家123伙伴
        */
        public var pos:int;
        /** 
        *装备位置
        */
        public var equipPos:int;
        /** 
        *第几个宝石槽 脚标从1开始
        */
        public var evilgrainDesPos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(equipPos);
            ar.writeInt(evilgrainDesPos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            equipPos = ar.readInt();
            evilgrainDesPos = ar.readInt();
        }
    }
}
