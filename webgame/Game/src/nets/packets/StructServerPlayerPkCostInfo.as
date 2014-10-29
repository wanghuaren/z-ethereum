package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家身价信息
    */
    public class StructServerPlayerPkCostInfo implements ISerializable
    {
        /** 
        *玩家名称
        */
        public var name:String = new String();
        /** 
        *玩家身价
        */
        public var cost:int;

        public function Serialize(ar:ByteArray):void
        {
            PacketFactory.Instance.WriteString(ar, name, 32);
            ar.writeInt(cost);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            cost = ar.readInt();
        }
    }
}
