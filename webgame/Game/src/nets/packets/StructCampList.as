package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *阵营列表
    */
    public class StructCampList implements ISerializable
    {
        /** 
        *阵营编号,2为通天教,3为太乙教
        */
        public var campid:int;
        /** 
        *阵营平衡值
        */
        public var balancevalue:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(campid);
            ar.writeInt(balancevalue);
        }
        public function Deserialize(ar:ByteArray):void
        {
            campid = ar.readInt();
            balancevalue = ar.readInt();
        }
    }
}
