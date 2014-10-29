package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPk_Rank_List2
    /** 
    *获得pk日排行榜数据返回
    */
    public class PacketWCGetDayPkRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20057;
        /** 
        *错误信息
        */
        public var tag:int;
        /** 
        *页数
        */
        public var page:int;
        /** 
        *总页数
        */
        public var total_page:int;
        /** 
        *列表数据
        */
        public var list_data:StructPk_Rank_List2 = new StructPk_Rank_List2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(page);
            ar.writeInt(total_page);
            list_data.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            page = ar.readInt();
            total_page = ar.readInt();
            list_data.Deserialize(ar);
        }
    }
}
