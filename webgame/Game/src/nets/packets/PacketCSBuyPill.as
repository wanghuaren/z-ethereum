package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *买并吃
    */
    public class PacketCSBuyPill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 27002;
        /** 
        *丹药id
        */
        public var pillid:int;
        /** 
        *数量
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pillid);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pillid = ar.readInt();
            num = ar.readInt();
        }
    }
}
