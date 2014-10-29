package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *技能目标
    */
    public class StructTargetList implements ISerializable
    {
        /** 
        *目标id
        */
        public var objid:int;
        /** 
        *是否产生了伤害,0表示miss,1表示普通伤害
        */
        public var flag:int;
        /** 
        *伤害值
        */
        public var damage:int;
        /** 
        *0表示普通伤害1表示暴击伤害2表示格挡
        */
        public var damage_flag:int;
        /** 
        *目标血量
        */
        public var targethp:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(objid);
            ar.writeInt(flag);
            ar.writeInt(damage);
            ar.writeInt(damage_flag);
            ar.writeInt(targethp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            flag = ar.readInt();
            damage = ar.readInt();
            damage_flag = ar.readInt();
            targethp = ar.readInt();
        }
    }
}
