package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *阵营分数更新
    */
    public class PacketWCCampNumUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20055;
        /** 
        *太乙积分
        */
        public var camp1:int;
        /** 
        *通天积分
        */
        public var camp2:int;
        /** 
        *太乙人数
        */
        public var camp1_man:int;
        /** 
        *通天人数
        */
        public var camp2_man:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(camp1);
            ar.writeInt(camp2);
            ar.writeInt(camp1_man);
            ar.writeInt(camp2_man);
        }
        public function Deserialize(ar:ByteArray):void
        {
            camp1 = ar.readInt();
            camp2 = ar.readInt();
            camp1_man = ar.readInt();
            camp2_man = ar.readInt();
        }
    }
}
