package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSignList2
    /** 
    *副本报名信息列表返回
    */
    public class PacketSCInstanceList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20004;
        /** 
        *副本信息
        */
        public var arrItemsignlist:Vector.<StructSignList2> = new Vector.<StructSignList2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemsignlist.length);
            for each (var signlistitem:Object in arrItemsignlist)
            {
                var objsignlist:ISerializable = signlistitem as ISerializable;
                if (null!=objsignlist)
                {
                    objsignlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemsignlist= new  Vector.<StructSignList2>();
            var signlistLength:int = ar.readInt();
            for (var isignlist:int=0;isignlist<signlistLength; ++isignlist)
            {
                var objSignList:StructSignList2 = new StructSignList2();
                objSignList.Deserialize(ar);
                arrItemsignlist.push(objSignList);
            }
        }
    }
}
