package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructEnemyItem2
    /** 
    *获取仇人列表
    */
    public class PacketSCEnemyList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3022;
        /** 
        *仇敌数组
        */
        public var arrItemEnemyItemList:Vector.<StructEnemyItem2> = new Vector.<StructEnemyItem2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemEnemyItemList.length);
            for each (var EnemyItemListitem:Object in arrItemEnemyItemList)
            {
                var objEnemyItemList:ISerializable = EnemyItemListitem as ISerializable;
                if (null!=objEnemyItemList)
                {
                    objEnemyItemList.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemEnemyItemList= new  Vector.<StructEnemyItem2>();
            var EnemyItemListLength:int = ar.readInt();
            for (var iEnemyItemList:int=0;iEnemyItemList<EnemyItemListLength; ++iEnemyItemList)
            {
                var objEnemyItem:StructEnemyItem2 = new StructEnemyItem2();
                objEnemyItem.Deserialize(ar);
                arrItemEnemyItemList.push(objEnemyItem);
            }
        }
    }
}
