package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *挂机信息
    */
    public class StructAutoConfig implements ISerializable
    {
        /** 
        *血百分比
        */
        public var hp_precend:int;
        /** 
        *是否启用
        */
        public var hp_enable:int;
        /** 
        *蓝百分比
        */
        public var mp_precend:int;
        /** 
        *是否启用
        */
        public var mp_enable:int;
        /** 
        *拾取物品列表
        */
        public var tool_flag:int;
        /** 
        *自动战斗
        */
        public var fight_set:int;
        /** 
        *战斗范围(1.小2.中3.大)
        */
        public var area:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(hp_precend);
            ar.writeInt(hp_enable);
            ar.writeInt(mp_precend);
            ar.writeInt(mp_enable);
            ar.writeInt(tool_flag);
            ar.writeInt(fight_set);
            ar.writeInt(area);
        }
        public function Deserialize(ar:ByteArray):void
        {
            hp_precend = ar.readInt();
            hp_enable = ar.readInt();
            mp_precend = ar.readInt();
            mp_enable = ar.readInt();
            tool_flag = ar.readInt();
            fight_set = ar.readInt();
            area = ar.readInt();
        }
    }
}
