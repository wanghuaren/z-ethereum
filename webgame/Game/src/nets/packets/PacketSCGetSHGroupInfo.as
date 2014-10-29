package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSHGroupMemberInfo2
    /** 
    *获得个人赛队伍数据返回
    */
    public class PacketSCGetSHGroupInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52901;
        /** 
        *队友信息
        */
        public var arrItemgroupmemberinfo:Vector.<StructSHGroupMemberInfo2> = new Vector.<StructSHGroupMemberInfo2>();
        /** 
        *结果
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemgroupmemberinfo.length);
            for each (var groupmemberinfoitem:Object in arrItemgroupmemberinfo)
            {
                var objgroupmemberinfo:ISerializable = groupmemberinfoitem as ISerializable;
                if (null!=objgroupmemberinfo)
                {
                    objgroupmemberinfo.Serialize(ar);
                }
            }
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemgroupmemberinfo= new  Vector.<StructSHGroupMemberInfo2>();
            var groupmemberinfoLength:int = ar.readInt();
            for (var igroupmemberinfo:int=0;igroupmemberinfo<groupmemberinfoLength; ++igroupmemberinfo)
            {
                var objSHGroupMemberInfo:StructSHGroupMemberInfo2 = new StructSHGroupMemberInfo2();
                objSHGroupMemberInfo.Deserialize(ar);
                arrItemgroupmemberinfo.push(objSHGroupMemberInfo);
            }
            tag = ar.readInt();
        }
    }
}
