package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *镶嵌宝石
    */
    public class PacketCSEvilGrainSeal implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34003;
        /** 
        *0玩家123伙伴
        */
        public var pos:int;
        /** 
        *装备位置
        */
        public var equipPos:int;
        /** 
        *宝石类型ID
        */
        public var evilgrainid:int;
        /** 
        *第几个宝石槽 0:自动适配 1~5依次对应5个槽位
        */
        public var evilgrainDesPos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(equipPos);
            ar.writeInt(evilgrainid);
            ar.writeInt(evilgrainDesPos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            equipPos = ar.readInt();
            evilgrainid = ar.readInt();
            evilgrainDesPos = ar.readInt();
        }
    }
}
