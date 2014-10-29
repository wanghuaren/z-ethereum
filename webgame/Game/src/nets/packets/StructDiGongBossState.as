package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *地宫boss状态
    */
    public class StructDiGongBossState implements ISerializable
    {
        /** 
        *BOSS ID
        */
        public var bossid:int;
        /** 
        *当前状态 1:刷出 2:被击杀
        */
        public var state:int;
        /** 
        *击杀者名称
        */
        public var killer_name:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(bossid);
            ar.writeInt(state);
            PacketFactory.Instance.WriteString(ar, killer_name, 64);
        }
        public function Deserialize(ar:ByteArray):void
        {
            bossid = ar.readInt();
            state = ar.readInt();
            var killer_nameLength:int = ar.readInt();
            killer_name = ar.readMultiByte(killer_nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
