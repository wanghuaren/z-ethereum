package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBuff2
    /** 
    *人物/怪物的buff列表
    */
    public class PacketSCObjBuffList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14025;
        /** 
        *人物/怪物编号
        */
        public var objid:int;
        /** 
        *buff列表
        */
        public var arrItemlist:Vector.<StructBuff2> = new Vector.<StructBuff2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
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
            objid = ar.readInt();
            arrItemlist= new  Vector.<StructBuff2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objBuff:StructBuff2 = new StructBuff2();
                objBuff.Deserialize(ar);
                arrItemlist.push(objBuff);
            }
        }
    }
}
