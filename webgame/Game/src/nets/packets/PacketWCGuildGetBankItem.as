package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取仓库物品
    */
    public class PacketWCGuildGetBankItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39260;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
        }
    }
}
