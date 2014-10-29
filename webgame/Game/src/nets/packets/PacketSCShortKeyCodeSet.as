package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *快捷键锁定/解锁
    */
    public class PacketSCShortKeyCodeSet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8808;
        /** 
        *技能位置
        */
        public var skill_pos:int;
        /** 
        *快捷键
        */
        public var keyCode:int;
        /** 
        *结果编号
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(skill_pos);
            ar.writeInt(keyCode);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skill_pos = ar.readInt();
            keyCode = ar.readInt();
            tag = ar.readInt();
        }
    }
}
