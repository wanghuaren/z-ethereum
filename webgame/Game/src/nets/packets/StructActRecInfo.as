package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *活动成就记录
    */
    public class StructActRecInfo implements ISerializable
    {
        /** 
        *活动id
        */
        public var arid:int;
        /** 
        *次数
        */
        public var count:int;
        /** 
        *参数1
        */
        public var para1:int;
        /** 
        *参数2
        */
        public var para2:int;
        /** 
        *参数3
        */
        public var para3:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arid);
            ar.writeInt(count);
            ar.writeInt(para1);
            ar.writeInt(para2);
            ar.writeInt(para3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arid = ar.readInt();
            count = ar.readInt();
            para1 = ar.readInt();
            para2 = ar.readInt();
            para3 = ar.readInt();
        }
    }
}
