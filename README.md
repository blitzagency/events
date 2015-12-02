# Events

Represents an attempt to bring backbone style events to Swift.

Delegates are fine, and they are probably more performanent, but
it is so much faster to just keep coding than to:

#. Stop coding
#. Create a new protocol
#. Create an implementation of that protocol
#. Add the delegate to the object that needs it
#. Alter your code to use the delegate


Events let you just keep going. Need to communicate between N
Child ViewControllers to their parent ViewController, no problem with
events:

```swift
import Events

class ParentViewController: EventViewController {

    func viewDidLoad(){
        super.viewDidLoad()
        let blue = BlueViewController(nibName: "Blue", bundle: nil)
        let red = RedViewController(nibName: "Red", bundle: nil)

        self.listenTo(blue, "some:blue:event", callback: onBlueEvent)
        self.listenTo(red, "some:red:event",  callback: onRedEvent)

        addChildViewController(blue)
        addChildViewController(red)

        view.addSubView(blue.view)
        view.addSubView(red.view)
    }

    // Note that it casts the values back to what you expect
    // vs NSNotification which requires manual casting at runtime
    func onBlueEvent(sender: BlueViewController, data: Int){
        print("\(sender): \(data)")
    }

    // Note that it casts the values back to what you expect
    // vs NSNotification which requires manual casting at runtime
    func onRedEvent(sender: BlueViewController, data: Bool){
        print("\(sender): \(data)")
    }

    func viewDidDisappear(animated: Bool){
        super.viewDidDisappear(animated)

        // free the listeners
        self.stopListening()
    }
}

class BlueViewController: EventViewController{
    func viewDidLoad(){
        super.viewDidLoad()
        doSomething()
    }

    func doSomething(){
        self.trigger("some:blue:event", 36)
    }
}

class RedViewController : EventViewController{
    func viewDidLoad(){
        super.viewDidLoad()
        doSomething()
    }

    func doSomething(){
        self.trigger("some:red:event", true)
    }
}
```
