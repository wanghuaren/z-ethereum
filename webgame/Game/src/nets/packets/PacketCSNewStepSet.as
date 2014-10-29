package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructNewStepInfo2
    /** 
    *设置玩家当家新手引导数据返回
    */
    public class PacketCSNewStepSet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 35003;
        /** 
        *新手引导数据
        */
        public var data:StructNewStepInfo2 = new StructNewStepInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            data.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            data.Deserialize(ar);
        }
    }
}
