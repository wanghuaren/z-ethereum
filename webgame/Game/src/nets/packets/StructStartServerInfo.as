package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructStartServerNameInfo2
    import netc.packets2.StructStartServerNameInfo2
    /** 
    *开服嘉年华第一信息
    */
    public class StructStartServerInfo implements ISerializable
    {
        /** 
        *状态领取 0 未达成 1 可领取 2 已领取
        */
        public var state:int;
        /** 
        *详细信息列表
        */
        public var arrIteminfolist:Vector.<StructStartServerNameInfo2> = new Vector.<StructStartServerNameInfo2>();
        /** 
        *当前排行
        */
        public var arrItemcurlist:Vector.<StructStartServerNameInfo2> = new Vector.<StructStartServerNameInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(state);
            ar.writeInt(arrIteminfolist.length);
            for each (var infolistitem:Object in arrIteminfolist)
            {
                var objinfolist:ISerializable = infolistitem as ISerializable;
                if (null!=objinfolist)
                {
                    objinfolist.Serialize(ar);
                }
            }
            ar.writeInt(arrItemcurlist.length);
            for each (var curlistitem:Object in arrItemcurlist)
            {
                var objcurlist:ISerializable = curlistitem as ISerializable;
                if (null!=objcurlist)
                {
                    objcurlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            state = ar.readInt();
            arrIteminfolist= new  Vector.<StructStartServerNameInfo2>();
            var infolistLength:int = ar.readInt();
            for (var iinfolist:int=0;iinfolist<infolistLength; ++iinfolist)
            {
                var objStartServerNameInfo:StructStartServerNameInfo2 = new StructStartServerNameInfo2();
                objStartServerNameInfo.Deserialize(ar);
                arrIteminfolist.push(objStartServerNameInfo);
            }
            arrItemcurlist= new  Vector.<StructStartServerNameInfo2>();
            var curlistLength:int = ar.readInt();
            for (var icurlist:int=0;icurlist<curlistLength; ++icurlist)
            {
                var objStartServerNameInfo:StructStartServerNameInfo2 = new StructStartServerNameInfo2();
                objStartServerNameInfo.Deserialize(ar);
                arrItemcurlist.push(objStartServerNameInfo);
            }
        }
    }
}
