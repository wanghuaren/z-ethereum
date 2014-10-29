package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *一个强化槽的信息
    */
    public class StructEquipStrongItemData implements ISerializable
    {
        /** 
        *是否可以开启 0:不能1:可以但没有开启2:已经开启
        */
        public var canopen:int;
        /** 
        *总冷却时间
        */
        public var cooltime:int;
        /** 
        *开始强化（炼骨）时间 （高位）
        */
        public var startTimeBig:int;
        /** 
        *开始强化（炼骨）时间 （低位）
        */
        public var startTimeLow:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(canopen);
            ar.writeInt(cooltime);
            ar.writeInt(startTimeBig);
            ar.writeInt(startTimeLow);
        }
        public function Deserialize(ar:ByteArray):void
        {
            canopen = ar.readInt();
            cooltime = ar.readInt();
            startTimeBig = ar.readInt();
            startTimeLow = ar.readInt();
        }
    }
}
