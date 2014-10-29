package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTaskList2
    import netc.packets2.StructAwardTaskList2
    /** 
    *
    */
    public class StructDBTaskList implements ISerializable
    {
        /** 
        *任务历史
        */
        public var arrItemtask_list:Vector.<StructTaskList2> = new Vector.<StructTaskList2>();
        /** 
        *悬赏任务
        */
        public var arrItemtask_award:Vector.<StructAwardTaskList2> = new Vector.<StructAwardTaskList2>();
        /** 
        *悬赏任务上次刷新时间
        */
        public var task_award_last_freshtime:int;
        /** 
        *已免费刷新次数
        */
        public var task_award_times:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemtask_list.length);
            for each (var task_listitem:Object in arrItemtask_list)
            {
                var objtask_list:ISerializable = task_listitem as ISerializable;
                if (null!=objtask_list)
                {
                    objtask_list.Serialize(ar);
                }
            }
            ar.writeInt(arrItemtask_award.length);
            for each (var task_awarditem:Object in arrItemtask_award)
            {
                var objtask_award:ISerializable = task_awarditem as ISerializable;
                if (null!=objtask_award)
                {
                    objtask_award.Serialize(ar);
                }
            }
            ar.writeInt(task_award_last_freshtime);
            ar.writeInt(task_award_times);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemtask_list= new  Vector.<StructTaskList2>();
            var task_listLength:int = ar.readInt();
            for (var itask_list:int=0;itask_list<task_listLength; ++itask_list)
            {
                var objTaskList:StructTaskList2 = new StructTaskList2();
                objTaskList.Deserialize(ar);
                arrItemtask_list.push(objTaskList);
            }
            arrItemtask_award= new  Vector.<StructAwardTaskList2>();
            var task_awardLength:int = ar.readInt();
            for (var itask_award:int=0;itask_award<task_awardLength; ++itask_award)
            {
                var objAwardTaskList:StructAwardTaskList2 = new StructAwardTaskList2();
                objAwardTaskList.Deserialize(ar);
                arrItemtask_award.push(objAwardTaskList);
            }
            task_award_last_freshtime = ar.readInt();
            task_award_times = ar.readInt();
        }
    }
}
