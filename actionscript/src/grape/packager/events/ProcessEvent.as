/**
 * Created by Administrator on 2014/8/13.
 */
package grape.packager.events {
import flash.events.Event;

public class ProcessEvent extends Event {

    public static const COMPLETED:String = "completed";

    public function ProcessEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super (type, bubbles, cancelable);
    }

    override public function clone():Event{
        var evt:ProcessEvent = new ProcessEvent(this.type,this.bubbles,this.cancelable);
        return evt;
    }
}
}
