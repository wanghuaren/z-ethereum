package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *接受洪福齐天祝福
    */
    public class PacketCSGetGodBlessPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38160;
        /** 
        *类型1表示祝福1，2表示祝福2，3表示祝福3
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
