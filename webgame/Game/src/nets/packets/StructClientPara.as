package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *客户端参数
    */
    public class StructClientPara implements ISerializable
    {
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
        /** 
        *参数4
        */
        public var para4:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(para1);
            ar.writeInt(para2);
            ar.writeInt(para3);
            ar.writeInt(para4);
        }
        public function Deserialize(ar:ByteArray):void
        {
            para1 = ar.readInt();
            para2 = ar.readInt();
            para3 = ar.readInt();
            para4 = ar.readInt();
        }
    }
}
