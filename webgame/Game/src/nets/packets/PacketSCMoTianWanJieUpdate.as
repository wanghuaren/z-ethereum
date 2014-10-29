package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *魔天万界副本信息更新
    */
    public class PacketSCMoTianWanJieUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20034;
        /** 
        *剩余时间
        */
        public var lefttime:int;
        /** 
        *boss当前生命
        */
        public var curhp:int;
        /** 
        *boss最大生命
        */
        public var maxhp:int;
        /** 
        *boss id
        */
        public var npcid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(lefttime);
            ar.writeInt(curhp);
            ar.writeInt(maxhp);
            ar.writeInt(npcid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            lefttime = ar.readInt();
            curhp = ar.readInt();
            maxhp = ar.readInt();
            npcid = ar.readInt();
        }
    }
}
