package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取百服活动信息返回
    */
    public class PacketSCGetHundredSrv implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53801;
        /** 
        *活动开始日期,格式20120101
        */
        public var begin_date:int;
        /** 
        *活动结束日期
        */
        public var end_date:int;
        /** 
        *活动状态
        */
        public var state:int;
        /** 
        *第XX服
        */
        public var server_num:int;
        /** 
        *用来显示的第XX服
        */
        public var server_show_num:int;
        /** 
        *活动信息
        */
        public var msg:String = new String();
        /** 
        *是否是百服 0 否 1 是
        */
        public var is_server:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(begin_date);
            ar.writeInt(end_date);
            ar.writeInt(state);
            ar.writeInt(server_num);
            ar.writeInt(server_show_num);
            PacketFactory.Instance.WriteString(ar, msg, 200);
            ar.writeInt(is_server);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            begin_date = ar.readInt();
            end_date = ar.readInt();
            state = ar.readInt();
            server_num = ar.readInt();
            server_show_num = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            is_server = ar.readInt();
            tag = ar.readInt();
        }
    }
}
