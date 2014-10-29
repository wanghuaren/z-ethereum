package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *活动投资回报返回
    */
    public class PacketSCGetInvestRePay implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54605;
        /** 
        *投资类型：1，元宝投资计划；2，银两投资计划；3，坐骑投资计划；4，暗器投资计划；5，披风投资计划；6，星界投资计划
        */
        public var type:int;
        /** 
        *回报物品序号，下标从1开始
        */
        public var index:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(index);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            index = ar.readInt();
            tag = ar.readInt();
        }
    }
}
