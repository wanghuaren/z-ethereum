package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *宝石升级
    */
    public class PacketCSEvilGrainLevelUp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34007;
        /** 
        *0表示在装备上升级，此时需要装备位置和宝石槽位置,1表示直接升级合成,此时需要宝石id
        */
        public var flag:int;
        /** 
        *0:人 1，2，3伙伴
        */
        public var type:int;
        /** 
        *装备位置
        */
        public var equippos:int;
        /** 
        *宝石位置
        */
        public var evilgrainpos:int;
        /** 
        *宝石id
        */
        public var evilgrainid:int;
        /** 
        *元宝代替材料,0不花元宝，1花元宝
        */
        public var stuff_flag:int;
        /** 
        *成功率0不花元宝，1花元宝 废弃字段
        */
        public var success_flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
            ar.writeInt(type);
            ar.writeInt(equippos);
            ar.writeInt(evilgrainpos);
            ar.writeInt(evilgrainid);
            ar.writeInt(stuff_flag);
            ar.writeInt(success_flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
            type = ar.readInt();
            equippos = ar.readInt();
            evilgrainpos = ar.readInt();
            evilgrainid = ar.readInt();
            stuff_flag = ar.readInt();
            success_flag = ar.readInt();
        }
    }
}
