package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCityFightInfoData2
    /** 
    *皇城争霸战信息刷新
    */
    public class PacketSCCityInfoUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29048;
        /** 
        *错误码
        */
        public var arrIteminfo_list:Vector.<StructCityFightInfoData2> = new Vector.<StructCityFightInfoData2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
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
            arrIteminfo_list= new  Vector.<StructCityFightInfoData2>();
            var info_listLength:int = ar.readInt();
            for (var iinfo_list:int=0;iinfo_list<info_listLength; ++iinfo_list)
            {
                var objCityFightInfoData:StructCityFightInfoData2 = new StructCityFightInfoData2();
                objCityFightInfoData.Deserialize(ar);
                arrIteminfo_list.push(objCityFightInfoData);
            }
        }
    }
}
