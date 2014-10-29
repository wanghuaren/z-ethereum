package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *pk活动提示开始
    */
    public class PacketSCPkActionStart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20076;
        /** 
        *最小等级
        */
        public var minlevel:int;
        /** 
        *最大等级
        */
        public var maxlevel:int;
        /** 
        *消息id
        */
        public var msgid:int;
        /** 
        *活动id
        */
        public var actionid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(minlevel);
            ar.writeInt(maxlevel);
            ar.writeInt(msgid);
            ar.writeInt(actionid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            minlevel = ar.readInt();
            maxlevel = ar.readInt();
            msgid = ar.readInt();
            actionid = ar.readInt();
        }
    }
}
