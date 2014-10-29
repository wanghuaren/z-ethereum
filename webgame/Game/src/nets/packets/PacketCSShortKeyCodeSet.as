package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *快捷键锁定/解锁
    */
    public class PacketCSShortKeyCodeSet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8807;
        /** 
        *技能位置
        */
        public var skill_pos:int;
        /** 
        *快捷键
        */
        public var keyCode:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(skill_pos);
            ar.writeInt(keyCode);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skill_pos = ar.readInt();
            keyCode = ar.readInt();
        }
    }
}
