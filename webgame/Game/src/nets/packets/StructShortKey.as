package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *单个快捷键
    */
    public class StructShortKey implements ISerializable
    {
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *技能或药品id
        */
        public var id:int;
        /** 
        *0:技能 1:道具
        */
        public var type:int;
        /** 
        *快捷键
        */
        public var keyCode:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(pos);
            ar.writeInt(id);
            ar.writeInt(type);
            ar.writeInt(keyCode);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            id = ar.readInt();
            type = ar.readInt();
            keyCode = ar.readInt();
        }
    }
}
