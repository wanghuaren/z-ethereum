package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDoubleExpInfo2
    /** 
    *获取玩家地图双倍经验数据返回
    */
    public class PacketSCMapDoubleExpInfoGetRet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 36011;
        /** 
        *玩家双倍经验数据
        */
        public var data:StructDoubleExpInfo2 = new StructDoubleExpInfo2();

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
