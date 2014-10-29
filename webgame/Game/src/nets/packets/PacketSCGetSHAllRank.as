package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSHTotalUserInfo2
    /** 
    *获得个人赛比赛排名数据返回
    */
    public class PacketSCGetSHAllRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53026;
        /** 
        *请求的页数 1 开始
        */
        public var page:int;
        /** 
        *总人数
        */
        public var total:int;
        /** 
        *用户信息
        */
        public var arrItemuserinfo:Vector.<StructSHTotalUserInfo2> = new Vector.<StructSHTotalUserInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(page);
            ar.writeInt(total);
            ar.writeInt(arrItemuserinfo.length);
            for each (var userinfoitem:Object in arrItemuserinfo)
            {
                var objuserinfo:ISerializable = userinfoitem as ISerializable;
                if (null!=objuserinfo)
                {
                    objuserinfo.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            page = ar.readInt();
            total = ar.readInt();
            arrItemuserinfo= new  Vector.<StructSHTotalUserInfo2>();
            var userinfoLength:int = ar.readInt();
            for (var iuserinfo:int=0;iuserinfo<userinfoLength; ++iuserinfo)
            {
                var objSHTotalUserInfo:StructSHTotalUserInfo2 = new StructSHTotalUserInfo2();
                objSHTotalUserInfo.Deserialize(ar);
                arrItemuserinfo.push(objSHTotalUserInfo);
            }
        }
    }
}
