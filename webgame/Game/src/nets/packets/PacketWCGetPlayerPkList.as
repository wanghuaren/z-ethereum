package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPk_Player_List2
    /** 
    *获得玩家pk列表数据返回
    */
    public class PacketWCGetPlayerPkList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20065;
        /** 
        *错误信息
        */
        public var tag:int;
        /** 
        *页数
        */
        public var page:int;
        /** 
        *阵营
        */
        public var camp:int;
        /** 
        *总页数
        */
        public var total_page:int;
        /** 
        *玩家列表
        */
        public var arrIteminfo_list:Vector.<StructPk_Player_List2> = new Vector.<StructPk_Player_List2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(page);
            ar.writeInt(camp);
            ar.writeInt(total_page);
            ar.writeInt(arrIteminfo_list.length);
            for each (var info_listitem:Object in arrIteminfo_list)
            {
                var objinfo_list:ISerializable = info_listitem as ISerializable;
                if (null!=objinfo_list)
                {
                    objinfo_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            page = ar.readInt();
            camp = ar.readInt();
            total_page = ar.readInt();
            arrIteminfo_list= new  Vector.<StructPk_Player_List2>();
            var info_listLength:int = ar.readInt();
            for (var iinfo_list:int=0;iinfo_list<info_listLength; ++iinfo_list)
            {
                var objPk_Player_List:StructPk_Player_List2 = new StructPk_Player_List2();
                objPk_Player_List.Deserialize(ar);
                arrIteminfo_list.push(objPk_Player_List);
            }
        }
    }
}
