package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *经验找回
    */
    public class PacketCSExpBack implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 33001;
        /** 
        *0:一键找回 1：昨天 2前天 3大前天
        */
        public var date:int;
        /** 
        *活动组id
        */
        public var actionid:int;
        /** 
        *0免费领取，1元宝领取
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(date);
            ar.writeInt(actionid);
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            date = ar.readInt();
            actionid = ar.readInt();
            type = ar.readInt();
        }
    }
}
