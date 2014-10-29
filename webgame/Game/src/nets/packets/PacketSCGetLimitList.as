package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructLimitInfo2
    /** 
    *查询限制数据
    */
    public class PacketSCGetLimitList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24302;
        /** 
        *限制id信息列表
        */
        public var arrItemlimitlistinfo:Vector.<StructLimitInfo2> = new Vector.<StructLimitInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemlimitlistinfo.length);
            for each (var limitlistinfoitem:Object in arrItemlimitlistinfo)
            {
                var objlimitlistinfo:ISerializable = limitlistinfoitem as ISerializable;
                if (null!=objlimitlistinfo)
                {
                    objlimitlistinfo.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlimitlistinfo= new  Vector.<StructLimitInfo2>();
            var limitlistinfoLength:int = ar.readInt();
            for (var ilimitlistinfo:int=0;ilimitlistinfo<limitlistinfoLength; ++ilimitlistinfo)
            {
                var objLimitInfo:StructLimitInfo2 = new StructLimitInfo2();
                objLimitInfo.Deserialize(ar);
                arrItemlimitlistinfo.push(objLimitInfo);
            }
        }
    }
}
