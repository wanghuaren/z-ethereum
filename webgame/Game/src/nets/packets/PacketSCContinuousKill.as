package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *连斩信息
    */
    public class PacketSCContinuousKill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14033;
        /** 
        *连斩累计经验
        */
        public var exp_ck:int;
        /** 
        *连斩累计次数
        */
        public var count_ck:int;
        /** 
        *0表示停止
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(exp_ck);
            ar.writeInt(count_ck);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            exp_ck = ar.readInt();
            count_ck = ar.readInt();
            flag = ar.readInt();
        }
    }
}
