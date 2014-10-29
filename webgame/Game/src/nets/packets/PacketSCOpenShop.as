package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *打开商店
    */
    public class PacketSCOpenShop implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 7004;
        /** 
        *窗口id
        */
        public var dialog_id:int;
        /** 
        *页码
        */
        public var page:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(dialog_id);
            ar.writeInt(page);
        }
        public function Deserialize(ar:ByteArray):void
        {
            dialog_id = ar.readInt();
            page = ar.readInt();
        }
    }
}
