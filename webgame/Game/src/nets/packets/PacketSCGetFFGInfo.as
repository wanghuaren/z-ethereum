package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructFFGInfo2
    /** 
    *请求斗战神通关最快信息返回
    */
    public class PacketSCGetFFGInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 45004;
        /** 
        *信息列表
        */
        public var arrItemlist:Vector.<StructFFGInfo2> = new Vector.<StructFFGInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlist= new  Vector.<StructFFGInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objFFGInfo:StructFFGInfo2 = new StructFFGInfo2();
                objFFGInfo.Deserialize(ar);
                arrItemlist.push(objFFGInfo);
            }
        }
    }
}
