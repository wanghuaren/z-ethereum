package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *强化槽的信息
    */
    public class StructEquipStrongItem implements ISerializable
    {
        /** 
        *哪一个槽
        */
        public var pos:int;
        /** 
        *剩余强化时间
        */
        public var time:int;
        /** 
        *是否可以开启 0:不能1:可以但没有开启2:已经开启
        */
        public var canopen:int;
        /** 
        *总强化时间
        */
        public var coldtime:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(pos);
            ar.writeInt(time);
            ar.writeInt(canopen);
            ar.writeInt(coldtime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            time = ar.readInt();
            canopen = ar.readInt();
            coldtime = ar.readInt();
        }
    }
}
