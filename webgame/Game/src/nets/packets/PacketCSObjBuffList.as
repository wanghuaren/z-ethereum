package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取人物/怪物的buff列表
    */
    public class PacketCSObjBuffList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14024;
        /** 
        *人物/怪物编号,为0获取自己的buff列表
        */
        public var objid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
        }
    }
}
