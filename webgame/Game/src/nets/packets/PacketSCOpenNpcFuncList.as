package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructNpcFunc2
    /** 
    *NPC功能列表返回
    */
    public class PacketSCOpenNpcFuncList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 7006;
        /** 
        *NPC功能列表
        */
        public var arrItemlist:Vector.<StructNpcFunc2> = new Vector.<StructNpcFunc2>();
        /** 
        *NPC的模板ID
        */
        public var npcid:int;

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
            ar.writeInt(npcid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlist= new  Vector.<StructNpcFunc2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objNpcFunc:StructNpcFunc2 = new StructNpcFunc2();
                objNpcFunc.Deserialize(ar);
                arrItemlist.push(objNpcFunc);
            }
            npcid = ar.readInt();
        }
    }
}
