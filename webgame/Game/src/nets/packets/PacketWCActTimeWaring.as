package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *提示玩家活动开始
    */
    public class PacketWCActTimeWaring implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20038;
        /** 
        *活动id
        */
        public var act_id:int;
        /** 
        *活动tokenid
        */
        public var token:int;
        /** 
        *消息id
        */
        public var msg_id:int;
        /** 
        *寻路id
        */
        public var seek_id:int;
        /** 
        *最小等级
        */
        public var min_level:int;
        /** 
        *最大等级
        */
        public var max_level:int;
        /** 
        *阵营
        */
        public var camp_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(act_id);
            ar.writeInt(token);
            ar.writeInt(msg_id);
            ar.writeInt(seek_id);
            ar.writeInt(min_level);
            ar.writeInt(max_level);
            ar.writeInt(camp_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            act_id = ar.readInt();
            token = ar.readInt();
            msg_id = ar.readInt();
            seek_id = ar.readInt();
            min_level = ar.readInt();
            max_level = ar.readInt();
            camp_id = ar.readInt();
        }
    }
}
