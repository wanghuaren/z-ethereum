package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *返回魔天万界信息
    */
    public class PacketSCTowerInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29010;
        /** 
        *阶段，默认从0开始
        */
        public var step:int;
        /** 
        *最大层数，默认从0开始
        */
        public var level:int;
        /** 
        *重置次数
        */
        public var resetnum:int;
        /** 
        *请求的阶段
        */
        public var req_step:int;
        /** 
        *星级评价
        */
        public var star:int;
        /** 
        *挑战信息
        */
        public var info:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step);
            ar.writeInt(level);
            ar.writeInt(resetnum);
            ar.writeInt(req_step);
            ar.writeInt(star);
            ar.writeInt(info);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step = ar.readInt();
            level = ar.readInt();
            resetnum = ar.readInt();
            req_step = ar.readInt();
            star = ar.readInt();
            info = ar.readInt();
        }
    }
}
