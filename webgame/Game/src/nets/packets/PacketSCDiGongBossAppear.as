package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *地宫boss出现提示
    */
    public class PacketSCDiGongBossAppear implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51204;
        /** 
        *boss id
        */
        public var boss_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(boss_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            boss_id = ar.readInt();
        }
    }
}
