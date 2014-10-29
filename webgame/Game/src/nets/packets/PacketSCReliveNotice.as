package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家复活提示
    */
    public class PacketSCReliveNotice implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14042;
        /** 
        *是否能原地复活，0 不可以，1 可以
        */
        public var flag:int;
        /** 
        *被谁杀死
        */
        public var killer_name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
            PacketFactory.Instance.WriteString(ar, killer_name, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
            var killer_nameLength:int = ar.readInt();
            killer_name = ar.readMultiByte(killer_nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
