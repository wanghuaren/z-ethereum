package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *中断操作资源
    */
    public class PacketSCOperateResCancel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14011;
        /** 
        *中断生活技能玩家id
        */
        public var userid:int;
        /** 
        *逻辑计数
        */
        public var logiccount:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
            ar.writeInt(logiccount);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            logiccount = ar.readInt();
        }
    }
}
