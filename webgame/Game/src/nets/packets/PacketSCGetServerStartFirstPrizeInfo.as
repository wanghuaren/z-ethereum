package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructStartServerInfo2
    /** 
    *获得开服嘉年华奖励第一信息返回
    */
    public class PacketSCGetServerStartFirstPrizeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39805;
        /** 
        *详细信息列表
        */
        public var arrItemserverstartinfolist:Vector.<StructStartServerInfo2> = new Vector.<StructStartServerInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemserverstartinfolist.length);
            for each (var serverstartinfolistitem:Object in arrItemserverstartinfolist)
            {
                var objserverstartinfolist:ISerializable = serverstartinfolistitem as ISerializable;
                if (null!=objserverstartinfolist)
                {
                    objserverstartinfolist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemserverstartinfolist= new  Vector.<StructStartServerInfo2>();
            var serverstartinfolistLength:int = ar.readInt();
            for (var iserverstartinfolist:int=0;iserverstartinfolist<serverstartinfolistLength; ++iserverstartinfolist)
            {
                var objStartServerInfo:StructStartServerInfo2 = new StructStartServerInfo2();
                objStartServerInfo.Deserialize(ar);
                arrItemserverstartinfolist.push(objStartServerInfo);
            }
        }
    }
}
