package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDiGongBossState2
    /** 
    *设置地宫boss状态
    */
    public class PacketSWSetDiGongBossState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51203;
        /** 
        *boss状态
        */
        public var boss_state:StructDiGongBossState2 = new StructDiGongBossState2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            boss_state.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            boss_state.Deserialize(ar);
        }
    }
}
