package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *战斗
    */
    public class PacketCSFight implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14001;
        /** 
        *技能编号
        */
        public var skill:int;
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

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(skill);
            ar.writeInt(targetid);
            ar.writeInt(targetx);
            ar.writeInt(targety);
            ar.writeInt(direct);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skill = ar.readInt();
            targetid = ar.readInt();
            targetx = ar.readInt();
            targety = ar.readInt();
            direct = ar.readInt();
        }
    }
}
