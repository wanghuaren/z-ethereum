package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *进入魔天万界
    */
    public class PacketCSEntryTower implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29011;
        /** 
        *阶段 默认从0开始
        */
        public var step:int;
        /** 
        *进入魔天万界的地图的层数 默认从0开始
        */
        public var level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step = ar.readInt();
            level = ar.readInt();
        }
    }
}
