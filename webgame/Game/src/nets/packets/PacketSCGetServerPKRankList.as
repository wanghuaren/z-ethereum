package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerPKRankUserInfo2
    /** 
    *获得仙道会的排行数据返回
    */
    public class PacketSCGetServerPKRankList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53050;
        /** 
        *个人信息列表
        */
        public var arrItemserverpkinfo:Vector.<StructServerPKRankUserInfo2> = new Vector.<StructServerPKRankUserInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemserverpkinfo.length);
            for each (var serverpkinfoitem:Object in arrItemserverpkinfo)
            {
                var objserverpkinfo:ISerializable = serverpkinfoitem as ISerializable;
                if (null!=objserverpkinfo)
                {
                    objserverpkinfo.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemserverpkinfo= new  Vector.<StructServerPKRankUserInfo2>();
            var serverpkinfoLength:int = ar.readInt();
            for (var iserverpkinfo:int=0;iserverpkinfo<serverpkinfoLength; ++iserverpkinfo)
            {
                var objServerPKRankUserInfo:StructServerPKRankUserInfo2 = new StructServerPKRankUserInfo2();
                objServerPKRankUserInfo.Deserialize(ar);
                arrItemserverpkinfo.push(objServerPKRankUserInfo);
            }
        }
    }
}
