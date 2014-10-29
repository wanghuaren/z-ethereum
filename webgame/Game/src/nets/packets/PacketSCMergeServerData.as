package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructMergeServerData2
    /** 
    *合服活动数据返回
    */
    public class PacketSCMergeServerData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53703;
        /** 
        *合服数据
        */
        public var data:StructMergeServerData2 = new StructMergeServerData2();
        /** 
        *神秘商店刷新数据,index
        */
        public var arrItemaction1_items:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            data.Serialize(ar);
            ar.writeInt(arrItemaction1_items.length);
            for each (var action1_itemsitem:int in arrItemaction1_items)
            {
                ar.writeInt(action1_itemsitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            data.Deserialize(ar);
            arrItemaction1_items= new  Vector.<int>();
            var action1_itemsLength:int = ar.readInt();
            for (var iaction1_items:int=0;iaction1_items<action1_itemsLength; ++iaction1_items)
            {
                arrItemaction1_items.push(ar.readInt());
            }
        }
    }
}
