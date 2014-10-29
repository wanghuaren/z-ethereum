package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *开始操作资源
    */
    public class PacketSCOperateResStart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14010;
        /** 
        *开始使用生活技能玩家id
        */
        public var userid:int;
        /** 
        *逻辑计数
        */
        public var logiccount:int;
        /** 
        *资源id
        */
        public var objid:int;
        /** 
        *操作时间
        */
        public var actiontime:int;
        /** 
        *动作id
        */
        public var actionid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
            ar.writeInt(logiccount);
            ar.writeInt(objid);
            ar.writeInt(actiontime);
            ar.writeInt(actionid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            logiccount = ar.readInt();
            objid = ar.readInt();
            actiontime = ar.readInt();
            actionid = ar.readInt();
        }
    }
}
