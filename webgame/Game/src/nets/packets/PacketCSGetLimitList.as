package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRequestLimit2
    /** 
    *查询限制数据
    */
    public class PacketCSGetLimitList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24301;
        /** 
        *限制id列表
        */
        public var arrItemlimitlist:Vector.<StructRequestLimit2> = new Vector.<StructRequestLimit2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemlimitlist.length);
            for each (var limitlistitem:Object in arrItemlimitlist)
            {
                var objlimitlist:ISerializable = limitlistitem as ISerializable;
                if (null!=objlimitlist)
                {
                    objlimitlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlimitlist= new  Vector.<StructRequestLimit2>();
            var limitlistLength:int = ar.readInt();
            for (var ilimitlist:int=0;ilimitlist<limitlistLength; ++ilimitlist)
            {
                var objRequestLimit:StructRequestLimit2 = new StructRequestLimit2();
                objRequestLimit.Deserialize(ar);
                arrItemlimitlist.push(objRequestLimit);
            }
        }
    }
}
