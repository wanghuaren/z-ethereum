package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取周工资信息返回
    */
    public class PacketSCActWeekOnline implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38118;
        /** 
        *周累计在线时间，以分钟为单位
        */
        public var onlineminute:int;
        /** 
        *上周可领取元宝
        */
        public var last_rmb:int;
        /** 
        *上周可领取银两
        */
        public var last_coin:int;
        /** 
        *本周预计可领取元宝
        */
        public var cur_rmb:int;
        /** 
        *本周预计可领取银两
        */
        public var cur_coin:int;
        /** 
        *当前在线一个小时可以领取的元宝数
        */
        public var unit_rmb:int;
        /** 
        *当前在线一个小时可以领取的银两数
        */
        public var unit_coin:int;
        /** 
        *开服第几天
        */
        public var user_serverday:int;
        /** 
        *1表示已领取
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(onlineminute);
            ar.writeInt(last_rmb);
            ar.writeInt(last_coin);
            ar.writeInt(cur_rmb);
            ar.writeInt(cur_coin);
            ar.writeInt(unit_rmb);
            ar.writeInt(unit_coin);
            ar.writeInt(user_serverday);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            onlineminute = ar.readInt();
            last_rmb = ar.readInt();
            last_coin = ar.readInt();
            cur_rmb = ar.readInt();
            cur_coin = ar.readInt();
            unit_rmb = ar.readInt();
            unit_coin = ar.readInt();
            user_serverday = ar.readInt();
            state = ar.readInt();
        }
    }
}
