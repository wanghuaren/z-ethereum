package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *战斗伤害结果
    */
    public class PacketSCFightDamage implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14005;
        /** 
        *攻击者id
        */
        public var srcid:int;
        /** 
        *攻击者的逻辑计数
        */
        public var logiccount:int;
        /** 
        *目标id
        */
        public var targetid:int;
        /** 
        *伤害值
        */
        public var damage:int;
        /** 
        *0表示普通伤害1表示暴击伤害
        */
        public var flag:int;
        /** 
        *目标血量
        */
        public var targethp:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(srcid);
            ar.writeInt(logiccount);
            ar.writeInt(targetid);
            ar.writeInt(damage);
            ar.writeInt(flag);
            ar.writeInt(targethp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            srcid = ar.readInt();
            logiccount = ar.readInt();
            targetid = ar.readInt();
            damage = ar.readInt();
            flag = ar.readInt();
            targethp = ar.readInt();
        }
    }
}
