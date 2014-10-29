package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *拾取物品
    */
    public class PacketCSPick implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14006;
        /** 
        *拾取包id
        */
        public var objid:int;
        /** 
        *拾取包序号
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            index = ar.readInt();
        }
    }
}
