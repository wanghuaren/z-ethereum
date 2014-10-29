package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *副本扫荡
    */
    public class PacketCSSInstanceSweep implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20082;
        /** 
        *类型 1 魔天万界 2 副本
        */
        public var sort:int;
        /** 
        *参数 1 魔天万界  阶数  默认从0 开始 2 副本 副本id
        */
        public var para1:int;
        /** 
        *类型 1 魔天万界  无用  2 副本 副本难度
        */
        public var para2:int;
        /** 
        *类型 1 魔天万界  无用   2 副本 无用
        */
        public var para3:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sort);
            ar.writeInt(para1);
            ar.writeInt(para2);
            ar.writeInt(para3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
            para1 = ar.readInt();
            para2 = ar.readInt();
            para3 = ar.readInt();
        }
    }
}
