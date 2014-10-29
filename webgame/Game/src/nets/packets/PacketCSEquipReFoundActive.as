package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *重铸激活
    */
    public class PacketCSEquipReFoundActive implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15018;
        /** 
        *类型(0:角色，1~3:伙伴)
        */
        public var type:int;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *第几条属性
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(pos);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            pos = ar.readInt();
            index = ar.readInt();
        }
    }
}
