package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *活动状态更新
    */
    public class PacketSCActionStateUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20041;
        /** 
        *活动id
        */
        public var act_id:int;
        /** 
        *活动状态 0 结束 1 开始
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(act_id);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            act_id = ar.readInt();
            state = ar.readInt();
        }
    }
}
