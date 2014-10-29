package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *挂机查询掉落能否拾取
    */
    public class PacketCSQueryCanPick implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 25011;
        /** 
        *掉落盒ID
        */
        public var dropbox_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(dropbox_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            dropbox_id = ar.readInt();
        }
    }
}
