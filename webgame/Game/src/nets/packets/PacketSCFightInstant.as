package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *战斗
    */
    public class PacketSCFightInstant implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14003;
        /** 
        *技能编号
        */
        public var skill:int;
        /** 
        *技能等级
        */
        public var level:int;
        /** 
        *攻击者id
        */
        public var srcid:int;
        /** 
        *目标id
        */
        public var targetid:int;
        /** 
        *目标地点x
        */
        public var targetx:int;
        /** 
        *目标地点y
        */
        public var targety:int;
        /** 
        *方向
        */
        public var direct:int;
        /** 
        *攻击者的逻辑计数
        */
        public var logiccount:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(skill);
            ar.writeInt(level);
            ar.writeInt(srcid);
            ar.writeInt(targetid);
            ar.writeInt(targetx);
            ar.writeInt(targety);
            ar.writeInt(direct);
            ar.writeInt(logiccount);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skill = ar.readInt();
            level = ar.readInt();
            srcid = ar.readInt();
            targetid = ar.readInt();
            targetx = ar.readInt();
            targety = ar.readInt();
            direct = ar.readInt();
            logiccount = ar.readInt();
        }
    }
}
