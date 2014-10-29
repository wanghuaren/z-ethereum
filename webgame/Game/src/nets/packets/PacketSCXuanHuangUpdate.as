package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玄黄剑副本信息更新
    */
    public class PacketSCXuanHuangUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20033;
        /** 
        *剩余时间
        */
        public var lefttime:int;
        /** 
        *当前波次
        */
        public var curwave:int;
        /** 
        *最大波次
        */
        public var maxwave:int;
        /** 
        *当前杀死怪物数量
        */
        public var curmonsternum:int;
        /** 
        *最大怪物数量
        */
        public var maxmonsternum:int;
        /** 
        *当前生命
        */
        public var curhp:int;
        /** 
        *最大生命
        */
        public var maxhp:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(lefttime);
            ar.writeInt(curwave);
            ar.writeInt(maxwave);
            ar.writeInt(curmonsternum);
            ar.writeInt(maxmonsternum);
            ar.writeInt(curhp);
            ar.writeInt(maxhp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            lefttime = ar.readInt();
            curwave = ar.readInt();
            maxwave = ar.readInt();
            curmonsternum = ar.readInt();
            maxmonsternum = ar.readInt();
            curhp = ar.readInt();
            maxhp = ar.readInt();
        }
    }
}
