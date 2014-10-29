package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *投资计划
    */
    public class StructInvest implements ISerializable
    {
        /** 
        *类型: 1，元宝投资计划；2，银两投资计划；3，坐骑投资计划；4，暗器投资计划；5，披风投资计划；6，星界投资计划
        */
        public var type:int;
        /** 
        *投资第几天.
        */
        public var beginday:int;
        /** 
        *状态，bit位表示，0：未领取，1：已经领取
        */
        public var status:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(type);
            ar.writeInt(beginday);
            ar.writeInt(status);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            beginday = ar.readInt();
            status = ar.readInt();
        }
    }
}
