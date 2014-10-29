package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *挂机查询掉落能否拾取
    */
    public class PacketSCQueryCanPick implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 25012;
        /** 
        *掉落盒ID
        */
        public var dropbox_id:int;
        /** 
        *能否拾取 0:不能 1:能 
        */
        public var canpick:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(dropbox_id);
            ar.writeInt(canpick);
        }
        public function Deserialize(ar:ByteArray):void
        {
            dropbox_id = ar.readInt();
            canpick = ar.readInt();
        }
    }
}
