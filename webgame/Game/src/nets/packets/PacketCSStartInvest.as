package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *开始投资
    */
    public class PacketCSStartInvest implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54600;
        /** 
        *投资类型：1，元宝投资计划；2，银两投资计划；3，坐骑投资计划；4，暗器投资计划；5，披风投资计划；6，星界投资计划
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
        }
    }
}
