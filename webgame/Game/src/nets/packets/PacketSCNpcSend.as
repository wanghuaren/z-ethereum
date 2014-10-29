package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructNpcTrans2
    /** 
    *NPC传送列表
    */
    public class PacketSCNpcSend implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13010;
        /** 
        *
        */
        public var arrItemlist:Vector.<StructNpcTrans2> = new Vector.<StructNpcTrans2>();

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
            arrItemlist= new  Vector.<StructNpcTrans2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objNpcTrans:StructNpcTrans2 = new StructNpcTrans2();
                objNpcTrans.Deserialize(ar);
                arrItemlist.push(objNpcTrans);
            }
        }
    }
}
